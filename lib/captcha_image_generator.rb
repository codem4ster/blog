require 'vips'

class CaptchaImageGenerator
  attr_accessor :hash
  INPUTS = %w[OLAY İYİCE KARIŞIK ALMIŞTI OLAYI BÜRO TAKİP OLAYA KARIŞAN TEŞHİS
              EDİLİP ŞUBEYE GÖTÜREN ARAÇ ARABA ŞANS ESERİ HENÜZ HURDAYA POLİS
              OTOPARK BİLGİ SONRA HEMEN ARACI BAŞLADI ARABADA KALAN KAÇIRAN
              KİŞİNİN PARMAK ARANDI FAKAT İZİNE ARKA KÜÇÜK ÇAKMAK ÜNLÜ GECE
              ARMASI VARDI GECE SAHİBİ OLAN BİRKAÇ DEFA DAİR İHBAR ARAMA KARARI
              FAKAT DELİL ONUN PARMAĞI GİBİ TAKİBE ŞÜPHELİ KULÜBÜ KESKİN ONLARI
              ONLARSA GÜNLÜK DİKKAT ÇEKEN GELEN GELİYOR KISA SÜRE BAKIŞTA KURYE
              PARAYI VEREN GENÇTE ONLARLA AYNI GENÇLER ALINDI HEPSİ LİSE TESPİT
              BİRİNİ ALDILAR TAKİP İÇİN GENCİN EVİNE EVDEN HEMEN PEŞİNE GENÇ
              YARIM SAAT BİRİYLE BULUŞUP PAKET ALDI DEVAM BİRDEN FAZLA KİŞİ
              NİHAİ KİŞİYE HIZLI ŞEKİLDE ÇANTA AYNI ANDA GENCİN EVİNDEN ÇIKAN
              EKİP SINIRLI DAHA GENİŞ ÇAPLI ÇEMBER SONUNDA İKİZLER UMUT IŞIĞI
              ESKİ ANADOLU KRALI ANİDEN KRAL ÇARE BULMAK KİMİSİ ARAR ÇAREYİ KİMİ
              LOKMAN HEKİM ADANA YERDEN VERİMLİ TATLISI ÇİÇEĞİN GÜZEL AĞACIN
              YEŞİLİ OTUN YETİŞİR ŞİFA OLACAK BİTKİYİ BULUR ARADIĞI HIZIR ÇIKAR
              HAZIR SÖYLER İLAÇLA MİSİS KÖPRÜSÜ NDEN NEHRE DÖKER SUYA DÖKÜLEN
              İKSİRİ YETİŞEN AĞAÇTA ÇİÇEKTE MEYVEDE SAĞLIK VERMEYE EDER KEDİ
              VARMIŞ ÇÜNKÜ EVİN ÇOCUĞA ÇOCUK KEDİYİ DAKİKA DEMEMİŞ ÇÜNKÜ EVDE
              GİTTİĞİ ÇOCUK BABA BİZİM DİYE SORMUŞ BABASI ŞÖYLE CEVAP VERMİŞ
              OLAMAZ AİLESİ DEMİŞ ANCAK ISRAR ETMİŞ İKNA KEDİYİ SENE KEDİNİN
              ANNESİ BABASI ORTAYA ÇIKMIŞ KEDİ ÖNCE GİTMEK ONLARIN YANINA GİTMİŞ
              DİYALOG GEÇMİŞ NEDEN GİDİYOR BİZİ BIRAKTI OĞLUM ONLAR DEĞİLİZ ÖYLE
              OLMASI ANLADIM BABA MUTLU YOLA HAYATA YENİDEN HİNTLİ ERMİŞ GANJ
              NEHRİ ÖFKE İÇİNDE BAĞIRAN AİLE GÖRMÜŞ DÖNÜP BİRİ DEYİNCE İNSAN YANI
              ALÇAK TONU NİYE TEKRAR ZAMAN UZAK ZORUNDA KADAR ARADA AÇILAN
              GEREKİR PEKİ OLUR YERİNE SAKİNCE MESAFE YOKTUR AZDIR SEVERSE ARTIK
              SADECE BİLE GEREK KALMAZ YETERLİ İŞTE GERÇEK ANLAMDA SEVEN İNSANIN
              BÖYLE ŞEYDİR DAHA BAKARAK NEDENLE ARASINA İZİN ARANIZA KOYACAK
              DURUN AKSİ ARTTIĞI GELİR GERİYE YOLU]

  def initialize(width, height)
    @width = width
    @height = height
  end

  def generate
    @hash = INPUTS.sample
    final = background.composite text, :over
    final.write_to_buffer ".jpg", Q: 90
  end

  def wobble(image)
    # a warp image is a 2D grid containing the new coordinates of each pixel with
    # the new x in band 0 and the new y in band 1
    #
    # you can also use a complex image
    #
    # start from a low-res XY image and distort it
    xy = Vips::Image.xyz image.width.to_f / 2.8, image.height.to_f / 2.8
    x_distort = Vips::Image.gaussnoise xy.width, xy.height
    y_distort = Vips::Image.gaussnoise xy.width, xy.height
    xy += x_distort.bandjoin(y_distort) / 150
    xy = xy.resize 2.8
    xy *= 2.8
    # apply the warp
    image.mapim xy
  end

  def background
    channels = (1..3).map do
      Vips::Image.gaussnoise @width, @height, mean: 400, sigma: 160
    end
    Vips::Image.bandjoin(channels).copy(interpretation: :srgb).cast(:uchar)
  end

  def text
    text_layer = Vips::Image.black 1, 1
    x_position = 0
    char_width = @width.to_f / @hash.length
    char_height = @height
    width_offset = (char_width * 0.1).round
    height_offset = (char_height * 0.1).round
    @hash.each_char do |c|
      letter = Vips::Image.text c, width: char_width - width_offset*2,
                                height: char_height - height_offset*2
      # random scale and rotate
      letter = letter.similarity scale: Random.rand(0.1) + 0.9,
                                 angle: Random.rand(40) - 20
      image = letter.gravity :centre, char_width, char_height
      # random wobble
      image = wobble image
      # random colour
      colour = (1..3).map {Random.rand(255)}
      image = image.ifthenelse(colour, 0, blend: true)
      # tag as 9-bit srgb
      image = image.copy(interpretation: :srgb).cast(:uchar)
      # position at our write position in the image
      image = image.embed x_position, 0, image.width + x_position, image.height
      text_layer += image
      text_layer = text_layer.cast(:uchar)
      x_position += char_width
    end
    # make an alpha for the text layer: just a mono version of the image, but scaled
    # up so the letters themselves are not transparent
    alpha = (text_layer.colourspace("b-w") * 3).cast(:uchar)
    text_layer.bandjoin alpha
  end
end

gen = CaptchaImageGenerator.new(100, 32)
gen.generate