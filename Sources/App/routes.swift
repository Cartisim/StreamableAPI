import Vapor

func routes(_ app: Application) throws {
    
    app.group(Constants.shared.BASE) { api in
        //MARK: Route Groups
        let tokenProtected = app.grouped(Constants.shared.BASE)
            .grouped(UserAuthenticator())
        let adminProtected = app.grouped(Constants.shared.BASE)
            .grouped(UserAuthenticator())
            .grouped(AdminMiddleware())
        let purchasedProtected = app.grouped(Constants.shared.BASE)
            .grouped(UserAuthenticator())
            .grouped(PurchasedMiddleware())
        
        //MARK: Auth Routes
        api.group(Constants.shared.AUTH_ROUTE) { auth in
            let authenticationController = AuthenticationController()
            auth.post(Constants.shared.REGISTER, use: authenticationController.register)
            
            auth.post(Constants.shared.LOGIN, use: authenticationController.login)
            
            auth.group(Constants.shared.EMAIL_VERIFICATION) { emailVerificationRoutes in
                emailVerificationRoutes.post(use: authenticationController.sendEmailVerification)
                emailVerificationRoutes.get(use: authenticationController.verifyEmail)
            }
            
            auth.group(Constants.shared.REST_PASSWORD) { resetPasswordRoutes in
                resetPasswordRoutes.post(use: authenticationController.resetPassword)
                resetPasswordRoutes.get(Constants.shared.VERIFY, use: authenticationController.verifyResetPasswordToken)
            }
            auth.post(Constants.shared.RECOVER, use: authenticationController.recoverAccount)
            auth.post(Constants.shared.ACCESS_TOKEN, use: authenticationController.refreshAccessToken)
            
            // Authentication required
            auth.group(UserAuthenticator()) { authenticated in
                authenticated.get(Constants.shared.CURRENT_USER, use: authenticationController.getCurrentUser)
                authenticated.delete(Constants.shared.DELETE_CURRENT_USER, Constants.shared.USER_ID, use: authenticationController.deleteCurrentUser)
                authenticated.post(Constants.shared.EDIT_CURRENT_USER, Constants.shared.USER_ID, use: authenticationController.editCurrentUser)
            }
            auth.group(UserAuthenticator(), AdminMiddleware()) { adminP in
                adminP.get(Constants.shared.USER, Constants.shared.USER_ID ,use: authenticationController.fetchUser)
                adminP.get(Constants.shared.ALL, use: authenticationController.fetchEagerAllUsers)
                adminP.put(Constants.shared.EDIT_USER, Constants.shared.USER_ID, use: authenticationController.editUser)
                adminP.delete(Constants.shared.DELETE_USER, Constants.shared.USER_ID, use: authenticationController.deleteUser)
            }
        }
        
        //MARK: Category Routes
        let categoryController = CategoryController()
        adminProtected.post(Constants.shared.CATEGORY, use: categoryController.postCategory)
        adminProtected.post(Constants.shared.CATEGORY, Constants.shared.CATEGORY_ID, use: categoryController.editCategory)
        adminProtected.post(Constants.shared.CATEGORY, Constants.shared.CATEGORY_ID, Constants.shared.VIDEO, Constants.shared.VIDEO_ID, use: categoryController.addCourseToCategory)
        adminProtected.put(Constants.shared.CATEGORY, Constants.shared.CATEGORY_ID, use: categoryController.editCategory)
        adminProtected.delete(Constants.shared.CATEGORY, Constants.shared.CATEGORY_ID, use: categoryController.deleteCategory)
        api.get(Constants.shared.CATEGORY, Constants.shared.CATEGORY_ID, use: categoryController.fetchEagerCategory)
        api.get(Constants.shared.CATEGORY, use: categoryController.fetchEagerCategories)
        
        //MARK: Order Routes
        let orderController = OrderController()
        tokenProtected.post(Constants.shared.ORDER, Constants.shared.ORDER_ID, Constants.shared.VIDEO, Constants.shared.VIDEO_ID, use: orderController.addVideoToOrder)
        tokenProtected.post(Constants.shared.ORDER, use: orderController.postOrder)
        adminProtected.get(Constants.shared.ORDER, use: orderController.fetchEagerOrders)
        purchasedProtected.get(Constants.shared.ORDER, Constants.shared.ORDER_ID, use: orderController.fetchEagerOrder)
        
        //MARK: Video Routes
        let videoController = VideoController()
        api.get(Constants.shared.CATEGORY_VIDEO, use: categoryController.fetchCategoriesVideos)
        api.get(Constants.shared.CATEGORY_VIDEO, Constants.shared.CATEGORY_ID, use: categoryController.fetchCategoryVideos)
        tokenProtected.post(Constants.shared.VIDEO, use: videoController.postVideo)
        adminProtected.put(Constants.shared.VIDEO, Constants.shared.VIDEO_ID, use: videoController.editVideo)
        adminProtected.delete(Constants.shared.VIDEO, Constants.shared.VIDEO_ID, use: videoController.deleteVideo)
        tokenProtected.get(Constants.shared.VIDEO, Constants.shared.VIDEO_ID, use: videoController.fetchEagerVideo)
        tokenProtected.get(Constants.shared.VIDEO, use: videoController.fetchEagerVideos)
        
        //MARK: Channel Routes
        let channelController = ChannelController()
//        tokenProtected.post(Constants.shared.CHANNEL, use: channelController.postChannel)
        tokenProtected.get(Constants.shared.CHANNEL, Constants.shared.CHANNEL_ID, use: channelController.fetchEagerChannel)
//        tokenProtected.get(Constants.shared.CHANNEL, use: channelController.fetchEagerChannels)
        tokenProtected.delete(Constants.shared.CHANNEL, Constants.shared.CHANNEL_ID, use: channelController.deleteChannel)
        
        //MARK: SubChannel Routes
        let subChannelController = SubChannelController()
        tokenProtected.post(Constants.shared.SUB_CHANNEL, use: subChannelController.postSubChannel)
        tokenProtected.get(Constants.shared.SUB_CHANNEL, Constants.shared.SUB_CHANNEL_ID, use: subChannelController.fetchEagerSubChannel)
        tokenProtected.get(Constants.shared.SUB_CHANNEL, use: subChannelController.fetchEagerSubChannels)
        tokenProtected.delete(Constants.shared.SUB_CHANNEL, Constants.shared.SUB_CHANNEL_ID, use: subChannelController.deleteSubChannel)
        
        //MARK: Messages Routes
        let messageController = MessageController()
        tokenProtected.post(Constants.shared.MESSAGE, use: messageController.postMessage)
        tokenProtected.get(Constants.shared.MESSAGE, Constants.shared.MESSAGE_ID, use: messageController.fetchEagerMessage)
        tokenProtected.get(Constants.shared.MESSAGE, use: messageController.fetchEagerMessages)
        tokenProtected.delete(Constants.shared.MESSAGE, Constants.shared.MESSAGE_ID, use: messageController.deleteMessage)
        
    }
}

