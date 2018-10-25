function data_gui
% data_gui Select a data set from the pop-up menu, then
% click plot pushbutton. Clicking the button
% plots the selected data in the axes.

% Generate the data to plot.
s = [7,7,6,7,3,4,7,7,7,2,7,7,4,7,6,5];
sampsize = cumsum(3*s);
n_1 = ["Machine strain (%)";"End-to-end strain (%)";"fiducial strain (%)";"D band (nm)";...
    "Cross sec (nm)^2";"Deformation (nm)"; "SD Deformation (nm)";"Height (nm)";...
    "SD Height (nm)";"Modulus (MPa)";"SD Modulus (MPa)";"RMS Modulus (MPa)";...
    "(mod-RMS)/(mod + rms)";"Height - Deformation (nm)"];
n_2 = ["Machine strain (%)";"End-to-end strain (%)";"fiducial strain (%)";"D band (%)";...
    "Cross sec (%)";"Deformation (%)"; "SD Deformation (%)";"Height (%)";...
    "SD Height (%)";"Modulus (%)";"SD Modulus (%)";"RMS Modulus (%)";...
    "(mod-RMS)/(mod + RMS)  (%)";"Height - Deformation (%)"];
n = [n_1,n_2];

fid = fopen('C:\Users\Chris\Desktop\full_data.txt');
%fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE6_21_raw.txt');
data = textscan(fid,'%f', 'Delimiter','\t');
data_raw = transpose(reshape(data{1},[14,length(data{1})/14]));

fid = fopen('C:\Users\Chris\Desktop\school\Dalhousie\DATA_Chris\AFM_images\SE\sample_data_SE6_21_strain.txt');
data = textscan(fid,'%f', 'Delimiter','\t');
data_strain = transpose(reshape(data{1},[14,length(data{1})/14]));

data = zeros(length(data_strain(:,1)),14,2);

%Create a 3D array of all data, strain and raw
data(:,1:length(data_raw(1,:)),1) = data_raw;
data(:,:,2) = data_strain;


%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[360,600,1000,600]);

% Construct the components.

%dropdown menues and text
hXtext  = uicontrol('Style','text','String','Select independent axis data',...
           'Position',[1300,575,200,15]);
hX    = uicontrol('Style','popupmenu',...
             'String',["Machine strain";"End-to-end strain";"fiducial strain";"D band";...
    "Cross sec";"Deformation"; "SD Deformation";"Height";...
    "SD Height";"Modulus";"SD Modulus";"RMS Modulus";...
    "(mod-RMS)/(mod + rms)";"Height - Deformation"],'Position',[1300,550,150,25],...
             'Callback',@X_Callback);
hYtext  = uicontrol('Style','text','String','Select dependent axis data',...
           'Position',[1300,525,200,15]);
hY    = uicontrol('Style','popupmenu',...
             'String',["Machine strain";"End-to-end strain";"fiducial strain";"D band";...
    "Cross sec";"Deformation"; "SD Deformation";"Height";...
    "SD Height";"Modulus";"SD Modulus";"RMS Modulus";...
    "(mod-RMS)/(mod + rms)";"Height - Deformation"],'Position',[1300,500,150,25],...
             'Callback',@Y_Callback);
hDtextX  = uicontrol('Style','text','String','Select Dataset (Independent axis)',...
           'Position',[780,475,200,15]);
hDX = uicontrol('Style','popupmenu',...
             'String',["Raw","Strain"],'Position',[1300,450,150,25],...
             'Callback',@DX_Callback);
hDtextY  = uicontrol('Style','text','String','Select Dataset (Dependent axis)',...
           'Position',[780,425,200,15]);
hDY = uicontrol('Style','popupmenu',...
             'String',["Raw","Strain"],'Position',[1300,400,150,25],...
             'Callback',@DY_Callback);
         
hDtext  = uicontrol('Style','text','String','Select samples to include',...
           'Position',[325,375,200,15]);
       
%Radio buttons
SE6 = uicontrol('Style','checkbox',...
             'String','SE6','Position',[825,350,70,25],...
             'Callback',@SE6_Callback);
SE7 = uicontrol('Style','checkbox',...
             'String','SE7','Position',[825,325,70,25],...
             'Callback',@SE7_Callback);
SE8 = uicontrol('Style','checkbox',...
             'String','SE8','Position',[825,300,70,25],...
             'Callback',@SE8_Callback);
SE9 = uicontrol('Style','checkbox',...
             'String','SE9','Position',[825,275,70,25],...
             'Callback',@SE9_Callback);
SE10 = uicontrol('Style','checkbox',...
             'String','SE10','Position',[825,250,70,25],...
             'Callback',@SE10_Callback);
SE11 = uicontrol('Style','checkbox',...
             'String','SE11','Position',[825,225,70,25],...
             'Callback',@SE11_Callback);
SE12 = uicontrol('Style','checkbox',...
             'String','SE12','Position',[825,200,70,25],...
             'Callback',@SE12_Callback);
SE13 = uicontrol('Style','checkbox',...
             'String','SE13','Position',[825,175,70,25],...
             'Callback',@SE13_Callback);
SE14 = uicontrol('Style','checkbox',...
             'String','SE14','Position',[875,350,70,25],...
             'Callback',@SE14_Callback);
SE15 = uicontrol('Style','checkbox',...
             'String','SE15','Position',[875,325,70,25],...
             'Callback',@SE15_Callback);
SE16 = uicontrol('Style','checkbox',...
             'String','SE16','Position',[875,300,70,25],...
             'Callback',@SE16_Callback);
SE17 = uicontrol('Style','checkbox',...
             'String','SE17','Position',[875,275,70,25],...
             'Callback',@SE17_Callback);
SE18 = uicontrol('Style','checkbox',...
             'String','SE18','Position',[875,250,70,25],...
             'Callback',@SE18_Callback);
SE19 = uicontrol('Style','checkbox',...
             'String','SE19','Position',[875,225,70,25],...
             'Callback',@SE19_Callback);
SE20 = uicontrol('Style','checkbox',...
             'String','SE20','Position',[875,200,70,25],...
             'Callback',@SE20_Callback);
SE21 = uicontrol('Style','checkbox',...
             'String','SE21','Position',[875,175,70,25],...
             'Callback',@SE21_Callback);
%Plot pushbutton
hPlot = uicontrol('Style','pushbutton',...
             'String','Plot','Position',[875,150,70,25],...
             'Callback',@Plot_Callback);
hClear = uicontrol('Style','pushbutton',...
             'String','Clear','Position',[875,125,70,25],...
             'Callback',@Clear_Callback);
    

ha = axes('Units','pixels','Position',[70,60,700,525]);
align([hXtext,hX,hYtext,hY,hDtext,hDX,hDY],'Center','None');

% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';
ha.Units = 'normalized';
hsurf.Units = 'normalized';
hmesh.Units = 'normalized';
hcontour.Units = 'normalized';
htext.Units = 'normalized';
hpopup.Units = 'normalized';

% Create a plot in the axes.
current_include = zeros(1,length(s));
current_range = 1:length(data(:,1,1));
current_X = 1;
current_Y = 2;
current_DX = 1;
current_DY = 1;
plot(data(current_range,current_X,current_DX), data(current_range,current_Y,current_DY),'*');
xlabel(n(current_X,current_DX))
ylabel(n(current_Y,current_DY))

% Assign the a name to appear in the window title.
f.Name = 'Plotting GUI';

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

% Push button callbacks. Each callback plots current_data in the
  % specified plot type.
  function SE6_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(1) = 1;
      elseif val ==0
        current_include(1) = 0;
      end
  end

  function SE7_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(2) = 1;
      elseif val ==0
        current_include(2) = 0;
      end
  end

  function SE8_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(3) = 1;
      elseif val ==0
        current_include(3) = 0;
      end
  end

  function SE9_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(4) = 1;
      elseif val ==0
        current_include(4) = 0;
      end
  end

  function SE10_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(5) = 1;
      elseif val ==0
        current_include(5) = 0;
      end
  end

  function SE11_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(6) = 1;
      elseif val ==0
        current_include(6) = 0;
      end
  end

  function SE12_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(7) = 1;
      elseif val ==0
        current_include(7) = 0;
      end
  end

  function SE13_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(8) = 1;
      elseif val ==0
        current_include(8) = 0;
      end
  end

  function SE14_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(9) = 1;
      elseif val ==0
        current_include(9) = 0;
      end
  end
  function SE15_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(10) = 1;
      elseif val ==0
        current_include(10) = 0;
      end
  end
  function SE16_Callback(source,eventdata) 
      val = get(source,'Value');
      if val ==1
        current_include(11) = 1;
      elseif val ==0
        current_include(11) = 0;
      end
  end
  function SE17_Callback(source,eventdata) 
      val = get(source,'Value'); 
      if val ==1
        current_include(12) = 1;
      elseif val ==0
        current_include(12) = 0;
      end
  end
  function SE18_Callback(source,eventdata) 
      val = get(source,'Value'); 
      if val ==1
        current_include(13) = 1;
      elseif val ==0
        current_include(13) = 0;
      end
  end
  function SE19_Callback(source,eventdata) 
      val = get(source,'Value'); 
      if val ==1
        current_include(14) = 1;
      elseif val ==0
        current_include(14) = 0;
      end
  end
  function SE20_Callback(source,eventdata) 
      val = get(source,'Value'); 
      if val ==1
        current_include(15) = 1;
      elseif val ==0
        current_include(15) = 0;
      end
  end
  function SE21_Callback(source,eventdata) 
      val = get(source,'Value'); 
      if val ==1
        current_include(16) = 1;
      elseif val ==0
        current_include(16) = 0;
      end
  end

%  Pop-up menu callback. Read the pop-up menu Value property to
%  determine which item is currently displayed and make it the
%  current data. This callback automatically has access to 
%  current_data because this function is nested at a lower level.
   function X_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case "Machine strain"
         current_X = 1;
      case "End-to-end strain"
         current_X = 2;
      case "fiducial strain"
         current_X = 3;
      case "D band"
         current_X = 4;
      case "Cross sec"
         current_X = 5;
      case "Deformation"
         current_X = 6;
      case "SD Deformation"
         current_X = 7;
      case "Height"
         current_X = 8;
      case "SD Height"
         current_X = 9;
      case "Modulus"
         current_X = 10;
      case "SD Modulus"
         current_X = 11;
      case "RMS Modulus"
         current_X = 12;
      case "(mod-RMS)/(mod + rms)"
         current_X = 13;
      case "Height - Deformation"
         current_X = 14;
      end
   end

    function Y_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case "Machine strain"
         current_Y = 1;
      case "End-to-end strain"
         current_Y = 2;
      case "fiducial strain"
         current_Y = 3;
      case "D band"
         current_Y = 4;
      case "Cross sec"
         current_Y = 5;
      case "Deformation"
         current_Y = 6;
      case "SD Deformation"
         current_Y = 7;
      case "Height"
         current_Y = 8;
      case "SD Height"
         current_Y = 9;
      case "Modulus"
         current_Y = 10;
      case "SD Modulus"
         current_Y = 11;
      case "RMS Modulus"
         current_Y = 12;
      case "(mod-RMS)/(mod + rms)"
         current_Y = 13;
      case "Height - Deformation"
         current_Y = 14;
      end
    end

    function DX_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Raw' % User selects Peaks.
         current_DX = 1;
      case 'Strain' % User selects Membrane.
         current_DX = 2;
      end
      
    end

    function DY_Callback(source,eventdata) 
      % Determine the selected data set.
      str = get(source, 'String');
      val = get(source,'Value');
      % Set current data to the selected data set.
      switch str{val};
      case 'Raw' % User selects Peaks.
         current_DY = 1;
      case 'Strain' % User selects Membrane.
         current_DY = 2;
      end
    end
    function Plot_Callback(source,eventdata)
       current_range = [];
       for k = 1:length(s)
            if current_include(k) ==1
                current_range = [current_range (sampsize(k)- 3*s(k)+1):sampsize(k)];
            end
       end
       plot(data(current_range,current_X,current_DX), data(current_range,current_Y,current_DY),'*');
       xlabel(n(current_X,current_DX))
       ylabel(n(current_Y,current_DY))
    end
    function Clear_Callback(source,eventdata)
       current_range = 1:length(data(:,1,1));
       current_X = 1;
       current_Y = 2;
       current_DX = 1;
       current_DY = 1;
       plot(data(current_range,current_X,current_DX), data(current_range,current_Y,current_DY),'*');
       xlabel(n(current_X,current_DX))
       ylabel(n(current_Y,current_DY))
    end
end