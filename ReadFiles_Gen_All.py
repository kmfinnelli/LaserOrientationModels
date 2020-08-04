# -*- coding: utf-8 -*-
"""
Created on Wed Jul 22 12:50:39 2020

@author: KMFin
"""

#Import libraries
import numpy as np
import os, os.path
import pandas as pd

#initializes SM1/2 angles

SM1_angle_orig= 0.0
SM2_angle_orig= -10.0

status=''

SM1_angle=SM1_angle_orig
SM2_angle=SM2_angle_orig

inc_SM1= 1.0
inc_SM2= 1.0

print("First Working Directory " , os.getcwd())

#Sets which wedge is being looked at for filenames and changes to the right folder
whichWedge="6"

folder_name='C:/Users/KMFin/OneDrive/Desktop/Grad School/Laser Orientation/Rot/Wedge'+str(whichWedge)

if os.path.exists(folder_name):
    os.chdir(folder_name)
else:
    print("Can't change the Current Working Directory")    

print("Second Working Directory " , os.getcwd())
current_folder_name=os.getcwd()


#Initializes necessary lists 
l_SM1=list()
l_SM2=list()
l_avg_Top=list()
l_avg_Bottom=list()
l_weighted_avg_Top=list()
l_weighted_avg_Bottom=list()
l_inc_flux_sum_Top=list()
l_inc_flux_sum_Bottom=list()
l_inc_flux_sum_LPEnd=list()
l_inc_flux_sum_LPFront=list()
l_avg_LPFront=list()

#lists for calculations
l_Y_LPCenter=list()
l_deltaY_Top=list()
l_deltaY_Bottom=list()
l_Z_Screen=list()
l_Theta_Top=list()
l_Theta_Bottom=list()
l_Theta_Abs=list()
l_delta_Y_LPFront=list()
l_delta_X_LPFront=list()
l_ratio_YX_LPFront=list()
l_beam_inc_angle=list()
l_theta_eff=list()

l_status=list()


l_IncNames=['CMTop','CMBottom','LPEnd','LPFront']
l_floats=['floatBoth','floatSM1','floatSM2','floatNone']

print("Right before loop")
while SM1_angle <= 1.0: 
    # print("Right after 1st loop "+str(SM1_angle))
    while SM2_angle <= 10.0:
            # print("Right after 2nd loop " + str(SM2_angle))
        
    #SETUP TO GET FILES!!!
            status="All Good!"
            
            SM1_angle_round=round(SM1_angle, 2)
            SM2_angle_round=round(SM2_angle, 2)
            
            #print("Start of file names")
            # Gets each possible file name; there should be a way to automate this with a loop
            file_name_Top_floatBoth='Incident_Wedge' + whichWedge + '_CMTop_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_Top_floatSM1='Incident_Wedge' + whichWedge + '_CMTop_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            file_name_Top_floatSM2='Incident_Wedge' + whichWedge + '_CMTop_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_Top_floatNone='Incident_Wedge' + whichWedge + '_CMTop_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'

            file_name_Bottom_floatBoth='Incident_Wedge' + whichWedge + '_CMBottom_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_Bottom_floatSM1='Incident_Wedge' + whichWedge + '_CMBottom_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            file_name_Bottom_floatSM2='Incident_Wedge' + whichWedge + '_CMBottom_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_Bottom_floatNone='Incident_Wedge' + whichWedge + '_CMBottom_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'

            file_name_LPEnd_floatBoth='Incident_Wedge' + whichWedge + '_LPEnd_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_LPEnd_floatSM1='Incident_Wedge' + whichWedge + '_LPEnd_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            file_name_LPEnd_floatSM2='Incident_Wedge' + whichWedge + '_LPEnd_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_LPEnd_floatNone='Incident_Wedge' + whichWedge + '_LPEnd_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'

            file_name_LPFront_floatBoth='Incident_Wedge' + whichWedge + '_LPFront_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_LPFront_floatSM1='Incident_Wedge' + whichWedge + '_LPFront_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            file_name_LPFront_floatSM2='Incident_Wedge' + whichWedge + '_LPFront_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_LPFront_floatNone='Incident_Wedge' + whichWedge + '_LPFront_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
    
            file_name_SM2Face_floatBoth='Incident_Wedge' + whichWedge + '_SM2Face_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_SM2Face_floatSM1='Incident_Wedge' + whichWedge + '_SM2Face_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            file_name_SM2Face_floatSM2='Incident_Wedge' + whichWedge + '_SM2Face_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
            file_name_SM2Face_floatNone='Incident_Wedge' + whichWedge + '_SM2Face_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
            
            #print("if/elif section")
            #Check if CMTop name exists
            if os.path.exists(file_name_Top_floatBoth):
                df_Top_All=pd.read_csv(file_name_Top_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_Top_floatSM1):
                df_Top_All=pd.read_csv(file_name_Top_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_Top_floatSM2):
                df_Top_All=pd.read_csv(file_name_Top_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            else:
                df_Top_All=pd.read_csv(file_name_Top_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            
            #Check if CMBottom exists
            if os.path.exists(file_name_Bottom_floatBoth):
                df_Bottom_All=pd.read_csv(file_name_Bottom_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_Bottom_floatSM1):
                df_Bottom_All=pd.read_csv(file_name_Bottom_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_Bottom_floatSM2):
                df_Bottom_All=pd.read_csv(file_name_Bottom_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            else:
                df_Bottom_All=pd.read_csv(file_name_Bottom_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)

            #Check if LPEnd exists        
            if os.path.exists(file_name_LPEnd_floatBoth):
                df_LPEnd_All=pd.read_csv(file_name_LPEnd_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_LPEnd_floatSM1):
                df_LPEnd_All=pd.read_csv(file_name_LPEnd_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_LPEnd_floatSM2):
                df_LPEnd_All=pd.read_csv(file_name_LPEnd_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            else:
                df_LPEnd_All=pd.read_csv(file_name_LPEnd_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)

            #Check if LPFront exists        
            if os.path.exists(file_name_LPFront_floatBoth):
                df_LPFront_All=pd.read_csv(file_name_LPFront_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_LPFront_floatSM1):
                df_LPFront_All=pd.read_csv(file_name_LPFront_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_LPFront_floatSM2):
                df_LPFront_All=pd.read_csv(file_name_LPFront_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            else:
                df_LPFront_All=pd.read_csv(file_name_LPFront_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
                
            #Check if SM2Face name exists
            if os.path.exists(file_name_SM2Face_floatBoth):
                df_SM2Face_All=pd.read_csv(file_name_SM2Face_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_SM2Face_floatSM1):
                df_SM2Face_All=pd.read_csv(file_name_SM2Face_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            elif os.path.exists(file_name_SM2Face_floatSM2):
                df_SM2Face_All=pd.read_csv(file_name_SM2Face_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
            else:
                df_SM2Face_All=pd.read_csv(file_name_SM2Face_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)

            #print("split section")
            # Finds the smallest split value, then drops it
            splitTopAll=df_Top_All["Split"]
            splitBottomAll=df_Bottom_All["Split"]
            splitLPEndAll=df_LPEnd_All["Split"]
            splitLPFrontAll=df_LPFront_All["Split"]  
            
            splitSM2FaceAll=df_SM2Face_All["Split"]

            splitMinTop=splitTopAll.min()
            splitMinBottom=splitBottomAll.min()
            splitMinLPEnd=splitLPEndAll.min()
            splitMinLPFront=splitLPFrontAll.min()    
            splitMinSM2Face=splitSM2FaceAll.min()
            
            #print("index section")           
            #Gets the index name of all rays that haven't split the given numbers time. This gets rid of the effect due to TIR and other scatterings besides the main path
            indexNamesTop=df_Top_All[ df_Top_All['Split'] > splitMinTop].index
            indexNamesBottom=df_Bottom_All[ df_Bottom_All['Split'] > splitMinBottom].index
            indexNamesLPEnd=df_LPEnd_All[ df_LPEnd_All['Split'] > splitMinLPEnd].index
            indexNamesLPFront=df_LPFront_All[ df_LPFront_All['Split'] > splitMinLPFront].index
            indexNamesSM2Face=df_SM2Face_All[df_SM2Face_All['Split'] > splitMinSM2Face].index

            #Note: doing this split means that if the main path splits at the corner at LPEnd, the inc flux will show for the one with the least splits, not the one with the highest incidence. The angle will still be for the highest incidence though

            df_Top=df_Top_All.drop(indexNamesTop)
            df_Bottom=df_Bottom_All.drop(indexNamesBottom)
            df_LPEnd=df_LPEnd_All.drop(indexNamesLPEnd)
            df_LPFront=df_LPFront_All.drop(indexNamesLPFront)
            df_SM2Face=df_SM2Face_All.drop(indexNamesSM2Face)
            
    #Now have all the files imported as data frames for the top and bottom screen, front and end of the light pipe, and SM2 face. The back face of the wedge base is brought in with a later loop b/c it is only used for when the wedge isnt 0 
            #print("start of SM2 face")
        #SM2 Face
            # Gets the Y and Z position at the SM2 Face            
            y_pos_SM2Face=df_SM2Face["Y Pos"].mean()
            z_pos_SM2Face=df_SM2Face["Z Pos"].mean()
            
            #print("starto of lp front")
        #LP Front
            # Gets the total incident flux from the front  of the LP by summing up inc flux of all rays
            inc_flux_sum_LPFront=df_LPFront["Inc Flux"].sum()
            
            #Gets avg x, y, z pos at LP Front
            avg_LPFront_Y=df_LPFront["Y Pos"].mean()
            avg_LPFront_X=df_LPFront["X Pos"].mean()
            avg_LPFront_Z=df_LPFront["Z Pos"].mean()
            
            #Shape of beam at LPFront, then gets the ratio btwn the x and y diameter
            y_max_LPFront=df_LPFront["Y Pos"].max()
            y_min_LPFront=df_LPFront["Y Pos"].min()
            x_max_LPFront=df_LPFront["X Pos"].max()
            x_min_LPFront=df_LPFront["X Pos"].min()    
            
            delta_Y_LPFront=y_max_LPFront-y_min_LPFront
            delta_X_LPFront=x_max_LPFront-x_min_LPFront
            
            #print("lp front delta start")
            if delta_X_LPFront != 0:
                ratio_YX_LPFront=delta_Y_LPFront/delta_X_LPFront
            else:
                ratio_YX_LPFront="delta X=0"
            
            #print("Right before LPFront cutoff loop")
            # #If inc flux at LP Front is less than half, stops the loop, fills in the lists and puts in nan's
            # if inc_flux_sum_LPFront <138:          
                
            #     l_SM1.append(SM1_angle)
            #     l_SM2.append(SM2_angle)
            #     l_avg_Top.append(np.nan)
            #     l_avg_Bottom.append(np.nan)

            #     l_inc_flux_sum_Top.append(np.nan)
            #     l_inc_flux_sum_Bottom.append(np.nan)
            #     l_inc_flux_sum_LPFront.append(inc_flux_sum_LPFront)
            #     l_inc_flux_sum_LPEnd.append(np.nan)
            #     l_avg_LPFront.append(np.nan)
            
            #     l_Y_LPCenter.append(np.nan)
            #     l_Z_Screen.append(np.nan)
            
            #     l_deltaY_Top.append(np.nan)
            #     l_deltaY_Bottom.append(np.nan)
            #     l_Theta_Top.append(np.nan)
            #     l_Theta_Bottom.append(np.nan)
            #     l_Theta_Abs.append(np.nan)
            
            #     l_delta_Y_LPFront.append(np.nan)
            #     l_delta_X_LPFront.append(np.nan)
            #     l_ratio_YX_LPFront.append(np.nan)   
            #     l_beam_inc_angle.append(np.nan)
            #     l_theta_eff.append(np.nan)
                
            #     status="Not enough inc flux in LPFront"
                
            #     l_status.append(status)
            #     SM2_angle +=inc_SM2
            #     continue
            #print("Right after LPFront cutoff loop")
            
        #LP End
            inc_flux_sum_LPEnd=df_LPEnd["Inc Flux"].sum()
            
            y_LPCenter=df_LPEnd["Y Pos"].mean()



        #CM Top/Bottom

            # Get the y-positions and incident flux of all rays in both CM Top/Bottom
            y_pos_Top=df_Top["Y Pos"]
            avg_Top_Y=df_Top["Y Pos"].mean()
            
            inc_flux_Top=df_Top["Inc Flux"]
            inc_flux_sum_Top=inc_flux_Top.sum()
            
            
            y_pos_Bottom=df_Bottom["Y Pos"]
            avg_Bottom_Y=df_Bottom["Y Pos"].mean()
            
            inc_flux_Bottom=df_Bottom["Inc Flux"]
            inc_flux_sum_Bottom=inc_flux_Bottom.sum()            
            
            # #Attempt to weigh y-pos wrt flux of each ray, currently not correct
            # per_inc_Top=1+(inc_flux_Top/inc_flux_sum_Top)
            # y_weighted_avg_Top=y_pos_Top*per_inc_Top
            
            # per_inc_Bottom=1+(inc_flux_Bottom/inc_flux_sum_Bottom)
            # y_weighted_avg_Bottom=y_pos_Bottom*per_inc_Bottom            

            # weighted_avg_Top=y_weighted_avg_Top.mean()
            # weighted_avg_Bottom=y_weighted_avg_Bottom.mean()

            # Gets the avg y-pos (un-weighted) by taking the mean of all rays in CM Top/Bottom


            # if df_Top["Z Pos"].mean() !=0:
            #     z_CM=df_Top["Z Pos"].mean()
            # elif df_Bottom["Z Pos"].mean() != 0:
            #     z_CM=df_Bottom["Z Pos"].mean()
            # else:
            #     z_CM=np.nan
            
            # if df_LPEnd["Z Pos"].mean() != 0:
            #     z_Screen=z_CM-df_LPEnd["Z Pos"].mean()
            # else:
            #     z_Screen=np.nan
            #     l_status.append("Light not leaving LPEnd")
            
            #Sets the distance btwn the LP End and the screen based on which configuration
            if whichWedge !=0:
                z_Screen=987.3
            else:
                z_Screen=986.3
            
            #Gets Y distance as rays leave LP End to screen
            deltaY_Top=avg_Top_Y-y_LPCenter
            deltaY_Bottom=avg_Bottom_Y-y_LPCenter
            
            #Gets the angle leaving LPEnd, which is the same as the beam incident angle
            theta_Top_Rad=np.arctan2(deltaY_Top,z_Screen)
            theta_Bottom_Rad=np.arctan2(deltaY_Bottom,z_Screen)

            theta_Top=np.rad2deg(theta_Top_Rad)
            theta_Bottom=np.rad2deg(theta_Bottom_Rad)

            # Enforces minimum inc flux for theta effective
            if inc_flux_sum_Top > inc_flux_sum_Bottom:
                theta_Abs=np.absolute(theta_Top)
                if inc_flux_sum_Top > 138:
                    theta_eff=theta_Abs
                else:
                    theta_eff=np.nan
                    status="Not enough inc flux in Top"
            else:
                theta_Abs=np.absolute(theta_Bottom)  
                if inc_flux_sum_Bottom > 138:
                    theta_eff=theta_Abs
                else:
                    theta_eff=np.nan
                    status="Not enough inc flux in Bottom"
            

                
            file_name_LPFrontIrr_floatBoth='Irr_Wedge' + whichWedge + '_LPFrontScreen_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.jpg'
            file_name_LPFrontIrr_floatSM1='Irr_Wedge' + whichWedge + '_LPFrontScreen_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.jpg'
            file_name_LPFrontIrr_floatSM2='Irr_Wedge' + whichWedge + '_LPFrontScreen_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.jpg'
            file_name_LPFrontIrr_floatNone='Irr_Wedge' + whichWedge + '_LPFrontScreen_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.jpg'
    
                
             #Check if LPFront Screen exists        
            if os.path.exists(file_name_LPFrontIrr_floatBoth):
                file_name_LPFrontIrr=  file_name_LPFrontIrr_floatBoth
                if np.isnan(theta_eff) == False:
                    irr_path= current_folder_name + '/Irr_Pass/' + file_name_LPFrontIrr
                else:
                    irr_path=current_folder_name + '/Irr_Fail/' + file_name_LPFrontIrr
                
                file_name_LPFrontIrr_full=current_folder_name + "/" + file_name_LPFrontIrr
                
                os.rename(file_name_LPFrontIrr_full, irr_path)
                
            elif os.path.exists(file_name_LPFrontIrr_floatSM1):
                file_name_LPFrontIrr=  file_name_LPFrontIrr_floatSM1
                if np.isnan(theta_eff) == False:
                    irr_path= current_folder_name + '/Irr_Pass/' + file_name_LPFrontIrr
                else:
                    irr_path=current_folder_name + '/Irr_Fail/' + file_name_LPFrontIrr
                
                file_name_LPFrontIrr_full=current_folder_name + "/" + file_name_LPFrontIrr
                
                os.rename(file_name_LPFrontIrr_full, irr_path)
                
            elif os.path.exists(file_name_LPFrontIrr_floatSM2):
                file_name_LPFrontIrr=  file_name_LPFrontIrr_floatSM2
                if np.isnan(theta_eff) == False:
                    irr_path= current_folder_name + '/Irr_Pass/' + file_name_LPFrontIrr
                else:
                    irr_path=current_folder_name + '/Irr_Fail/' + file_name_LPFrontIrr
                
                file_name_LPFrontIrr_full=current_folder_name + "/" + file_name_LPFrontIrr
                
                os.rename(file_name_LPFrontIrr_full, irr_path)
                
            elif os.path.exists(file_name_LPFrontIrr_floatNone):
                file_name_LPFrontIrr=  file_name_LPFrontIrr_floatNone
                if np.isnan(theta_eff) == False:
                    irr_path= current_folder_name + '/Irr_Pass/' + file_name_LPFrontIrr
                else:
                    irr_path=current_folder_name + '/Irr_Fail/' + file_name_LPFrontIrr
                
                file_name_LPFrontIrr_full=current_folder_name + "/" + file_name_LPFrontIrr
                
                os.rename(file_name_LPFrontIrr_full, irr_path)
            else:
                print("No pics!")
                
            # if np.isnan(theta_eff) == False:
            #     irr_path= current_folder_name + '/Irr_Pass/' + file_name_LPFrontIrr
            # else:
            #     irr_path=current_folder_name + '/Irr_Fail/' + file_name_LPFrontIrr
                
            # file_name_LPFrontIrr_full=current_folder_name + "/" + file_name_LPFrontIrr
                
            # os.rename(file_name_LPFrontIrr_full, irr_path)
     
            
            
            
            
            
            #Gets the beam incident angle to LP Front, which ends up being the same as theta leaving LP End
            if whichWedge !=0:
                # For the wedge, get BIA by looking at light leaving back of wedge base
                #Establishes wedge base file and data frame
                file_name_WedgeBase_floatBoth='Incident_Wedge' + whichWedge + '_WedgeBase_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
                file_name_WedgeBase_floatSM1='Incident_Wedge' + whichWedge + '_WedgeBase_SM1_' + str(float(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'
                file_name_WedgeBase_floatSM2='Incident_Wedge' + whichWedge + '_WedgeBase_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(float(SM2_angle_round)) + '.csv'
                file_name_WedgeBase_floatNone='Incident_Wedge' + whichWedge + '_WedgeBase_SM1_' + str(int(SM1_angle_round)) + '_SM2_' + str(int(SM2_angle_round)) + '.csv'

                #Check if WedgeBase name exists
                if os.path.exists(file_name_WedgeBase_floatBoth):
                    df_WedgeBase_All=pd.read_csv(file_name_WedgeBase_floatBoth,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
                elif os.path.exists(file_name_WedgeBase_floatSM1):
                    df_WedgeBase_All=pd.read_csv(file_name_WedgeBase_floatSM1,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
                elif os.path.exists(file_name_WedgeBase_floatSM2):
                    df_WedgeBase_All=pd.read_csv(file_name_WedgeBase_floatSM2,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
                else:
                    df_WedgeBase_All=pd.read_csv(file_name_WedgeBase_floatNone,names=["Split","Type","Inc Flux","X Pos","Y Pos","Z Pos"], header=7, usecols=[2,3,5,7,8,9],skip_blank_lines=True)
        
                splitWedgeBaseAll=df_WedgeBase_All["Split"]
                splitMinWedgeBase=splitWedgeBaseAll.min()
                indexNamesWedgeBase=df_WedgeBase_All[df_WedgeBase_All['Split'] > splitMinWedgeBase].index
                df_WedgeBase=df_WedgeBase_All.drop(indexNamesWedgeBase)
                
                #Gets y pos at wedge base, then gets the distance then gets BIA
                y_pos_WedgeBase=df_WedgeBase["Y Pos"].mean()
                deltaY_Base_Front=avg_LPFront_Y-y_pos_WedgeBase
                
                beam_inc_angle=np.rad2deg(np.arctan2(deltaY_Base_Front,0.25))
                
            else:    
                #For no wedge case, get BIA with SM2 face
                deltaY_SM2Face_Front=avg_LPFront_Y-y_pos_SM2Face
                deltaZ_SM2Face_Front=avg_LPFront_Z-z_pos_SM2Face
                
                beam_inc_angle=np.rad2deg(np.arctan2(deltaY_SM2Face_Front,deltaZ_SM2Face_Front))
                
                
            #If inc flux at LP Front is less than half, stops the loop, fills in the lists and puts in nan's
            if inc_flux_sum_LPFront <138:          
                
                l_SM1.append(SM1_angle)
                l_SM2.append(SM2_angle)
                l_avg_Top.append(np.nan)
                l_avg_Bottom.append(np.nan)

                l_inc_flux_sum_Top.append(np.nan)
                l_inc_flux_sum_Bottom.append(np.nan)
                l_inc_flux_sum_LPFront.append(inc_flux_sum_LPFront)
                l_inc_flux_sum_LPEnd.append(np.nan)
                l_avg_LPFront.append(np.nan)
            
                l_Y_LPCenter.append(np.nan)
                l_Z_Screen.append(np.nan)
            
                l_deltaY_Top.append(np.nan)
                l_deltaY_Bottom.append(np.nan)
                l_Theta_Top.append(np.nan)
                l_Theta_Bottom.append(np.nan)
                l_Theta_Abs.append(np.nan)
            
                l_delta_Y_LPFront.append(np.nan)
                l_delta_X_LPFront.append(np.nan)
                l_ratio_YX_LPFront.append(np.nan)   
                l_beam_inc_angle.append(np.nan)
                l_theta_eff.append(np.nan)
                
                status="Not enough inc flux in LPFront"
                
                l_status.append(status)
                SM2_angle = round(SM2_angle, 2) + inc_SM2
                continue

            
            
            #Puts all relevant info into its own list so it can be assemebeled
            l_SM1.append(SM1_angle)
            l_SM2.append(SM2_angle)
            l_avg_Top.append(avg_Top_Y)
            l_avg_Bottom.append(avg_Bottom_Y)
            l_inc_flux_sum_Top.append(inc_flux_sum_Top)
            l_inc_flux_sum_Bottom.append(inc_flux_sum_Bottom)
            l_inc_flux_sum_LPFront.append(inc_flux_sum_LPFront)
            l_inc_flux_sum_LPEnd.append(inc_flux_sum_LPEnd)
            l_avg_LPFront.append(avg_LPFront_Y)
            
            l_Y_LPCenter.append(y_LPCenter)
            l_Z_Screen.append(z_Screen)
            
            l_deltaY_Top.append(deltaY_Top)
            l_deltaY_Bottom.append(deltaY_Bottom)
            l_Theta_Top.append(theta_Top)
            l_Theta_Bottom.append(theta_Bottom)
            l_Theta_Abs.append(theta_Abs)
            
            l_delta_Y_LPFront.append(delta_Y_LPFront)
            l_delta_X_LPFront.append(delta_X_LPFront)
            l_ratio_YX_LPFront.append(ratio_YX_LPFront)
            l_beam_inc_angle.append(beam_inc_angle)
            l_theta_eff.append(theta_eff)
            
            l_status.append(status)
            
            SM2_angle = round(SM2_angle, 2) + inc_SM2
            
    SM2_angle= SM2_angle_orig
    SM1_angle = round(SM1_angle, 2) + inc_SM1
    
print("Finished loop!")

#Puts together a data frame with all the relavant lists
df_full=pd.DataFrame(data={"SM1": l_SM1,
                           "SM2":l_SM2,
                           "LP Inc Flux Front":l_inc_flux_sum_LPFront,
                           "LP Front Y avg":l_avg_LPFront,
                           "LP Front Beam Spot Y":l_delta_Y_LPFront,
                           "LP Front Beam Spot X":l_delta_X_LPFront,
                           "LPFront Beam Spot Y/X Ratio":l_ratio_YX_LPFront,
                           "Beam Incidence Angle at LP Front":l_beam_inc_angle,
                           "LP Inc Flux End":l_inc_flux_sum_LPEnd,
                           "Y LP End Center":l_Y_LPCenter,
                           "Z Screen":l_Z_Screen,
                           "Top Y avg":l_avg_Top,
                           "Top Total Incident Flux":l_inc_flux_sum_Top,
                           "Delta Y Top":l_deltaY_Top,
                           "Theta Top":l_Theta_Top,
                           "Bottom Y avg":l_avg_Bottom,
                           "Bottom Total Incident Flux":l_inc_flux_sum_Bottom,
                           "Delta Y bottom":l_deltaY_Bottom,
                           "Theta Bottom":l_Theta_Bottom,
                           "Theta Absolute":l_Theta_Abs,
                           "Theta Effective":l_theta_eff,
                           "Status": l_status})

print("Finished making data frame!")

#Makes a list of (SM1, SM2) for the given range to make later plots easier
l_together=list()
for r in range (0,len(l_SM2)) :
    together="(" + str(l_SM1[r]) + "," + str(l_SM2[r]) + ")"
    l_together.append(together)
    
df_together=pd.DataFrame(data= {"together":l_together})
    
df_together.to_excel("Numbers.xlsx",sheet_name="name",index=False)




#Send the final dataframe to an excel file
df_full.to_excel('FullSet_Wedge' + whichWedge + '_Measurements.xlsx',sheet_name='Wedge' + whichWedge ,index=False)

print("Finished sending to csv!")

print(df_full)
print("Max Abs Theta=")
print(df_full["Theta Absolute"].max())

print("Max Eff Theta=")
print(df_full["Theta Effective"].max())
