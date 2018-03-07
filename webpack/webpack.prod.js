const path = require('path');
const merge = require('webpack-merge');
const common = require('./webpack.common.js');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CleanWebpackPlugin = require('clean-webpack-plugin');
const ManifestPlugin = require('webpack-manifest-plugin');
const MinifyPlugin = require("babel-minify-webpack-plugin");
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CompressionPlugin = require("compression-webpack-plugin")
const extractSass = new ExtractTextPlugin({
    // filename: "[name].[contenthash].css",
    filename: "[name].[contenthash].css",
    allChunks: true
});


module.exports = merge(common, {
    devtool: 'none',
    module: {
        rules: [
            {
                test: /\.css$/,
                use: extractSass.extract({
                    fallback: "style-loader",
                    use: "css-loader"
                })
            },
            {
                test: /\.scss$/,
                use: extractSass.extract({
                    use: [{
                        loader: "css-loader"
                    },{
                        loader: "resolve-url-loader",
                        options: {
                            sourceMap: true
                        }
                    }, {
                        loader: "sass-loader?name=[name].[contenthash].css",
                        options: {
                            sourceMap: true
                        }
                    }],
                    // use style-loader in development
                    fallback: "style-loader?name=[name].[contenthash].css"
                })
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[path][name].[hash].[ext]',
                        }
                    },
                    {
                        loader: 'image-webpack-loader',
                        options: {
                            bypassOnDebug: true
                        }
                    }
                ]
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[path][name].[hash].[ext]',
                        }
                    },
                ]
            },
            {
                test: /\.coffee$/,
                use: [{
                    loader: 'coffee-loader',
                    options: {
                        sourceMap: false
                    }
                }]
            }
        ]
    },
    plugins: [
        new CleanWebpackPlugin(['dist'], {
            root: path.resolve(__dirname, '../public'),
        }),
        new ManifestPlugin({
            fileName: path.resolve(__dirname, '../config') + '/webpack_manifest.json',
        }),
        new MinifyPlugin({}, {}),
        extractSass,
        new OptimizeCssAssetsPlugin({
            cssProcessor: require('cssnano'),
            cssProcessorOptions: { discardComments: { removeAll: true } },
            canPrint: true
        }),
        new CompressionPlugin({
            test: /(\.js|\.css|\.svg)$/
        })
    ]
});