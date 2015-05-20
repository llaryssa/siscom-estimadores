% clc %limpa a tela
maxsimulacoes  = 1; %numero max de simulacoes, proj = 2000
initialframe = 64; %numero inicial de slots no frame, proj = 64
initialetiquetas = 100 ; % numero inicial de etiquetas para cada teste , proj = 100
stepetiquetas = 500; % numero do passo do for de etiquetas, proj = 100
finaletiquetas = 500; % numero final de etiquetas, proj  = 1000


for etiquetas = initialetiquetas:stepetiquetas:finaletiquetas
    
    for simulacao = 1:maxsimulacoes
        frames = initialframe;
        terminou = false;
        iteracoes = 0;
        muting = 0;
        
        totalcolisoes = 0;
        totalvazio = 0;
        totalsucesso = 0;
        totalframes = 0;
        
        while ~terminou
            iteracoes = iteracoes + 1;
            slots = zeros(frames,1);
            
            % preenche os slots randomicamente
            for et = 1:(etiquetas - muting)
                framescolhido = randi(frames);
                slots(framescolhido,1) = slots(framescolhido,1) + 1;
            end
            
            vazio = sum(slots == 0);
            colisoes = sum(slots > 1);
            sucesso = sum(slots == 1);
            
            % ativando o muting
%             muting = muting + sucesso;
%             sucesso = muting;
            
            if sucesso == etiquetas % ou vazios ==0
                terminou = true;
            else
                % [frames, nestimado] = estimador(frames, sucesso, colisoes)
                [frames, nestimado] = eomLee(frames, sucesso, colisoes);
%                   frames = frames + 2*colisoes;
%                   frames = frames + 2.38*colisoes;
                  
                  frames = round(frames);
            end
            
            % atualizando os graficos
            totalcolisoes = totalcolisoes + colisoes;
            totalvazio = totalvazio + vazio;
            totalsucesso = totalsucesso + sucesso;
            totalframes = totalframes + frames;
            disp(['it: ' num2str(iteracoes) ' - sucesso: ' num2str(sucesso) ' - colisoes: ' num2str(colisoes) ' - frame: ' num2str(frames)]);
        end
        
        disp([num2str(etiquetas) ' ETIQUETAS - ' num2str(simulacao) ' SIMULAÇÃO.'])
        disp(['iterações: ' num2str(iteracoes)]);
        disp(['media de frames: ' num2str(totalframes/iteracoes)]);
        disp(['media de colisoes: ' num2str(totalcolisoes/iteracoes)]);
        disp(['media de vazios: ' num2str(totalvazio/iteracoes)]);
        disp(['media de sucesso: ' num2str(totalsucesso/iteracoes)]);
        disp('-------------------------------------'); 
    end
    disp('-------------------------------------');
end


