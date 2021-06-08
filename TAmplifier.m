graphics_toolkit qt
%Function
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

function update_plot (obj, init = false)

  h = guidata (obj);
  persistent ValvEq = pi;
  
  switch (gcbo)
  %Valvs Equation
  %---------------------
  %Valv1
  case {h.valv_radio_1}
      set (h.valv_radio_2, "value", 0);
      set (h.valv_radio_3, "value", 0);
      ValvEq = 1;
      printf('test 1 ');
      printf(num2str(ValvEq));
    %Valv2  
    case {h.valv_radio_2}
      set (h.valv_radio_1, "value", 0);
      set (h.valv_radio_3, "value", 0);
      ValvEq = 2;
      printf('test 2 ');
      printf(num2str(ValvEq));
    %Valv3  
    case {h.valv_radio_3}
      set (h.valv_radio_2, "value", 0);
      set (h.valv_radio_1, "value", 0);
      ValvEq = 3;
      printf('test 3 ');
      printf(num2str(ValvEq));
      
    case {h.start_pushbutton}     
        init = true;
  endswitch
  
  %Run
  if (init)
    fs =44.1e3;  
    sig = smc_record(fs,10);
    printf(num2str(ValvEq));
    if( ValvEq==1 )
      Y = (3.*sig/2.0).*(1-(sig.*sig/3));
    endif  
    if( ValvEq==2 )
      NormalizeSig = -1 + 2.*(sig - min(sig))./(max(sig) - min(sig));
      Y = (abs(2.*NormalizeSig)-(NormalizeSig.*NormalizeSig)).*sign(NormalizeSig);
    endif
    if( ValvEq==3 )
      NormalizeSig = -1 + 2.*(sig - min(sig))./(max(sig) - min(sig));
      Y = (-3.153*NormalizeSig.*NormalizeSig)+(9.9375*NormalizeSig);
    endif
    player=audioplayer(Y, fs);
    play(player);
    while(isplaying(player))
      % Waiting for sound to finish
    endwhile
    figure();
    plot(Y);
    title('Analise de Espectro');
    xlabel('Tempo');
    ylabel('Amplitude');
    zoom on;
  endif
endfunction 


%Interface
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

h.name_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "T-Amplifier",
                           "horizontalalignment", "left",
                           "position", [0.4 0.85 0.17 0.08]);
                           
h.valvs_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "Equations:",
                           "horizontalalignment", "left",
                           "position", [0.05 0.7 0.35 0.08]);                           
                           
%Valv Radio
%---------------
h.valv_radio_1 = uicontrol ("style", "radiobutton",
                                    "units", "normalized",
                                    "string", "Valv1",
                                    "callback", @update_plot,
                                    "position", [0.20 0.6 0.15 0.04]);

h.valv_radio_2 = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Valv2",
                                   "callback", @update_plot,
                                   "value", 0,
                                   "position", [0.45 0.6 0.15 0.04]);                                

h.valv_radio_3 = uicontrol ("style", "radiobutton",
                                   "units", "normalized",
                                   "string", "Valv 3",
                                   "callback", @update_plot,
                                   "value", 0,
                                   "position", [0.7 0.6 0.15 0.04]);   

%Sliders
%---------------
h.volume_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "Volume:",
                           "horizontalalignment", "left",
                           "position", [0.05 0.4 0.35 0.08]);

h.volume_slider = uicontrol ("style", "slider",
                            "units", "normalized",
                            "string", "slider",
                            "callback", @update_plot,
                            "value", 0.4,
                            "position", [0.2 0.3 0.20 0.06]);
                            
%ButtonStart
%--------------
h.start_pushbutton = uicontrol ("style", "pushbutton",
                                "units", "normalized",
                                "string", "Start Simulation",
                                "callback", @update_plot,
                                "position", [0.32 0.05 0.35 0.09]);                            
                            
 
guidata (gcf, h) 
