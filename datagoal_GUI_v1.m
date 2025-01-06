%   This file is part of DataGoal: a Matlab Toolbox to Linear and Non-linear Soccer Positional Data Analysis.
%   Copyright (C) 2024 Bruno L. S. Bedo, Felipe A. Moura, Rodrigo Aquino, Sérgio A. Cunha, Paulo R. P. Santiago
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%       http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   Bruno L. S. Bedo,
%   <bruno.bedo@usp.br>

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               DATAGOAL:                                 %
%              a Matlab Toolbox to Linear and Non-linear                  %
%                    Soccer Positional Data Analysis                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GUI main file.

function varargout = datagoal_GUI_v1(varargin)
% Edit the above text to modify the response to help datagoal_GUI_v1

% Last Modified by GUIDE v2.5 08-Nov-2021 10:37:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @datagoal_GUI_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @datagoal_GUI_v1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before datagoal_GUI_v1 is made visible.
function datagoal_GUI_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to datagoal_GUI_v1 (see VARARGIN)

% Choose default command line output for datagoal_GUI_v1
handles.output = hObject;

%% Get value from GUI 
clearvars -global
warning off
clc 

global selections
%%  Handles 
set(handles.Untitled_1,'Visible','off')

%   Settings 
set(handles.GamePathName,'Value',1);
set(handles.GamePathName,'String','');
set(handles.GPSType,'Value',1)
set(handles.GPSType,'Enable','off')

%   Athletes
set(handles.DefenderList,'Enable','off');
set(handles.DefenderList,'String','');
set(handles.MidfielderList,'Enable','off');
set(handles.MidfielderList,'String','');
set(handles.ForwardsList,'Enable','off');
set(handles.ForwardsList,'String','');
set(handles.OpponentList,'Enable','off')
set(handles.OpponentList,'String','');

%   Input information
set(handles.StartTime,'Enable','off');
set(handles.EndTime,'Enable','off');
set(handles.FreqAc,'Enable','off');
set(handles.LowPass,'Enable','off');
set(handles.LatCorner1,'Enable','off');
set(handles.LongCorner1,'Enable','off');
set(handles.LatCorner2,'Enable','off');
set(handles.LongCorner2,'Enable','off');
set(handles.LatCorner3,'Enable','off');
set(handles.LongCorner3,'Enable','off');
set(handles.LatCorner4,'Enable','off');
set(handles.LongCorner4,'Enable','off');
set(handles.fieldwidth,'Enable','off');
set(handles.fieldheight,'Enable','off');
set(handles.select_field,'Enable','off'); 

%   Load GPS data
set(handles.LoadData,'Enable','off')
set(handles.Resetbutton,'Enable','off')

%  Linear Analysis
set(handles.LinearIndividual,'Enable','off')
set(handles.LinearCollective,'Enable','off')
set(handles.TacticalComponentType,'Enable','off')
set(handles.ColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveLinearAnalysis,'Enable','off')
set(handles.RecordVideo,'Enable','off')
set(handles.RecordVideo,'Value',0)

%   Non Linear 
set(handles.NonLinearCollective,'Enable','off')
set(handles.NLTacticalComponentType,'Enable','off');
set(handles.NLColLinearAnalysisType,'Enable','off');
set(handles.RunColletiveNonLinearAnalysis,'Enable','off');

%%  Selections 
%   Settings 
selections.GamePathName = get(handles.GamePathName,'String');

%   Athletes
selections.DefenderList = get(handles.DefenderList,'String');
selections.MidfielderList = get(handles.MidfielderList,'String');
selections.ForwardsList = get(handles.ForwardsList,'String');
selections.OpponentList = get(handles.OpponentList,'String');

%   Input information
selections.StartTime = get(handles.StartTime,'String');
selections.EndTime = get(handles.EndTime,'String');
selections.FreqAc = get(handles.FreqAc,'String');
selections.LowPass = get(handles.LowPass,'String');
selections.LatCorner1 = get(handles.LatCorner1,'String');
selections.LongCorner1 = get(handles.LongCorner1,'String');
selections.LatCorner2 = get(handles.LatCorner2,'String');
selections.LongCorner2 = get(handles.LongCorner2,'String');
selections.LatCorner3 = get(handles.LatCorner3,'String');
selections.LongCorner3 = get(handles.LongCorner3,'String');
selections.LatCorner4 = get(handles.LatCorner4,'String');
selections.LongCorner4 = get(handles.LongCorner4,'String');
selections.fieldwidth = get(handles.fieldwidth,'String');
selections.fieldheight = get(handles.fieldheight,'String');

%   Load GPS data
selections.LoadData = get(handles.LoadData,'Value');
selections.Resetbutton = get(handles.Resetbutton,'Value');

%  Linear Analysis
selections.LinearIndividual = get(handles.LinearIndividual,'Value');
selections.LinearCollective = get(handles.LinearCollective,'Value');
selections.CollectiveAnalysisType = get(handles.TacticalComponentType,'Value');
selections.ColLinearAnalysisType = get(handles.ColLinearAnalysisType,'Value');
selections.RecordVideo = get(handles.RecordVideo,'Value');

%  Non Linear
selections.NonLinearCollective = get(handles.NonLinearCollective,'Value');
selections.NLTacticalComponentType = get(handles.NLTacticalComponentType,'Value');
selections.NLColLinearAnalysisType = get(handles.NLColLinearAnalysisType,'Value'); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes datagoal_GUI_v1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = datagoal_GUI_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectProcessingConfiguration.
function selectProcessingConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to selectProcessingConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gamestr selections

gamepathstr = uigetdir(' ', 'Select your trials folder');
ind=strfind(gamepathstr, '\');
gamestr = gamepathstr(ind(end)+1:size(gamepathstr,2));
set(handles.GamePathName,'string',gamestr);

%   GPS type
set(handles.GPSType,'Enable','on'); 

%   Selecting players
set(handles.DefenderList,'Enable','on');
set(handles.MidfielderList,'Enable','on');
set(handles.ForwardsList,'Enable','on');
set(handles.OpponentList,'Enable','on');

selections.GamePathName = gamestr; 
selections.Gamedir = gamepathstr; 

% Athletes info
nplayers=dir(gamepathstr);
    playersnameall = {nplayers.name};
    playersname = [];
for i = 1:size(playersnameall,2)
    if strcmp(playersnameall{i},'.') || strcmp(playersnameall{i},'..') || strcmp(playersnameall{i},'Results') || strcmp(playersnameall{i},'MatCalib.txt') 
    else
       playersname{size(playersname,2)+1} = playersnameall{i};
    end
    
end
 
set(handles.DefenderList,'String',playersname)
set(handles.MidfielderList,'String',playersname)
set(handles.ForwardsList,'String',playersname)
set(handles.OpponentList,'String',playersname)



% --- Executes on selection change in DefenderList.
function DefenderList_Callback(hObject, eventdata, handles)
% hObject    handle to DefenderList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns DefenderList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DefenderList
global selections
clear DefenderList
for w = 1:size(handles.DefenderList.Value')
    DefenderList{w,1} = handles.DefenderList.String{handles.DefenderList.Value(w)};
end
if isempty(handles.DefenderList.Value)
    DefenderList = [];
end
selections.PlayersList.Defender = DefenderList;
selections.DefenderList = DefenderList;
selections.PlayersList;


% --- Executes during object creation, after sestting all properties.
function DefenderList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DefenderList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MidfielderList.
function MidfielderList_Callback(hObject, eventdata, handles)
% hObject    handle to MidfielderList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns MidfielderList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from MidfielderList
global selections
clear MidfielderList
for w = 1:size(handles.MidfielderList.Value')
    MidfielderList{w,1} = handles.MidfielderList.String{handles.MidfielderList.Value(w)};
end
if isempty(handles.MidfielderList.Value)
    MidfielderList = [];
end
selections.PlayersList.Midfielder = MidfielderList;
selections.MidfielderList = MidfielderList;
selections.PlayersList;


% --- Executes during object creation, after setting all properties.
function MidfielderList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MidfielderList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ForwardsList.
function ForwardsList_Callback(hObject, eventdata, handles)
% hObject    handle to ForwardsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ForwardsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ForwardsList
global selections
clear ForwardsList
for w = 1:size(handles.ForwardsList.Value')
    ForwardsList{w,1} = handles.ForwardsList.String{handles.ForwardsList.Value(w)};
end
if isempty(handles.ForwardsList.Value)
    ForwardsList = [];
end
selections.PlayersList.Forwards = ForwardsList;
selections.ForwardsList = ForwardsList;
selections.PlayersList;

% --- Executes on selection change in OpponentList.
function OpponentList_Callback(hObject, eventdata, handles)
% hObject    handle to OpponentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OpponentList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OpponentList
global selections 
clear OpponentList
for w = 1:size(handles.OpponentList.Value')
    OpponentList{w,1} = handles.OpponentList.String{handles.OpponentList.Value(w)};
end
if isempty(handles.OpponentList.Value)
    OpponentList = [];
end
selections.PlayersList.Opponent = OpponentList;
selections.OpponentList = OpponentList;


% --- Executes during object creation, after setting all properties.
function OpponentList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OpponentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ForwardsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ForwardsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function StartTime_Callback(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartTime as text
%        str2double(get(hObject,'String')) returns contents of StartTime as a double
global selections
selections.StartTime = (get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function StartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function EndTime_Callback(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndTime as text
%        str2double(get(hObject,'String')) returns contents of EndTime as a double
global selections
selections.EndTime = (get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function EndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FreqAc_Callback(hObject, eventdata, handles)
% hObject    handle to FreqAc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FreqAc as text
%        str2double(get(hObject,'String')) returns contents of FreqAc as a double
global selections
if  isempty(get(hObject,'String'))
    selections.FreqAc = '0';
else
    selections.FreqAc = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function FreqAc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FreqAc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LowPass_Callback(hObject, eventdata, handles)
% hObject    handle to LowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LowPass as text
%        str2double(get(hObject,'String')) returns contents of LowPass as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LowPass = '0';
else
    selections.LowPass = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LowPass_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LowPass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LatCorner1_Callback(hObject, eventdata, handles)
% hObject    handle to LatCorner1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LatCorner1 as text
%        str2double(get(hObject,'String')) returns contents of LatCorner1 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LatCorner1 = '0';
else
    selections.LatCorner1 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LatCorner1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatCorner1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LatCorner2_Callback(hObject, eventdata, handles)
% hObject    handle to LatCorner2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LatCorner2 as text
%        str2double(get(hObject,'String')) returns contents of LatCorner2 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LatCorner2 = '0';
else
    selections.LatCorner2 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LatCorner2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatCorner2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LatCorner3_Callback(hObject, eventdata, handles)
% hObject    handle to LatCorner3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LatCorner3 as text
%        str2double(get(hObject,'String')) returns contents of LatCorner3 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LatCorner3 = '0';
else
    selections.LatCorner3 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LatCorner3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatCorner3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LatCorner4_Callback(hObject, eventdata, handles)
% hObject    handle to LatCorner4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LatCorner4 as text
%        str2double(get(hObject,'String')) returns contents of LatCorner4 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LatCorner4 = '0';
else
    selections.LatCorner4 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LatCorner4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LatCorner4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LongCorner1_Callback(hObject, eventdata, handles)
% hObject    handle to LongCorner1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LongCorner1 as text
%        str2double(get(hObject,'String')) returns contents of LongCorner1 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LongCorner1 = '0';
else
    selections.LongCorner1 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LongCorner1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LongCorner1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LongCorner2_Callback(hObject, eventdata, handles)
% hObject    handle to LongCorner2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LongCorner2 as text
%        str2double(get(hObject,'String')) returns contents of LongCorner2 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LongCorner2 = '0';
else
    selections.LongCorner2 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LongCorner2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LongCorner2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LongCorner3_Callback(hObject, eventdata, handles)
% hObject    handle to LongCorner3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LongCorner3 as text
%        str2double(get(hObject,'String')) returns contents of LongCorner3 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LongCorner3 = '0';
else
    selections.LongCorner3 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LongCorner3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LongCorner3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LongCorner4_Callback(hObject, eventdata, handles)
% hObject    handle to LongCorner4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LongCorner4 as text
%        str2double(get(hObject,'String')) returns contents of LongCorner4 as a double
global selections
if  isempty(get(hObject,'String'))
    selections.LongCorner4 = '0';
else
    selections.LongCorner4 = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function LongCorner4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LongCorner4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections

%  Linear Analysis
set(handles.LinearIndividual,'Enable','off');
set(handles.LinearCollective,'Enable','off');
set(handles.TacticalComponentType,'Value',1)
set(handles.ColLinearAnalysisType,'Value',1)
set(handles.TacticalComponentType,'Enable','off');
set(handles.ColLinearAnalysisType,'Enable','off');
set(handles.RecordVideo,'Enable','off')
set(handles.RecordVideo,'Value',0)
set(handles.RunColletiveLinearAnalysis,'Enable','off')

%  Non-Linear Analysis
set(handles.NonLinearCollective,'Enable','off');
set(handles.NLColLinearAnalysisType,'Enable','off')
set(handles.NLTacticalComponentType,'Enable','off')
set(handles.NLColLinearAnalysisType,'Value',1)
set(handles.NLTacticalComponentType,'Value',1)

selections.RecordVideo = get(handles.RecordVideo,'Value');
selections.TacticalComponentType = [''];
selections.TacticalComponentType = [''];
selections.NColType = 0; 
selections.DefenderList = [];
selections.MidfielderList = [];
selections.ForwardsList = [];
selections.OpponentList = [];

%   Calib array
matcalib = [str2num(selections.LatCorner1) str2num(selections.LongCorner1); ...
            str2num(selections.LatCorner2) str2num(selections.LongCorner2); ...
            str2num(selections.LatCorner3) str2num(selections.LongCorner3); ...
            str2num(selections.LatCorner4) str2num(selections.LongCorner4)];
selections.matcalib = matcalib; 

if handles.select_field.Value == 1
    newfield_answer = questdlg('Do you want to register a new field??', ...
                        'New soccer field', ...
                        'Yes','No','No');
    if strcmp(newfield_answer,'Yes')
        definput = {'Estádio - '};
        dims = [1 40];
        opts.Interpreter = 'tex';
        newfieldname_answer = inputdlg('Please enter the soccer field name:','Soccer field name',dims,definput,opts);
        col1 = {'Corner 1'; 'Corner 2'; 'Corner 3'; 'Corner 4'}; 
        restitle = [selections.soccerfielddir, filesep, char(newfieldname_answer),'.xlsx']; 
        xlswrite(restitle,{col1},1,'A1');
        xlswrite(restitle,matcalib,1,'B1');
        e = actxserver('Excel.Application');
        ewb = e.Workbooks.Open(restitle);
        ewb.Save 
        ewb.Close(false)
        e.Quit        
    end
    
end


if isfield(selections,'PlayersList') == 0
    error('Please select the players!')   
else
%   Loading data
    disp(' ')
    disp('Loading and filtering...')
    allGPSdata = loadallgpsdata(matcalib,selections.StartTime,selections.EndTime,selections.FreqAc,selections.LowPass);
    selections.allGPSdata = allGPSdata;

    disp(' ')
    disp('All GPS data is loaded and filtered!')
end
set(handles.LinearIndividual,'Enable','on');
set(handles.LinearCollective,'Enable','on');
set(handles.NonLinearCollective,'Enable','on');


% --- Executes on button press in Resetbutton.
function Resetbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Resetbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections 

%   Selecting players
set(handles.GamePathName,'String','');
set(handles.DefenderList,'Enable','off');
set(handles.MidfielderList,'Enable','off');
set(handles.ForwardsList,'Enable','off');
set(handles.OpponentList,'Enable','off');   
set(handles.DefenderList,'String','')
set(handles.MidfielderList,'String','')
set(handles.ForwardsList,'String','')
set(handles.OpponentList,'String','')

%   Input information
set(handles.StartTime,'String','');
set(handles.EndTime,'String','');
set(handles.FreqAc,'String','');
set(handles.LowPass,'String','');
set(handles.LatCorner1,'String','');
set(handles.LongCorner1,'String','');
set(handles.LatCorner2,'String','');
set(handles.LongCorner2,'String','');
set(handles.LatCorner3,'String','');
set(handles.LongCorner3,'String','');
set(handles.LatCorner4,'String','');
set(handles.LongCorner4,'String','');
set(handles.fieldwidth,'String','');
set(handles.fieldheight,'String','');

set(handles.StartTime,'Enable','off');
set(handles.EndTime,'Enable','off');
set(handles.FreqAc,'Enable','off');
set(handles.LowPass,'Enable','off');
set(handles.LatCorner1,'Enable','off');
set(handles.LongCorner1,'Enable','off');
set(handles.LatCorner2,'Enable','off');
set(handles.LongCorner2,'Enable','off');
set(handles.LatCorner3,'Enable','off');
set(handles.LongCorner3,'Enable','off');
set(handles.LatCorner4,'Enable','off');
set(handles.LongCorner4,'Enable','off');
set(handles.fieldwidth,'Enable','off');
set(handles.fieldheight,'Enable','off');

%   Load GPS data
set(handles.LoadData,'Enable','off');

%   Linear
set(handles.LinearIndividual,'Enable','off')
set(handles.LinearCollective,'Enable','off')
set(handles.TacticalComponentType,'Enable','off')
set(handles.ColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveLinearAnalysis,'Enable','off')
set(handles.RecordVideo,'Enable','off')
set(handles.TacticalComponentType,'Value',1)
set(handles.ColLinearAnalysisType,'Value',1)

%   Non-Linear
set(handles.NLColLinearAnalysisType,'Enable','off')
set(handles.NLTacticalComponentType,'Enable','off')
set(handles.RunColletiveNonLinearAnalysis,'Enable','off')
set(handles.NLColLinearAnalysisType,'Value',1)
set(handles.NLTacticalComponentType,'Value',1)
set(handles.NonLinearCollective,'Enable','off')

%   Selections 
selections.GamePathName  = [];
selections.DefenderList = [];
selections.MidfielderList = [];
selections.ForwardsList = [];
selections.OpponentList = [];
selections.StartTime = [];
selections.EndTime = [];
selections.FreqAc = [];
selections.LowPass = [];
selections.LatCorner1 = [];
selections.LongCorner1 = [];
selections.LatCorner2 = [];
selections.LongCorner2 = [];
selections.LatCorner3 = [];
selections.LongCorner3 = [];
selections.LatCorner4 = [];
selections.LongCorner4 = [];
selections.CollectiveAnalysisType = [];
selections.ColLinearAnalysisType = [];
selections.Gamedir = [];
selections.PlayersList = [];
selections.matcalib = [];
selections.totalGametime = []; 
selections.allGPSdata = 0;
selections.ColLinearTypeAll = [];
selections.collectivedata = [];
selections.NLTacticalComponentType = [];
selections.TacticalComponentType = [];
selections.ColNonLinearTypeAll = [];
selections.ColNonLinTyp = []; 
selections.ColLinTyp = [];
selections.fieldwidth = [];
selections.fieldheight = [];


% --- Executes on button press in ExitBotton.
function ExitBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all 
close all 
clc


% --- Executes on button press in LinearIndividual.
function LinearIndividual_Callback(hObject, eventdata, handles)
% hObject    handle to LinearIndividual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global selections
[LinearIndividualRes] = linearindividualanalysis(selections.allGPSdata);
selections.LinearIndividualRes = LinearIndividualRes; 
disp(' ')
disp('Done Individual Linear Analysis.')


% --- Executes on button press in LinearCollective.
function LinearCollective_Callback(hObject, eventdata, handles)
% hObject    handle to LinearCollective (see GCBO)  
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections
%   Linear
set(handles.TacticalComponentType,'Value',1)
set(handles.ColLinearAnalysisType,'Value',1); 
set(handles.ColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveLinearAnalysis,'Enable','off')
set(handles.RecordVideo,'Enable','off')
set(handles.RecordVideo,'Value',0)

%   Non-Linear
set(handles.NLTacticalComponentType,'Value',1)
set(handles.NLColLinearAnalysisType,'Value',1)
set(handles.NLColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveNonLinearAnalysis,'Enable','off')


ColLinearTypeAll = {' ','Centrality Metrics','Dispersion Metrics','Tactical Behavior Metrics'};
set(handles.TacticalComponentType,'String',ColLinearTypeAll);

selections.ColLinearTypeAll = ColLinearTypeAll;

set(handles.TacticalComponentType,'Enable','on')

CollectiveAllData = organizedatacollective(selections.allGPSdata);
selections.collectivedata = CollectiveAllData; 


% --- Executes on selection change in TacticalComponentType.
function TacticalComponentType_Callback(hObject, eventdata, handles)
% hObject    handle to TacticalComponentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TacticalComponentType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TacticalComponentType
global selections
selections.TacticalComponentType = selections.ColLinearTypeAll(hObject.Value);
set(handles.ColLinearAnalysisType,'Value',1)
set(handles.ColLinearAnalysisType,'String',' ');
set(handles.RecordVideo,'Value',0)
set(handles.RecordVideo,'Enable','off')

if      hObject.Value == 1 
        set(handles.ColLinearAnalysisType,'Enable','off')
        set(handles.RunColletiveLinearAnalysis,'Enable','off')
        set(handles.RecordVideo,'Value',0)
        set(handles.RecordVideo,'Enable','off')

elseif  hObject.Value == 2 
        set(handles.ColLinearAnalysisType,'Enable','on')
        ColLinearVariables = {' ', ...
                              'Team Centroid (1 team)', ...
                              'Distance Between Teams’ Centroids (2 teams)'};
        set(handles.ColLinearAnalysisType,'String',ColLinearVariables);

elseif  hObject.Value == 3
        set(handles.ColLinearAnalysisType,'Enable','on')
        ColLinearVariables = {' ', ...
                              'Effective Area - Length - Width - Ratio (1 team)', ...
                              'Team Separateness (1 team)', ...
                              'Team Effective Area (1 team)', ...
                              'Stretch Index (1 team)', ...
                              'Team Spread (1 team)', ...
                              'Spatial Exploration Index (1 team)', ...
                              'Individual Playing Area (1 team)', ...
                              };
                            
        set(handles.ColLinearAnalysisType,'String',ColLinearVariables);

elseif  hObject.Value == 4
        set(handles.ColLinearAnalysisType,'Enable','on')
        ColLinearVariables = {' ', ...
                              'Distance Between Team Sectors (1 team)', ...
                              'Individual Playing Area - Length - Width (2 teams)', ...
                              'Players’ Maximum Range (1 team)', ...
                              'Voronoi Regions (2 teams)'};
        set(handles.ColLinearAnalysisType,'String',ColLinearVariables);        
end


% --- Executes during object creation, after setting all properties.
function TacticalComponentType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TacticalComponentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ColLinearAnalysisType.
function ColLinearAnalysisType_Callback(hObject, eventdata, handles)
% hObject    handle to ColLinearAnalysisType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColLinearAnalysisType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColLinearAnalysisType
global selections
ColLinTyp = char(hObject.String(hObject.Value));

selections.ColLinTyp = ColLinTyp; 
selections.NColType = hObject.Value -1;
if hObject.Value ==1
    set(handles.RunColletiveLinearAnalysis,'Enable','off')
    set(handles.RecordVideo,'Value',0)
    set(handles.RecordVideo,'Enable','off')
    selections.RecordVideo = 0; 

else
    set(handles.RunColletiveLinearAnalysis,'Enable','on')
    set(handles.RecordVideo,'Value',0)
    set(handles.RecordVideo,'Enable','on')
    selections.RecordVideo = 0; 

end


% --- Executes during object creation, after setting all properties.
function ColLinearAnalysisType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColLinearAnalysisType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RecordVideo.
function RecordVideo_Callback(hObject, eventdata, handles)
% hObject    handle to RecordVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RecordVideo
global selections
selections.RecordVideo=get(hObject,'Value');
if hObject.Value == 1
f = warndlg('This procedure will take a long time');
set(f,'Name','Video');
end


% --- Executes on button press in RunColletiveLinearAnalysis.
function RunColletiveLinearAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunColletiveLinearAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections

if strcmp(selections.TacticalComponentType,'Centrality Metrics') 

switch selections.ColLinTyp
    case 'Team Centroid (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamCentroid = teamcentroid(selections.collectivedata); 
        selections.ResTeamCentroid =  ResTeamCentroid;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Distance Between Teams’ Centroids (2 teams)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResCompTeamCentroid = teamscentroid(selections.collectivedata);
        selections.ResTeamCentroid = ResCompTeamCentroid;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
end


elseif strcmp(selections.TacticalComponentType,'Dispersion Metrics')  
    switch selections.ColLinTyp
    case 'Team Separateness (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamSeparateness = teamseparateness(selections.collectivedata);
        selections.ResTeamSeparateness = ResTeamSeparateness;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Team Effective Area (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamEffectiveArea = team_effective_area(selections.collectivedata);
        selections.ResTeamEffectiveArea = ResTeamEffectiveArea;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
    
    case 'Stretch Index (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamStretchIndex = team_stretch_index(selections.collectivedata);
        selections.ResTeamStretchIndex = ResTeamStretchIndex;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
    
    case 'Team Spread (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamSpread = teamspread(selections.collectivedata);
        selections.ResTeamSpread = ResTeamSpread;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Spatial Exploration Index (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResSpatialExplorationIndex = spatial_exploration_index(selections.collectivedata);
        selections.ResSpatialExplorationIndex = ResSpatialExplorationIndex;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Individual Playing Area (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResIndividualPlayingArea = individual_playing_area(selections.collectivedata);
        selections.ResIndividualPlayingArea = ResIndividualPlayingArea;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
    
    case 'Effective Area - Length - Width - Ratio (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResTeamCompLargAreaDist = team_length_width_ratio_area_distgoal(selections.collectivedata);
        selections.ResTeamCompLargAreaDist = ResTeamCompLargAreaDist;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Video for Illustrative Purposes (1 team)'
        disp(' ')
        disp(['Creating: ', selections.ColLinTyp])
        IllustrativeFigure(selections.collectivedata);
        disp('Saving video...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
    
    case 'Team Sectors Analysis (1 team)'
        disp(' ')
        disp(['Creating: ', selections.ColLinTyp])
        Resdistanceteamsectors = distanceteamsectors(selections.collectivedata);
        selections.Resdistanceteamsectors = Resdistanceteamsectors;
        disp('Saving video...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    end
    

elseif strcmp(selections.TacticalComponentType,'Tactical Behavior Metrics')  
    switch selections.ColLinTyp
    case 'Distance Between Team Sectors (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResCompSectCentroid = sectcentroid(selections.collectivedata);
        selections.ResCompSectCentroid = ResCompSectCentroid;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Individual Playing Area - Length - Width (2 teams)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResDistHorVertLines = comphorvertteamslines(selections.collectivedata);
        selections.ResDistHorVertLines = ResDistHorVertLines;
        disp('This variable is not ready yet.')
        disp('We are working to release it as soon as possible.')
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Players’ Maximum Range (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResPlayersMajorRange = playersmajorrange(selections.collectivedata);
        selections.ResPlayersMajorRange = ResPlayersMajorRange;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')
        
    case 'Players’ Maximum Range (1 team)'
        disp(' ')
        disp(['Calculating: ', selections.ColLinTyp])
        ResVoronoiRegions = voronoiregions(selections.collectivedata);
        selections.ResVoronoiRegions = ResVoronoiRegions;
        disp('Saving results...')
        disp(['Done: ', selections.ColLinTyp])
        disp('---------------------------------------------------')  

    end
end


% --- Executes on selection change in NLTacticalComponentType.
function NLTacticalComponentType_Callback(hObject, eventdata, handles)
% hObject    handle to NLTacticalComponentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NLTacticalComponentType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NLTacticalComponentType
global selections
selections.NLTacticalComponentType = selections.ColNonLinearTypeAll(hObject.Value);
set(handles.NLColLinearAnalysisType,'Value',1)
set(handles.NLColLinearAnalysisType,'String',' ');

if      hObject.Value == 1 
        set(handles.NLColLinearAnalysisType,'Enable','off')
elseif  hObject.Value == 2 
        set(handles.NLColLinearAnalysisType,'Enable','on')
        ColNonLinearVariables = {' ',...
                            'Approximate entropy (ApEn)',...
                            'Sample entropy (SampEn)',...
                            'Shannon entropy (ShanEn)',...
                            'Dynamic overlap'};
        set(handles.NLColLinearAnalysisType,'String',ColNonLinearVariables);
elseif  hObject.Value == 3
        set(handles.NLColLinearAnalysisType,'Enable','on')
        ColNonLinearVariables = {' ',...
                            'Relative phase',...
                            'Windowed correlation',...
                            'Cross correlation',...
                            'Cross-sample entropy (Cross-SampEn)',...
                            'Vector coding',...
                            'Mutual information',...
                            'Cluster phase analysis',...
                            'Sectors Coordenation',};
        set(handles.NLColLinearAnalysisType,'String',ColNonLinearVariables);
end


% --- Executes during object creation, after setting all properties.
function NLTacticalComponentType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NLTacticalComponentType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NLColLinearAnalysisType.
function NLColLinearAnalysisType_Callback(hObject, eventdata, handles)
% hObject    handle to NLColLinearAnalysisType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NLColLinearAnalysisType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NLColLinearAnalysisType
global selections
ColNonLinTyp = char(hObject.String(hObject.Value));

selections.ColNonLinTyp = ColNonLinTyp; 
selections.NColType = hObject.Value -1;
if hObject.Value ==1
    set(handles.RunColletiveNonLinearAnalysis,'Enable','off')
%     set(handles.RecordVideo,'Value',0)
%     set(handles.RecordVideo,'Enable','off')
else
    set(handles.RunColletiveNonLinearAnalysis,'Enable','on')
%     set(handles.RecordVideo,'Value',0)
%     set(handles.RecordVideo,'Enable','on')
end


% --- Executes during object creation, after setting all properties.
function NLColLinearAnalysisType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NLColLinearAnalysisType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NonLinearCollective.
function NonLinearCollective_Callback(hObject, eventdata, handles)
% hObject    handle to NonLinearCollective (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections

ColNonLinearTypeAll = {' ','Regularidade','Sincronização'};
%   Linear
set(handles.TacticalComponentType,'Value',1)
set(handles.ColLinearAnalysisType,'Value',1); 
set(handles.ColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveLinearAnalysis,'Enable','off')
set(handles.RecordVideo,'Enable','off')
set(handles.RecordVideo,'Value',0)

%   Non-Linear
set(handles.NLTacticalComponentType,'Value',1)
set(handles.NLColLinearAnalysisType,'Value',1)
set(handles.NLColLinearAnalysisType,'Enable','off')
set(handles.RunColletiveNonLinearAnalysis,'Enable','off')

selections.ColNonLinearTypeAll = ColNonLinearTypeAll;

set(handles.NLTacticalComponentType,'Enable','on')
set(handles.NLTacticalComponentType,'String',ColNonLinearTypeAll)

CollectiveAllData = organizedatacollective(selections.allGPSdata);
selections.collectivedata = CollectiveAllData; 


% --- Executes on button press in RunColletiveNonLinearAnalysis.
function RunColletiveNonLinearAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to RunColletiveNonLinearAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selections

if strcmp(selections.NLTacticalComponentType,'Regularidade') 
switch selections.ColNonLinTyp
    case 'Approximate entropy (ApEn)'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResApEn = approximateentropy(selections.collectivedata);
        selections.ResApEn = ResApEn;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Sample entropy (SampEn)'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResSampEnt = sampleentropy(selections.collectivedata);
        selections.ResSampEnt = ResSampEnt;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Shannon entropy (ShanEn)'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResShanEn = shannonentropy(selections.collectivedata);
        selections.ResShanEn = ResShanEn;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Dynamic overlap'
        disp(' ')
        disp('This variable is not ready yet.')
        disp('We are working to release it as soon as possible.')
        disp('---------------------------------------------------')
end

elseif strcmp(selections.NLTacticalComponentType,'Sincronização')  
    switch selections.ColNonLinTyp
    case 'Relative phase'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResRelPhase = relativephase(selections.collectivedata);
        selections.ResRelPhase = ResRelPhase;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Windowed correlation'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResWindCorrel = windowedcorrelation(selections.collectivedata);
        selections.ResWindCorrel = ResWindCorrel;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Cross correlation'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResCrossCorr = crosscorr(selections.collectivedata);
        selections.ResCrossCorr = ResCrossCorr;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Cross-sample entropy (Cross-SampEn)'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResCrossSampEnt = crosssampent(selections.collectivedata);
        selections.ResCrossSampEnt = ResCrossSampEnt;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Vector coding'
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResVecCod = vectorcoding(selections.collectivedata);
        selections.ResVecCod = ResVecCod;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Mutual information'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        ResMultInf = mutualinfo(selections.collectivedata);
        selections.ResMultInf = ResMultInf;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Cluster phase analysis'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        Resclusterphase = clusterphase(selections.collectivedata);
        selections.Resclusterphase = Resclusterphase;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    case 'Sectors Coordenation'
        disp(' ')
        disp(['Calculating: ', selections.ColNonLinTyp])
        Ressectors_coordenation = sectors_coordenation(selections.collectivedata);
        selections.Resclusterphase = Ressectors_coordenation;
        disp('Saving results...')
        disp(['Done: ', selections.ColNonLinTyp])
        disp('---------------------------------------------------')
    end
end


% --- Executes on selection change in GPSType.
function GPSType_Callback(hObject, eventdata, handles)
% hObject    handle to GPSType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GPSType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GPSType
global selections
% Soccer field info
soccerfielddir = [pwd,filesep,'fields'];
selections.soccerfielddir = soccerfielddir;
fields_info_dir = [dir([soccerfielddir,filesep, '**/*.xlsx']);dir([soccerfielddir,filesep, '**/*.xls']);dir([soccerfielddir,filesep, '**/*.csv'])];
fields_all = {fields_info_dir.name};
fields_names = [];
for i = 1:size(fields_all,2)
    if strcmp(fields_all{i},'.') || strcmp(fields_all{i},'..') || strcmp(fields_all{i},'Results') || strcmp(fields_all{i},'MatCalib.txt') 
    else
       fields_names{i+1} = (fields_all{i});
    end
end
set(handles.select_field,'Enable','on'); 
set(handles.select_field,'String',fields_names)

%   Input information
set(handles.StartTime,'Enable','on');
set(handles.EndTime,'Enable','on');
set(handles.FreqAc,'Enable','on');
set(handles.LowPass,'Enable','on');
set(handles.LatCorner1,'Enable','on');
set(handles.LongCorner1,'Enable','on');
set(handles.LatCorner2,'Enable','on');
set(handles.LongCorner2,'Enable','on');
set(handles.LatCorner3,'Enable','on');
set(handles.LongCorner3,'Enable','on');
set(handles.LatCorner4,'Enable','on');
set(handles.LongCorner4,'Enable','on');
set(handles.fieldwidth,'Enable','on');
set(handles.fieldheight,'Enable','on');

%   Load GPS data
set(handles.LoadData,'Enable','on');
set(handles.Resetbutton,'Enable','on')

GPSType = char(hObject.String(hObject.Value));
if strcmp(GPSType,'Dvideo')
    set(handles.LatCorner1,'Enable','off');
    set(handles.LatCorner2,'Enable','off');
    set(handles.LatCorner3,'Enable','off');
    set(handles.LatCorner4,'Enable','off');
    set(handles.LongCorner1,'Enable','off');
    set(handles.LongCorner2,'Enable','off');
    set(handles.LongCorner3,'Enable','off');
    set(handles.LongCorner4,'Enable','off');
    set(handles.StartTime,'String','0');
    set(handles.EndTime,'String','0');
    set(handles.text19,'String','(Minutes)');
    set(handles.FreqAc,'String','30');
    set(handles.LowPass,'String','0.4');

    selections.FreqAc = '30';
    selections.LowPass = '3';
else
    set(handles.LatCorner1,'Enable','on');
    set(handles.LatCorner2,'Enable','on');
    set(handles.LatCorner3,'Enable','on');
    set(handles.LatCorner4,'Enable','on');
    set(handles.LongCorner1,'Enable','on');
    set(handles.LongCorner2,'Enable','on');
    set(handles.LongCorner3,'Enable','on');
    set(handles.LongCorner4,'Enable','on');
    set(handles.text19,'String','(hh:mm:ss)');
    set(handles.StartTime,'String','18:00:00');
    set(handles.EndTime,'String','18:45:00');
    set(handles.FreqAc,'String','1');
    set(handles.LowPass,'String','0.3');
    
    selections.FreqAc = '1';
    selections.LowPass = '0.3';
end

selections.GPSType = GPSType; 


% --- Executes during object creation, after setting all properties.
function GPSType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GPSType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
GPSType = {' ','QStarz','Stats Sports','PlayerTek','Dvideo','WIMU','Vector S7','Polar Team','Kinexon'};
set(hObject,'String',GPSType); 



function fieldwidth_Callback(hObject, eventdata, handles)
% hObject    handle to fieldwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldwidth as text
%        str2double(get(hObject,'String')) returns contents of fieldwidth as a double
global selections
if  isempty(get(hObject,'String'))
    selections.fieldwidth = '0';
else
    selections.fieldwidth = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function fieldwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fieldheight_Callback(hObject, eventdata, handles)
% hObject    handle to fieldheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fieldheight as text
%        str2double(get(hObject,'String')) returns contents of fieldheight as a double
global selections
if  isempty(get(hObject,'String'))
    selections.fieldheight = '0';
else
    selections.fieldheight = (get(hObject,'String'));
end


% --- Executes during object creation, after setting all properties.
function fieldheight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldheight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in select_field.
function select_field_Callback(hObject, eventdata, handles)
% hObject    handle to select_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_field contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_field
global selections
fields_info_dir = [dir([selections.soccerfielddir,filesep, '**/*.xlsx']);dir([selections.soccerfielddir,filesep, '**/*.xls']);dir([selections.soccerfielddir,filesep, '**/*.csv'])];
fields_all = {fields_info_dir.name};
fields_names = [];
for i = 1:size(fields_all,2)
    if strcmp(fields_all{i},'.') || strcmp(fields_all{i},'..') || strcmp(fields_all{i},'Results') || strcmp(fields_all{i},'MatCalib.txt') 
    else
       fields_names{i+1} = (fields_all{i});
    end
end
set(handles.select_field,'Enable','on'); 
set(handles.select_field,'String',fields_names)

if hObject.Value > 1 
    set(handles.LatCorner1,'Enable','off');
    set(handles.LatCorner2,'Enable','off');
    set(handles.LatCorner3,'Enable','off');
    set(handles.LatCorner4,'Enable','off');
    set(handles.LongCorner1,'Enable','off');
    set(handles.LongCorner2,'Enable','off');
    set(handles.LongCorner3,'Enable','off');
    set(handles.LongCorner4,'Enable','off');
    
    dir_field = [selections.soccerfielddir, filesep,char(hObject.String(hObject.Value))];
    data = xlsread(dir_field);
    data = compose('%.9f',data);
    
    handles.LatCorner1.String = char(data(1,1));
    handles.LatCorner2.String = char(data(2,1));
    handles.LatCorner3.String = char(data(3,1));
    handles.LatCorner4.String = char(data(4,1));
    
    handles.LongCorner1.String = char(data(1,2));
    handles.LongCorner2.String = char(data(2,2));
    handles.LongCorner3.String = char(data(3,2));
    handles.LongCorner4.String = char(data(4,2));
    
    
    selections.LatCorner1 = handles.LatCorner1.String; 
    selections.LatCorner2 = handles.LatCorner2.String; 
    selections.LatCorner3 = handles.LatCorner3.String; 
    selections.LatCorner4 = handles.LatCorner4.String; 
    selections.LongCorner1 = handles.LongCorner1.String; 
    selections.LongCorner2 = handles.LongCorner2.String; 
    selections.LongCorner3 = handles.LongCorner3.String; 
    selections.LongCorner4 = handles.LongCorner4.String;     

else
    set(handles.LatCorner1,'Enable','on');
    set(handles.LatCorner2,'Enable','on');
    set(handles.LatCorner3,'Enable','on');
    set(handles.LatCorner4,'Enable','on');
    set(handles.LongCorner1,'Enable','on');
    set(handles.LongCorner2,'Enable','on');
    set(handles.LongCorner3,'Enable','on');
    set(handles.LongCorner4,'Enable','on');
    
    selections.LatCorner1 = handles.LatCorner1.String; 
    selections.LatCorner2 = handles.LatCorner2.String; 
    selections.LatCorner3 = handles.LatCorner3.String; 
    selections.LatCorner4 = handles.LatCorner4.String; 
    selections.LongCorner1 = handles.LongCorner1.String; 
    selections.LongCorner2 = handles.LongCorner2.String; 
    selections.LongCorner3 = handles.LongCorner3.String; 
    selections.LongCorner4 = handles.LongCorner4.String; 
    
    
end




% --- Executes during object creation, after setting all properties.
function select_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





