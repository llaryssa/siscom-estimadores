clc %limpa a tela
clear all;
maxsimulacoes  = 2000; %numero max de simulacoes, proj = 2000
initialframe = 64; %numero inicial de slots no frame, proj = 64
initialetiquetas = 100 ; % numero inicial de etiquetas para cada teste , proj = 100
stepetiquetas = 100; % numero do passo do for de etiquetas, proj = 100
finaletiquetas = 1000; % numero final de etiquetas, proj  = 1000

for algorithm = 1:3
    
    grcolisoes = [];
    grvazio = [];
    grsucesso = [];
    grframes = [];

for etiquetas = initialetiquetas:stepetiquetas:finaletiquetas
    simcolisoes = [];
    simvazio = [];
    simsucesso = [];
    simframes = [];
    
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
            muting = muting + sucesso;
            sucesso = muting;
            
            if sucesso == etiquetas % ou vazios ==0
                terminou = true;
            else
                if algorithm == 1
                    frames = frames + 2*colisoes;
                elseif algorithm == 2
                    frames = frames + 2.38*colisoes;
                elseif algorithm == 3
                    [frames, nestimado] = eomLee(frames, sucesso, colisoes);
                end
                
                  frames = round(frames);
            end
            
            % atualizando os graficos
            totalcolisoes = totalcolisoes + colisoes;
            totalvazio = totalvazio + vazio;
            totalsucesso = totalsucesso + sucesso;
            totalframes = totalframes + frames;
        end
        
        simcolisoes = [simcolisoes totalcolisoes];
        simvazio = [simvazio totalvazio];
        simframes = [simframes totalframes];
        simsucesso = [simsucesso totalsucesso];
               
    end
    
    grcolisoes = [grcolisoes [etiquetas; mean(simcolisoes)]];
    grvazio = [grvazio [etiquetas; mean(simvazio)]];
    grsucesso = [grsucesso [etiquetas; mean(simsucesso)]];
    grframes = [grframes [etiquetas; mean(simframes)]];
    
    disp('-------------------------------------');
end

    disp('virou o algoritmo');

    todoscolisoes(:,:,algorithm) = grcolisoes;
    todosvazio(:,:,algorithm) = grvazio;
    todossucesso(:,:,algorithm) = grsucesso;
    todosframes(:,:,algorithm) = grframes;

end

figure; hold on;
plot(todoscolisoes(1,:,1), todoscolisoes(2,:,1), 'm');
plot(todoscolisoes(1,:,2), todoscolisoes(2,:,2), 'r');
plot(todoscolisoes(1,:,3), todoscolisoes(2,:,3), 'b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Colisões'); 
xlabel('Quantidade de etiquetas');
ylabel('Quantidade de colisões');
print('colisoes', '-dpng');

figure; hold on;
plot(todossucesso(1,:,1), todossucesso(2,:,1), 'm');
plot(todossucesso(1,:,2), todossucesso(2,:,2), 'r');
plot(todossucesso(1,:,3), todossucesso(2,:,3), 'b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Sucessos'); 
xlabel('Quantidade de etiquetas');
ylabel('Quantidade de sucessos');
print('sucessos', '-dpng');

figure; hold on;
plot(todosvazio(1,:,1), todosvazio(2,:,1), 'm');
plot(todosvazio(1,:,2), todosvazio(2,:,2), 'r');
plot(todosvazio(1,:,3), todosvazio(2,:,3), 'b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Slots vazios'); 
xlabel('Quantidade de etiquetas');
ylabel('Quantidade de slots vazios');
print('vazios', '-dpng');

figure; hold on;
plot(todosframes(1,:,1), todosframes(2,:,1), 'm');
plot(todosframes(1,:,2), todosframes(2,:,2), 'r');
plot(todosframes(1,:,3), todosframes(2,:,3), 'b');
legend('Lower-Bound', 'Schoute', 'Eom-Lee');
title('Número de slots'); 
xlabel('Quantidade de etiquetas');
ylabel('Números de slots');
print('slots', '-dpng');

