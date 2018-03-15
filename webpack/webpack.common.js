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
        'pages/users/registration': 'users/registration/registration.coffee',
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
