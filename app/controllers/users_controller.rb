class UsersController < ApplicationController
    
    wrap_parameters :user, include: [:username, :password]

    def index
        @users = User.all
        render json: @users
    end

    def show
        @user = User.find(params[:id])
        render json: @user
    end

    def login
        user = User.find_by(username: params[:username])
    
        if user && user.authenticate(params[:password])
            payload = {user_id: user.id}
            token = JWT.encode(payload, 'my$ecretK3y', 'HS256')
            render json: {user: UserSerializer.new(user), token: token}
                else
          render json: { error: 'Invalid username or password.'}
        end
      end

    def current_session
       token = request.headers['Authorization'].split(' ')[1]
        decoded_token = JWT.decode(token, 'my$ecretK3y', true, { algorithm: 'HS256' })

        user_id = decoded_token[0]['user_id']

        user = User.find(user_id)

        render json: {user: UserSerializer.new(user)}
    end


    # def current_user
    #     if decoded_token
    #         user_id = decoded_token[0]['user_id']
    #         User.find_by(id: user_id)
    #     end
    # end

      def create
        @user = User.create(user_params)
            if @user.valid?
                payload = { id: @user.id}
                token = JWT.encode(payload, 'my$ecretK3y', 'HS256')
                render json: { id: @user.id, username: @user.username, token: token }
            else
                render json: { error: 'failed to create user' }, status: :not_acceptable
            end
        end

    def update
        @user = User.find(params[:id])
        @user.update(user_params)
        render json: @user
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        render json: {message: 'success'}
    end

    def auth_header
        request.headers['Authorization']
    end
    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'my$ecretK3y', true, { algorithm: 'HS256' })
            rescue JWT::DecodeError 
                "Bad token error"
            rescue JWT::VerificationError 
                "Bad secret error"
            end
        end
    end
    def current_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            User.find_by(id: user_id)
        end
    end



    private

    def user_params
        params.require(:user).permit(:username, :password)
    end

end
