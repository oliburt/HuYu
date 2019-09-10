class GamesController < ApplicationController
    before_action :require_authentication
    
    def new
        @game = Game.new    

    end

    def create
        @game = Game.create(game_params)
        session[:game_id] = @game.id
        @player1 = Player.create(user_id: current_user.id, game_id: @game.id)
        session[:player1_id] = @player1.id
        @player1.board = Board.new 
        @player1.board.cards << Card.all
        @player1.board.questions << Question.all
        @player1.save
        session[:board1_id] = @player1.board.id
        
        if params[:game][:game_type] == '2 Players'
            redirect_to controller: 'players', action: :new
        else
            @player2 = Player.create(user_id: User.find_by(username: "COMPUTER").id, game_id: session[:game_id])
            session[:player2_id] = @player2.id
            @player2.board = Board.new 
            @player2.board.cards << Card.all
            @player2.board.questions << Question.all
            @player2.card_picked = Card.all.sample.id
            @player2.save
            session[:board2_id] = @player2.board.id
            redirect_to "/players/#{player1.id}/card_pick_form"
        end
    end

    private

    def game_params
        params.require(:game).permit(:game_type)
    end
end
