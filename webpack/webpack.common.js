const path = require('path');
const webpack = require('webpack');


module.exports = {
    resolve: {
        modules: [
            path.resolve(__dirname, "components"),
            path.resolve(__dirname, "fonts"),
            path.resolve(__dirname, "images"),
            path.resolve(__dirname, "layouts"),
            path.resolve(__dirname, "pages"),
            path.resolve(__dirname, "vendor"),
            "node_modules"]
    },
    entry: {
        'layouts/main/application': 'main/application.coffee',
        'pages/user/login': 'user/login/login.coffee',
        'pages/user/new': 'user/new/new.coffee',
        'pages/user/activate': 'user/activate/activate.coffee',
        'pages/user/password_lost': 'user/password_lost/password_lost.coffee',
        'pages/home': 'home/home.coffee',
    },
    output: {
        filename: '[name].[chunkhash].js',
        path: path.resolve(__dirname, '../public/dist'),
        publicPath: '/dist/'
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin({
            name: 'vendor',
            minChunks: 2
        })
    ]
};
