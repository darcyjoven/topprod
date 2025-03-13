# Prog. Version..: '5.30.06-13.03.26(00006)'     #
#
# Pattern name...: p_copy.4gl
# Descriptions...: Genero Report 複製報表相關資訊
# Date & Author..: 12/03/01 JanetHuang
# Modify.........: No.FUN-C30005 12/03/01 By janet  Genero Report 複製報表相關資訊
# Modify.........: No.FUN-C30290 12/03/27 By janet  畫面修改增加cop1~gdw03_n欄位' gdw_file複製FUNCTION
# Modify.........: No.TQC-C50078 12/05/09 By janet 修改p_replang_updgdm_m() 可能會造成-391錯誤
# Modify.........: No.FUN-C90038 12/10/09 By janet 修改來源4rp目錄權限，改成511' 目的檔案gdw03_n客製勾取的判斷
# Modify.........: No.FUN-D20068 13/02/20 By janet 複製4rp檔案時，以gay_file內的語系為主
# Modify.........: No.CHI-D30013 13/03/26 by odyliao 調整 p_replang_readnodes 增加傳參數 p_code 以修正行序欄序問題

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_simtab   LIKE  gdw_file.gdw01
DEFINE g_cust     LIKE  gdw_file.gdw01
DEFINE g_chk_err_msg        STRING  #FUN-C30290ADD #檢查報表命名規則的錯誤訊息 

#FUN-C30290  ADD-START
DEFINE g_gdw            RECORD         
         gaz03_o          LIKE gaz_file.gaz03,   # 程式名稱(來源)
         gdw05_o           LIKE gdw_file.gdw05,   # 使用者
         zx02_o           LIKE zx_file.zx02,     # 使用者姓名
         gdw04_o           LIKE gdw_file.gdw04,   # 權限類別
         zw02_o           LIKE zw_file.zw02,     # 權限類別說明
         gdw01_n          LIKE gdw_file.gdw01,    #程式代碼 (目的)
         gaz03_n          LIKE gaz_file.gaz03,   # 程式名稱 (目的)
         gdw05_n           LIKE gdw_file.gdw05,   # 使用者
         zx02_n           LIKE zx_file.zx02,     # 使用者姓名
         gdw04_n          LIKE gdw_file.gdw04,   # 權限類別
         zw02_n          LIKE zw_file.zw02     # 權限類別說明
         END RECORD
DEFINE   g_cnt          LIKE type_file.num10
#FUN-C30290  ADD-END
#FUN-C30005 add
FUNCTION s_gr_grw(g_gdw08_o,g_gdw09_o)

  #FUN-C30290 MARK-START
     #DEFINE   s_cop   RECORD
             #l_cop01  LIKE gdw_file.gdw01,
             #l_cop02  LIKE gaz_file.gaz03,
             #l_cop03  LIKE gdw_file.gdw01,
             #l_cop04  LIKE gaz_file.gaz03,
             #l_chk_grw  LIKE type_file.chr1,
             #l_cop06  LIKE type_file.chr1,
             #l_chk_4rp  LIKE type_file.chr1
#
             #END RECORD
  #FUN-C30290 MARK-START
     DEFINE  gdw01_n  LIKE gdw_file.gdw01
    # DEFINE  cop02,cop04  LIKE gaz_file.gaz03
     DEFINE  g_gdw08_o       LIKE gdw_file.gdw08 #存舊的gdw08
     DEFINE  g_gdw09_o       LIKE gdw_file.gdw09 #存舊的gdw09
     DEFINE  l_gdw09_n       LIKE gdw_file.gdw09 #gdw09     
     DEFINE  chk_grw,chk_replang,chk_4rp  LIKE type_file.chr1 
     DEFINE  gdw05_n          LIKE gdw_file.gdw05,  #FUN-C30290 ADD
             gdw04_n         LIKE gdw_file.gdw04,  #FUN-C30290 ADD
             gdw02_n         LIKE gdw_file.gdw02,  #FUN-C30290 ADD
             gdw06_n         LIKE gdw_file.gdw06,  #FUN-C30290 ADD
             gdw03_n         LIKE type_file.chr1 ,         #FUN-C30290 ADD
             gdw05_o          LIKE gdw_file.gdw05,  #FUN-C30290 ADD
             gdw04_o         LIKE gdw_file.gdw04  #FUN-C30290 ADD
     DEFINE  chk_grw_w,chk_replang_w,chk_4rp_w  LIKE type_file.chr1   #FUN-C30290 ADD       
             
     DEFINE  g_gdw01       LIKE gdw_file.gdw01     #程式名稱
     DEFINE  g_gdw02       LIKE gdw_file.gdw02     #報表樣版
     DEFINE  l_gdw01       LIKE gdw_file.gdw01     #程式名稱(目的)
     DEFINE  l_gdw02       LIKE gdw_file.gdw02     #報表樣版
     DEFINE  l_gdw03       LIKE gdw_file.gdw03     #客製否
     DEFINE  l_gdw05       LIKE gdw_file.gdw05     #使用者
     DEFINE  l_gdw04       LIKE gdw_file.gdw04     #權限
     DEFINE  l_gdw06       LIKE gdw_file.gdw06     #行業別
     DEFINE  l_gdw01_o     LIKE gdw_file.gdw01     #程式代號  #FUN-C30290 ADD
     DEFINE  l_gdw02_o     LIKE gdw_file.gdw02     #報表樣版  #FUN-C30290 ADD
     DEFINE  l_gdw03_o     LIKE gdw_file.gdw03     #客製否    #FUN-C30290 ADD
     DEFINE  l_gdw04_o     LIKE gdw_file.gdw04     #使用者    #FUN-C30290 ADD
     DEFINE  l_gdw05_o     LIKE gdw_file.gdw05     #權限     #FUN-C30290 ADD
     DEFINE  l_gdw06_o     LIKE gdw_file.gdw06     #行業別    #FUN-C30290 ADD     
     DEFINE  l_gdw08_str ,l_NY,l_name       STRING 
     DEFINE  l_prog_n      LIKE gdm_file.gdm01
     DEFINE  l_gdw08_r     DYNAMIC ARRAY OF INTEGER     #樣版ID     
     DEFINE   l_zwacti   LIKE zw_file.zwacti       #FUN-C30290 ADD
     DEFINE   l_flag      LIKE type_file.chr1      #FUN-C30290 ADD



        #FUN-C30290 ADD----START
        OPTIONS                                #改變一些系統預設值
            INPUT NO WRAP,
            FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-73001
        DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
        #FUN-C30290 ADD----START
     
     OPEN WINDOW s_gr_grw_w WITH FORM "sub/42f/s_gr_grw"  ##開窗
     ATTRIBUTE (STYLE = "report") #視窗屬性，可以關閉x
     LET  l_flag= "N"   ##FUN-C30290 ADD
     CALL cl_set_act_visible("accept,exit",True)#將兩個button打開
     CALL cl_set_act_visible("accept,cancel", TRUE)
     CALL cl_ui_init()
     CALL cl_ui_locale("s_gr_grw")


   WHILE l_flag="N"   
     INPUT BY NAME  gdw01_n,chk_grw,chk_replang,chk_4rp,gdw05_n,     #FUN-C30290 ADD cop8
                    gdw04_n,gdw02_n,gdw06_n,gdw03_n,chk_grw_w,chk_replang_w,chk_4rp_w   WITHOUT DEFAULTS  #FUN-C30290 ADD 120402 add ,chk_grw_w,chk_replang_w,chk_4rp_w
     
         BEFORE INPUT  
           #FUN-C30290 MARK-START
            #LET l_gdw01=g_gdw01
            #LET l_gdw02=g_gdw02
            #LET l_gdw03=g_cust
            #LET l_gdw04=g_clas
            #LET l_gdw05=g_user
            #LET l_gdw06=g_sma.sma124
           #FUN-C30290 MARK-END 
            LET chk_grw="Y"
            LET chk_replang="Y"
            LET chk_4rp="Y"
            LET gdw03_n="Y" #FUN-C30290 ADD
            LET chk_grw_w="Y" #FUN-C30290 ADD
            LET chk_replang_w="Y" #FUN-C30290 ADD
            LET chk_4rp_w="Y" #FUN-C30290 ADD
            LET gdw05_n="default" #FUN-C30290 ADD (120405)
            LET gdw04_n="default" #FUN-C30290 ADD (120405)
             CALL s_gr_desc("gdw05_n",gdw05_n)  #FUN-C30290 ADD (120406)
             CALL s_gr_desc("gdw04_n",gdw04_n)  #FUN-C30290 ADD (120406)
            
            IF cl_null(l_gdw06) THEN LET l_gdw06="std" END IF ##若行業別是空，設為std
            
            ##重新計算gdw_file筆數
            #DISPLAY l_gdw01 TO gdw01_o # 傳過來參數名字顯示於欄位#FUN-C30290 MARK
            
            
            #CALL  s_gr_grw_name(l_gdw01) RETURNING  l_name  ##程式名稱  #FUN-C30290 MARK
            #DISPLAY l_name TO cop02  #FUN-C30290 MARK
            
             
            DISPLAY chk_grw TO chk_grw
            DISPLAY chk_replang TO chk_replang
            DISPLAY chk_4rp TO chk_4rp
            DISPLAY gdw03_n TO gdw03_n #FUN-C30290 ADD
            DISPLAY l_gdw06 TO gdw06_n  #FUN-C30290 ADD
            LET gdw06_n=l_gdw06 #FUN-C30290 ADD
            DISPLAY chk_grw_w TO chk_grw_w
            DISPLAY chk_replang_w TO chk_replang_w
            DISPLAY chk_4rp_w TO chk_4rp_w  
            DISPLAY gdw05_n TO gdw05_n  #FUN-C30290 ADD
            DISPLAY gdw04_n TO gdw04_n   #FUN-C30290 ADD        
            #FUN-C30290 ADD-START--
            #顯示來源程式資訊
             SELECT gdw01,gdw02,gdw03,gdw04,gdw05,gdw06 INTO l_gdw01_o,l_gdw02_o,l_gdw03_o,l_gdw04_o,l_gdw05_o,l_gdw06_o FROM gdw_file 
                    WHERE gdw08=g_gdw08_o
             DISPLAY  l_gdw01_o,l_gdw02_o,l_gdw03_o,l_gdw04_o,l_gdw05_o,l_gdw06_o TO gdw01_o,gdw02_o,gdw03_o,gdw04_o,gdw05_o,gdw06_o
             CALL s_gr_desc("gdw01_o",l_gdw01_o)
             CALL s_gr_desc("gdw05_o",l_gdw05_o) 
             CALL s_gr_desc("gdw04_o",l_gdw04_o) 
             CALL cl_set_combo_industry("gdw06_n")   #行業別  
             LET l_gdw03="Y"
             DISPLAY l_gdw03 TO gdw03_n
             IF NOT cl_null(gdw01_n) THEN
                DISPLAY gdw01_n TO gdw02_n 
             END IF 
 

            AFTER INPUT 
                    IF l_gdw01_o=gdw01_n AND l_gdw02_o=gdw02_n AND l_gdw03_o=gdw03_n AND l_gdw04=gdw04_n
                       AND l_gdw05_o=gdw05_n AND l_gdw06_o=gdw06_n THEN                           
                       CALL cl_err(gdw01_n,'axm-298',1) 
                       NEXT FIELD gdw01_n
                    END IF 
                    IF chk_grw="N" AND  chk_replang="N" AND chk_4rp="N" 
                       AND  chk_grw_w="N" AND  chk_replang_w="N" AND chk_4rp_w="N" THEN 
                        CALL cl_err("chkbox",'azz1204',1)    
                    END IF   
           #FUN-C30290 ADD END--             
             AFTER FIELD gdw01_n #目的程式
                       #CONSTRUCT BY NAME gdw01_n ON gdw01_n #從營幕抓值
                       #CALL  s_gr_grw_name(gdw01_n) RETURNING  l_name  ##程式名稱  #FUN-C30290 MARK
                       #DISPLAY l_name TO cop04                                  #FUN-C30290 MARK

                       #FUN-C30290 ADD---START
                       
                       LET g_cnt=0
                       SELECT COUNT(*) INTO g_cnt from zz_file where zz01= gdw01_n
                       IF g_cnt = 0 THEN
                         CALL cl_err(gdw05_n,'azz-052',0)  
                         NEXT FIELD gdw01_n
                       END IF 
                         # IF l_gdw01_o=gdw01_n THEN #FUN-C30290 MARK
                         
                            #CALL cl_err(gdw01_n,'axm-298',1) 
                            #NEXT FIELD gdw01_n
                          #END IF                       
                       #FUN-C30290 ADD---END
                       
                       CALL s_gr_desc("gdw01_n",gdw01_n)  #FUN-C30290 ADD
                       DISPLAY gdw01_n TO gdw02_n
                       LET gdw02_n=gdw01_n 
                       LET l_gdw09_n=cl_replace_str(g_gdw09_o, l_gdw01, gdw01_n)
                       #  NEXT FIELD gdw02_n  #FUN-C30290 ADD   ###FUN-C30290  mark
                       
           #FUN-C30290  ADD-START----
             BEFORE FIELD gdw02_n
                       DISPLAY gdw01_n TO gdw02_n 
             AFTER FIELD gdw02_n
                    #   NEXT FIELD gdw05_n  ##FUN-C30290  mark
             BEFORE FIELD gdw05_n
                   IF INFIELD(gdw05_n) THEN
                      IF g_gdw.gdw05_n = 'default' THEN
                         CALL cl_set_comp_entry("gdw05_n",TRUE)
                      END IF
                   END IF
             AFTER FIELD gdw05_n
                  IF NOT cl_null(gdw05_n) THEN
                        #若user及權限是default，判斷是否有一筆default、default
                        IF gdw04_n CLIPPED <> "default" AND gdw05_n CLIPPED <> "default" THEN
                           SELECT COUNT(*) INTO g_cnt FROM gdw_file
                            WHERE gdw01 = gdw04_o AND gdw02 = gdw02_n
                            AND gdw03 = 'Y' AND gdw04 = 'default'
                            AND gdw05 = 'default' AND gdw06 = 'std'
                           IF g_cnt = 0 THEN  
                              CALL cl_err(gdw05_n,'azz-086',0)                              
                              NEXT FIELD gdw05_n
                           END IF
                        END IF
 

                        #判斷是否有此員工
                        IF gdw05_n CLIPPED  <> 'default' THEN
                           SELECT COUNT(*) INTO g_cnt FROM zx_file
                            WHERE zx01 = gdw05_n 
                           IF g_cnt = 0 THEN
                               CALL cl_err(gdw05_n,'mfg1312',0)
                               NEXT FIELD gdw05_n
                           END IF
                        END IF
                        IF gdw05_n = 'default' THEN
                           IF gdw04_n <> 'default' THEN
                              CALL cl_set_comp_entry("gdw04_n",TRUE)
                              CALL cl_set_comp_entry("gdw05_n",FALSE)
                           ELSE
                              CALL cl_set_comp_entry("gdw04_n",TRUE)
                              CALL cl_set_comp_entry("gdw05_n",TRUE)
                           END IF
                        ELSE
                           IF gdw04_n = 'default' THEN
                              CALL cl_set_comp_entry("gdw05_n",TRUE)
                              CALL cl_set_comp_entry("gdw04_n",FALSE)
                           END IF
                        END IF


                  END IF
                  CALL s_gr_desc("gdw05_n",gdw05_n)
                  # NEXT FIELD gdw06_n  ###FUN-C30290  mark 
             AFTER FIELD gdw06_n

                # NEXT FIELD gdw04_n   ###FUN-C30290  mark
             AFTER FIELD gdw04_n
                     IF NOT cl_null(gdw04_n) THEN
           
                           IF gdw05_n CLIPPED <> "default" AND gdw04_n CLIPPED <> "default" THEN
                               SELECT COUNT(*) INTO g_cnt FROM gdw_file
                                WHERE gdw01 = gdw04_o AND gdw02 = gdw02_n
                                AND gdw03 = 'Y' AND gdw04 = 'default'
                                AND gdw05 = 'default' AND gdw06 = 'std'
                               IF g_cnt = 0 THEN
                                  CALL cl_err(gdw05_n,'azz-086',0)                              
                                  NEXT FIELD gdw05_n
                               END IF
           
                           END IF




                        
                        IF gdw04_n CLIPPED  <> 'default' THEN
                           SELECT zwacti INTO l_zwacti FROM zw_file
                            WHERE zw01 = gdw04_n 
                           IF STATUS THEN
                               CALL cl_err('select '||g_gdw.gdw04_n||" ",STATUS,0)
                               NEXT FIELD gdw04_n
                           ELSE
                              IF l_zwacti != "Y" THEN
                                 CALL cl_err_msg(NULL,"azz-218",gdw04_n CLIPPED,10)
                                 NEXT FIELD gdw04_n
                              END IF
                           END IF
                        END IF
                     END IF
                     
                     
                     IF gdw04_n = 'default' THEN
                        IF gdw05_n <> 'default' THEN
                           CALL cl_set_comp_entry("gdw05_n",TRUE)
                           CALL cl_set_comp_entry("gdw04_n",FALSE)
                        ELSE
                           CALL cl_set_comp_entry("gdw04_n",TRUE)
                           CALL cl_set_comp_entry("gdw05_n",TRUE)
                        END IF
                     ELSE
                        IF gdw04_n = 'default' THEN
                           CALL cl_set_comp_entry("gdw04_n",TRUE)
                           CALL cl_set_comp_entry("gdw05_n",FALSE)
                        END IF
                     END IF
                     CALL s_gr_desc("gdw04_n",gdw04_n)
                    # NEXT FIELD gdw03_n   ###FUN-C30290  mark
 
           #FUN-C30290   ADD-END ---
      

             ON CHANGE chk_grw  
                   LET chk_grw=chk_grw
                   ##FUN-C30290 ADD-START(120406)
                   IF chk_grw="N" THEN 
                      LET chk_grw_w="N" 
                      DISPLAY chk_grw_w TO chk_grw_w
                   END IF 
                   ##FUN-C30290 ADD-END (120406)
             ON CHANGE chk_replang  
                  LET chk_replang=chk_replang  
                  ##FUN-C30290 ADD-START(120406) 
                   IF chk_replang="N" THEN 
                      LET chk_replang_w="N" 
                      DISPLAY chk_replang_w TO chk_replang_w
                   END IF     
                  ##FUN-C30290 ADD-END (120406)              
             ON CHANGE chk_4rp 
                  LET chk_4rp=chk_4rp 
                   ##FUN-C30290 ADD-START(120406) 
                   IF chk_4rp="N" THEN 
                      LET chk_4rp_w="N" 
                      DISPLAY chk_4rp_w TO chk_4rp_w
                   END IF     
                  ##FUN-C30290 ADD-END (120406)                           
             #FUN-C30290 ADD--START
             ON CHANGE chk_grw_w 
                  #FUN-C30290 ADD -start (120406)  
                  IF chk_grw="Y" THEN  
                     LET chk_grw_w=chk_grw_w
                  ELSE 
                    LET chk_grw_w="N"
                  END IF   
                  DISPLAY chk_grw_w TO chk_grw_w 
                  #FUN-C30290 ADD (120406)
             ON CHANGE chk_replang_w  
                  IF chk_replang="Y" THEN  #FUN-C30290 ADD (120406)
                    LET chk_replang_w=chk_replang_w
                  ELSE
                    LET chk_replang_w="N"
                  END IF     #FUN-C30290 ADD (120406)
                  DISPLAY chk_replang_w TO chk_replang_w 
             ON CHANGE chk_4rp_w
                 IF chk_4rp="Y" THEN   #FUN-C30290 ADD (120406)
                     LET chk_4rp_w=chk_4rp_w
                 ELSE 
                     LET chk_4rp_w="N"
                 END IF      #FUN-C30290 ADD (120406)
                 DISPLAY chk_4rp_w TO chk_4rp_w 

              #FUN-C90038 add -(s)
             ON CHANGE gdw03_n
                 IF gdw03_n="Y" THEN   
                     LET gdw03_n=gdw03_n
                 ELSE 
                     LET gdw03_n="N"
                 END IF      
                 DISPLAY gdw03_n TO gdw03_n 
              #FUN-C90038 add -(e)   
                 
             AFTER FIELD chk_4rp_w
                 #產生條件不可全為空白
                 #FUN-C30290 mark-start----
                 #IF chk_grw="N" AND  chk_replang="N" AND chk_4rp="N" 
                     #AND  chk_grw_w="N" AND  chk_replang_w="N" AND chk_4rp_w="N" THEN 
                      #
                      #CALL cl_err("chkbox",'azz1204',1)    
                 #END IF        
                 #FUN-C30290 mark-end----  
            #FUN-C30290 ADD--END              
             ON ACTION accept #確認
                 #FUN-C30290 ADD---START--- (120406)
                 LET l_flag = "Y" 
                # IF l_gdw01_o=gdw01_n THEN  #FUN-C30290 mark
                 IF l_gdw01_o=gdw01_n AND l_gdw02_o=gdw02_n AND l_gdw03_o=gdw03_n AND l_gdw04_o=gdw04_n
                    AND l_gdw05_o=gdw05_n AND l_gdw06_o=gdw06_n THEN   #FUN-C30290 add
                    CALL cl_err(gdw01_n,'axm-298',1) 
                    NEXT FIELD gdw01_n
                 END IF 
                 #產生條件不可全為空白
                 IF chk_grw="N" AND  chk_replang="N" AND chk_4rp="N" 
                     AND  chk_grw_w="N" AND  chk_replang_w="N" AND chk_4rp_w="N" THEN 
                      
                      CALL cl_err("chkbox",'azz1204',1) 
                 ELSE      
                     #FUN-C30290 ADD---END---  (120406)
                     IF chk_grw="Y" THEN  
                        #CALL s_gr_gdwcopy_gdw08(l_gdw09_n,g_gdw08_o,'Y') RETURNING  l_gdw08_str #FUN-C30290 MARK 
                        #CALL s_gr_gdwcopy(g_gdw08_o,cop03,cop12,cop14,cop8,cop10,cop13) RETURNING  l_gdw08_str  #FUN-C30290 mark
                        CALL s_gr_gdwcopy(chk_grw_w,g_gdw08_o,gdw01_n,gdw02_n,gdw03_n,gdw05_n,gdw04_n,gdw06_n) RETURNING  l_gdw08_str  #FUN-C30290 ADD chk_grw_w
                     END IF 
                     IF chk_4rp="Y" THEN
                        #FUN-C30290 MARK-START--
                        #IF cop06="Y" THEN
                           #LET l_NY="Y"  #在複製4rp裡做 gdm
                        #ELSE
                           #LET l_NY="N"  #不用複製4rp裡做 gdm
                        #END IF
                        #FUN-C30290 MARK-END IF--
                        #CALL s_catch_gdw08(cop03,g_gdw08_o) RETURNING l_gdw08_r   #FUN-C30290 MARK
                        #CALL s_gr_4rpcopy(l_gdw01,cop03,l_NY,g_gdw08_o,l_gdw08_r)  #FUN-C30290 MARK                  
                        CALL s_catch_gdw08(gdw01_n,g_gdw08_o,'Y') RETURNING l_gdw08_r    #FUN-C30290 ADD
                        #CALL s_gr_4rpcopy(l_gdw01_o,cop03,l_NY,g_gdw08_o,l_gdw08_r)    #FUN-C30290 mark
                        CALL s_gr_4rpcopy(chk_replang_w,chk_4rp_w,gdw03_n,l_gdw01_o,gdw01_n,l_NY,g_gdw08_o,l_gdw08_r)    #FUN-C30290 ADD
                     #ELSE   #FUN-C30290 MARK
                      END IF  #FUN-C30290 ADD
                        IF chk_replang="Y" THEN
                             
                             CALL s_gr_getpath(chk_replang_w,gdw01_n,gdw02_n,gdw03_n,gdw05_n,gdw04_n,gdw06_n)
                        END IF 
                     #END IF #FUN-C30290 MARK
                     CALL cl_err(gdw01_n,'abm-019',1) #FUN-C30290 ADD

                 END IF 
                 

             ON ACTION CANCEL
                   LET  l_flag ="Y"  #FUN-C30290 add
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time
                   EXIT INPUT
     
           #FUN-C30290  ADD- START------------------- 開窗
             ON ACTION controlp
                 CASE
                     WHEN INFIELD(gdw01_n)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gdw3"                         
                       LET g_qryparam.arg1 =  g_lang                          
                       LET g_qryparam.state = "c"                             
                       LET g_qryparam.default1 = gdw01_n
                       CALL cl_create_qry() RETURNING gdw01_n     
                       DISPLAY gdw01_n TO gdw01_n 
                       CALL s_gr_desc("gdw01_n",gdw01_n)                   
                       NEXT FIELD gdw01_n
         
 
                     WHEN INFIELD(gdw05_n)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zx"          
                        LET g_qryparam.default1 = gdw05_n                      
                        CALL cl_create_qry() RETURNING gdw05_n
                        DISPLAY gdw05_n TO gdw05_n
                        CALL s_gr_desc("gdw05_n",gdw05_n)
                        NEXT FIELD gdw05_n



         
                     WHEN INFIELD(gdw04_n)                    
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zw"
                        LET g_qryparam.default1 = gdw04_n  
                        CALL cl_create_qry() RETURNING  gdw04_n
                        DISPLAY gdw04_n TO gdw04_n
                        CALL s_gr_desc("gdw04_n",gdw04_n)
                        NEXT FIELD gdw04_n
                    #-MOD-9C0052-end-
                    OTHERWISE
                       EXIT CASE
                 END CASE            
            #FUN-C30290  ADD- END -------------------
           
      END INPUT
     #FUN-C30290 add-start 
       IF  l_flag ="N" THEN

 
                 
                     #FUN-C30290 ADD---END---  (120406)
                     IF chk_grw="Y" THEN  
                        #CALL s_gr_gdwcopy_gdw08(l_gdw09_n,g_gdw08_o,'Y') RETURNING  l_gdw08_str #FUN-C30290 MARK 
                        #CALL s_gr_gdwcopy(g_gdw08_o,cop03,cop12,cop14,cop8,cop10,cop13) RETURNING  l_gdw08_str  #FUN-C30290 mark
                        CALL s_gr_gdwcopy(chk_grw_w,g_gdw08_o,gdw01_n,gdw02_n,gdw03_n,gdw05_n,gdw04_n,gdw06_n) RETURNING  l_gdw08_str  #FUN-C30290 ADD chk_grw_w
                     END IF 
                     IF chk_4rp="Y" THEN
 
                        CALL s_catch_gdw08(gdw01_n,g_gdw08_o,'Y') RETURNING l_gdw08_r    #FUN-C30290 ADD
                        
                        CALL s_gr_4rpcopy(chk_replang_w,chk_4rp_w,gdw03_n,l_gdw01_o,gdw01_n,l_NY,g_gdw08_o,l_gdw08_r)    #FUN-C30290 ADD
 
                      END IF  #FUN-C30290 ADD
                        IF chk_replang="Y" THEN
                             
                             CALL s_gr_getpath(chk_replang_w,gdw01_n,gdw02_n,gdw03_n,gdw05_n,gdw04_n,gdw06_n)
                        END IF 
                     #END IF #FUN-C30290 MARK
                     CALL cl_err(gdw01_n,'abm-019',1) #FUN-C30290 ADD   
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time
       END IF  

    END WHILE 
      #FUN-C30290 add-start      
     CLOSE WINDOW s_gr_grw_w
     
END FUNCTION

#FUN-C30290 ADD---START
FUNCTION s_gr_desc(l_column,l_value)
DEFINE l_column   STRING,
       l_value    LIKE type_file.chr10
       
 
   CASE l_column
        WHEN "gdw01_o"
             SELECT gaz03 INTO g_gdw.gaz03_o FROM gaz_file
              WHERE gaz01 = l_value AND gaz02 = g_lang
             IF SQLCA.SQLCODE THEN
                LET g_gdw.gaz03_o = ""
             END IF
             DISPLAY g_gdw.gaz03_o TO gaz03_o
             
        WHEN "gdw05_o"
             SELECT zx02 INTO g_gdw.zx02_o FROM zx_file
              WHERE zx01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_gdw.zx02_o = ""
             END IF
             IF l_value = "default" THEN
                LET g_gdw.zx02_o = "default"
             END IF
             DISPLAY g_gdw.zx02_o TO zx02_o
        WHEN "gdw04_o"
             SELECT zw02 INTO g_gdw.zw02_o FROM zw_file
              WHERE zw01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_gdw.zw02_o = ""
             END IF
             IF l_value = "default" THEN
                LET g_gdw.zw02_o = "default"
             END IF
             DISPLAY g_gdw.zw02_o TO zw02_o
             
        WHEN "gdw01_n"
             SELECT gaz03 INTO g_gdw.gaz03_n FROM gaz_file
              WHERE gaz01 = l_value AND gaz02 = g_lang
             IF SQLCA.SQLCODE THEN
                LET g_gdw.gaz03_n = ""
             END IF
             DISPLAY g_gdw.gaz03_n TO gaz03_n
             
        WHEN "gdw04_n"
             SELECT zw02 INTO g_gdw.zw02_n FROM zw_file
              WHERE zw01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_gdw.zw02_n = ""
             END IF
             IF l_value = "default" THEN
                LET g_gdw.zw02_n = "default"
             END IF             
             DISPLAY g_gdw.zw02_n TO zw02_n
        WHEN "gdw05_n"
             SELECT zx02 INTO g_gdw.zx02_n FROM zx_file
              WHERE zx01 = l_value
             IF SQLCA.SQLCODE THEN
                LET g_gdw.zx02_n = ""
             END IF
             IF l_value = "default" THEN
                LET g_gdw.zx02_n = "default"
             END IF
             DISPLAY g_gdw.zx02_n TO zx02_n             
   END CASE
END FUNCTION
#FUN-C30290 ADD---END

#FUN-C30290 MARK-START---
#FUNCTION s_gr_grw_name(c_prog) #傳回程式名稱
    #DEFINE c_prog       LIKE  gdw_file.gdw01
    #DEFINE l_gdw01        LIKE  gdw_file.gdw01
    #DEFINE l_name       LIKE  gaz_file.gaz03
#
    #LET l_gdw01=c_prog
    #LET l_name=""
    #SELECT gaz03 INTO l_name FROM gaz_file
    #WHERE gaz01 = l_gdw01 AND gaz02 = g_lang
     #IF SQLCA.SQLCODE THEN
        #LET l_name = ""
     #END IF
               #
                     #
#END FUNCTION
#FUN-C30290 MARK-START---

FUNCTION s_catch_gdw08(l_prog_n,l_gdw08_o,l_yn)

  DEFINE l_prog_n       LIKE  gdw_file.gdw01
  DEFINE l_cnt          LIKE  type_file.num5
  DEFINE  l_yn        LIKE type_file.chr1   #判斷g_user是抓環境變數還是default
  DEFINE i            INTEGER 
  DEFINE  l_gdw02       LIKE gdw_file.gdw02     #報表樣版
  DEFINE  l_gdw01_o       LIKE gdw_file.gdw01     #報表樣版
  DEFINE  l_gdw03       LIKE gdw_file.gdw03     #客製否
  DEFINE  l_gdw05       LIKE gdw_file.gdw05     #使用者
  DEFINE  l_gdw04       LIKE gdw_file.gdw04     #權限
  DEFINE  l_gdw06       LIKE gdw_file.gdw06     #行業別  
  DEFINE  l_gdw08       LIKE gdw_file.gdw08     #樣板ID
  DEFINE  l_gdw08_o     LIKE gdw_file.gdw08     #樣板ID
  DEFINE  l_gdw08_r     DYNAMIC ARRAY OF INTEGER     #樣版ID
  DEFINE  l_sql         STRING 
     
     LET l_gdw03="Y"
     #原始
    # LET l_gdw04=g_clas
    # LET l_gdw05=g_user
     IF l_yn="Y" THEN
        LET l_gdw04= "default"
        lET l_gdw05="default"
     ELSE
        LET l_gdw04= "default"
        lET l_gdw05=g_user
     END IF
     LET l_gdw06=g_sma.sma124
     SELECT gdw01,gdw02 INTO l_gdw01_o,l_gdw02 FROM gdw_file 
            WHERE gdw08=l_gdw08_o
     LET l_gdw02=cl_replace_str( l_gdw02, l_gdw01_o, l_prog_n)    

        SELECT COUNT(*) INTO l_cnt FROM gdw_file 
           WHERE gdw01 = l_prog_n
             AND gdw02 = l_gdw02
             AND gdw03 = l_gdw03
             AND gdw04 = l_gdw04
             AND gdw05 = l_gdw05          
             AND gdw06 = l_gdw06  
             ORDER BY gdw07
             
       IF  l_cnt = 0 THEN
           CALL cl_err(l_prog_n,'azz-086',0)
       END IF 

             LET l_sql=" SELECT gdw08 FROM gdw_file ",
                       " WHERE gdw01 = ? AND gdw02 = ?",
                       "  AND gdw03 = ? AND gdw04 = ? ",
                       "  AND gdw05 = ? AND gdw06 =?  "
                     
             DECLARE s_grw_curs1 CURSOR FROM l_sql
             OPEN s_grw_curs1 USING l_prog_n,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06
             CALL l_gdw08_r.clear() 
             
             LET i = 1
            
             FOREACH s_grw_curs1 INTO l_gdw08_r[i]
             
                IF SQLCA.SQLCODE THEN
                   EXIT FOREACH
                END IF
                LET i = i + 1
             END FOREACH  


       
       #FOR  l_i= 1 TO l_cnt
#
            #SELECT gdw08 INTO l_gdw08 FROM gdw_file
            #WHERE gdw01= l_prog_n
            #LET l_gdw08_r[l_i] = l_gdw08   #回傳值
       #END FOR 
       
       RETURN l_gdw08_r
       
END FUNCTION 






#抓目的程式的絕對路徑再呼叫p_replang_rescan4rp()
#FUNCTION s_gr_getpath(l_prog_n) #FUN-C30290 MARK

FUNCTION s_gr_getpath(g_chk06,l_gdw01,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06) #FUN-C30290 ADD
   DEFINE l_gdw01                          LIKE   gdw_file.gdw01  #程式代號 
   DEFINE l_gdw02                          LIKE   gdw_file.gdw02  #樣板名稱
   DEFINE l_gdw03                          LIKE   gdw_file.gdw03  #客製
   DEFINE l_gdw04                          LIKE   gdw_file.gdw04  #權限
   DEFINE l_gdw05                          LIKE   gdw_file.gdw05  #user
   DEFINE l_gdw06                          LIKE   gdw_file.gdw06  # 行業別
   DEFINE l_prog_n                         LIKE   gdw_file.gdw01 #目的檔案
   DEFINE g_chk06                          LIKE   type_file.chr1  #是否覆寫 #FUN-C30290 ADD
   DEFINE l_path_n ,l_path_new             STRING                #目的檔路徑
   DEFINE l_module_n                       LIKE zz_file.zz011  #模組
   DEFINE l_mod_str,l_str_l                STRING    #模組轉換成字串\
   DEFINE l_path_n_s                       STRING 
   DEFINE l_i,l_l ,l_rpt_cnt               LIKE type_file.num5
   DEFINE l_prog_new                       STRING   #存複製新檔名的陣列
   DEFINE l_i_str ,l_path_str              STRING   #存語系的字串
   DEFINE file_path_n                      STRING 
   DEFINE l_cnt                            INTEGER 
   DEFINE l_gdw02_n                        LIKE gdw_file.gdw02
   DEFINE l_gdw08                          LIKE gdw_file.gdw08
   DEFINE l_gdw08_r     DYNAMIC ARRAY OF INTEGER     #樣版ID
   DEFINE l_lang                           LIKE gdw_file.gdw03
   DEFINE l_sql_r                          STRING    #FUN-C30290 ADD
   DEFINE l_gay01                           LIKE gay_file.gay01  #FUN-D20068 add
   DEFINE l_langs        DYNAMIC ARRAY OF STRING     #FUN-D20068 add
   
   LET l_prog_n = l_prog_n
   LET l_module_n = l_module_n
   LET l_gdw02_n= g_simtab
   
   
    SELECT COUNT(*) INTO l_cnt FROM gdw_file 
       WHERE gdw01 = l_gdw01
         AND gdw02 = l_gdw02
         AND gdw03 = l_gdw03
         AND gdw04 = l_gdw04
         AND gdw05 = l_gdw05          
         AND gdw06 = l_gdw06  
   
   IF  l_cnt = 0 THEN
       CALL cl_err(l_prog_n,'azz-086',0)
   END IF 
   
   #FOR  l_i= 1 TO l_cnt
        #SELECT gdw08 INTO l_gdw08 FROM gdw_file
        #WHERE gdw01= l_gdw01 AND gdw02=l_gdw02
        #LET l_gdw08_r[l_i] = l_gdw08   #回傳值
   #END FOR 


             LET l_sql_r=" SELECT gdw08 FROM gdw_file ",
                         " WHERE gdw01 = ? AND gdw02 = ?",
                         " AND gdw03 = ? AND gdw04 = ?",
                         " AND gdw05 = ? AND gdw06 = ?"
                     
             DECLARE getpath_curs1 CURSOR FROM l_sql_r
             OPEN getpath_curs1 USING l_gdw01,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06
             CALL l_gdw08_r.clear() 
             
             LET l_i = 1
            
             FOREACH getpath_curs1 INTO l_gdw08_r[l_i]
                DISPLAY "l_gdw08_r[l_i]:",l_gdw08_r[l_i]
                IF SQLCA.SQLCODE THEN
                   EXIT FOREACH
                END IF
                LET l_i = l_i+ 1
             END FOREACH 


   
   
   SELECT zz011 INTO l_module_n FROM zz_file WHERE zz01= l_gdw01
   LET l_mod_str=l_module_n
   LET l_mod_str=l_mod_str.toLowerCase()
   IF l_mod_str.subString(1,1)="c" THEN #模組字串第一位
         LET l_path_n=fgl_getenv("CUST")#抓路徑
         LET l_mod_str = 'c',l_mod_str.subString(2,l_mod_str.getLength()) CLIPPED  #FUN-C30290 add
   ELSE
        IF l_gdw03="Y" THEN  #FUN-C30290 add
           LET l_path_n=fgl_getenv("CUST")#抓路徑  #FUN-C30290 add
           LET l_mod_str = 'c',l_mod_str.subString(2,l_mod_str.getLength()) CLIPPED  #FUN-C30290 add
        ELSE                             #FUN-C30290 add
         LET l_path_n=fgl_getenv("TOP")#抓路徑
        END IF    #FUN-C30290 add
   END IF
   LET l_path_n =l_path_n CLIPPED,"/" ,l_mod_str,"/" ,"4rp/"
   
   IF os.path.exists(l_path_n) THEN
 
                #IF os.path.chrwx(l_path_n,775) THEN END IF #開來源資料夾權限   #FUN-C90038 mark
                IF os.path.chrwx(l_path_n,511) THEN END IF #開來源資料夾權限    #FUN-C90038 add 
                SELECT COUNT(gdw09) INTO l_rpt_cnt FROM gdw_file  #計算總報表數(含子報表)
                       WHERE gdw01 = l_gdw01 AND gdw02 = l_gdw02
                       AND gdw03 = l_gdw03 AND gdw04 = l_gdw04
                       AND gdw05 = l_gdw05 AND gdw06 = l_gdw06
                LET l_rpt_cnt=l_rpt_cnt-1 #計算子報表數   

                #FUN-D20068 add -(s)
                CALL l_langs.clear()
                DECLARE s_gr_grw_cur1 CURSOR FROM "SELECT gay01 FROM gay_file ORDER BY gay01"
                LET l_i = 1
                FOREACH s_gr_grw_cur1 INTO l_gay01
                    LET l_langs[l_i] = l_gay01
                    LET l_i = l_i + 1
                END FOREACH
                CALL l_langs.deleteElement(l_i)
                
                FOR l_i= 1 TO l_langs.getLength() # 依語系，複製檔案
                #FUN-D20068 add -(e)
                
                #FOR l_i= 0 TO 5            # 五種語系，複製檔案  ##FUN-D20068 mark
                  #LET l_i_str=l_i                              #FUN-D20068 mark
                  LET l_i_str=l_langs[l_i]                      #FUN-D20068 add
                  LET l_path_str =""
                  #LET l_lang=l_i_str                           #FUN-D20068 mark
                  LET l_lang=l_langs[l_i]                       #FUN-D20068 add
                  LET l_path_str =l_path_n CLIPPED ,l_i_str CLIPPED ,"/" 
                  IF os.path.exists(l_path_str) THEN #來源資料夾的語系是否存在

                    #主報表複製
                    LET l_path_n_s=l_path_n CLIPPED,l_i_str CLIPPED,"/",l_gdw02,".4rp"
                    #檔案有存在 做p_replang_rescan4rp的動作
                    #FUN-C30290 ADD-START
                       IF os.Path.exists(l_path_n_s) THEN 

                             CALL p_replang_rescan4rp_m(g_chk06,l_path_n_s,l_gdw08_r[1],l_lang) 

                       END IF 
                     #FUN-C30290  ADD-END
                    # IF os.Path.exists(l_path_n_s) THEN CALL p_replang_rescan4rp(l_path_n_s,l_gdw08_r[1],l_lang) END IF #FUN-C30290  MARK
                    #IF os.Path.exists(l_path_n_s) THEN CALL p_replang_rescan4rp(l_path_n_s,l_prog_n,l_lang) END IF 
                    #子報表的複製
                    IF l_rpt_cnt>0 THEN #有才需要複製
                        FOR l_l=1 TO l_rpt_cnt
                           LET l_str_l =l_l USING "&&"  #子報表的01表現

                              LET l_path_new=l_path_n
                              LET file_path_n=l_path_n CLIPPED,l_i_str CLIPPED ,"/",l_gdw02,"_subrep",l_str_l,".4rp"
                               ##判斷檔案是否存在做p_replang_rescan4rp的動作

                                 #FUN-C30290 ADD-START
                                   IF os.Path.exists(file_path_n) THEN 

                                         CALL p_replang_rescan4rp_m(g_chk06,file_path_n,l_gdw08_r[1+l_l],l_lang) 

                                   END IF 
                                 #FUN-C30290  ADD-END                              
                               
                             # IF  os.Path.exists(file_path_n) THEN  CALL p_replang_rescan4rp(file_path_n,l_gdw08_r[l_l],l_lang) END IF #FUN-C30290 MARK

                              
                        END FOR 
                    END IF 
                  ELSE 
                     CALL cl_err('path','ain-176',0)
                  END IF  #IF os.path.exists(l_path_str) THEN #來源資料夾的語系是否存在
                END FOR # 五種語系，複製檔案
   ELSE
      CALL cl_err('path','ain-176',0)
   END IF 

   
END FUNCTION


#FUN-C30290  ADD-START=====
#將p_replang rescan(重新掃描4rp)共用function搬到共用區
FUNCTION p_replang_rescan4rp_m(g_chk06,ps_4rppath,p_gdm01,p_gdm03)
   DEFINE ps_4rppath STRING                                    #4rp路徑
   DEFINE g_chk06    LIKE type_file.chr1
   DEFINE p_gdm01    LIKE gdm_file.gdm01                       #報表樣板ID
   DEFINE p_gdm03    LIKE gdm_file.gdm03                       #語言別
   DEFINE la_gdm     DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE l_doc      om.DomDocument
   DEFINE l_rootnode om.DomNode
   
    
   CALL la_gdm.clear()     #初始化陣列
   
   LET g_chk_err_msg = NULL

   #將4rp欄位屬性讀入陣列
   LET l_doc = om.DomDocument.createFromXmlFile(ps_4rppath)
   LET l_rootnode = l_doc.getDocumentElement()
   
 #CHI-D30013 modify-------(S)
  #CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01)
  #CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01)
  #CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01)
  #CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01)
  #CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01)
   CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01,'1')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01,'2')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01,'1')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01,'2')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01,'1')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01,'2')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01,'1')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01,'2')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01,'1')
   CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01,'2')
 #CHI-D30013 modify-------(E)

   #顯示檢查命名規則的錯誤訊息
   IF g_chk_err_msg IS NOT NULL THEN
      CALL cl_err(g_chk_err_msg,"!",-1)
      RETURN
   END IF

   CALL p_replang_updgdm_m(g_chk06,la_gdm,p_gdm01,p_gdm03)
END FUNCTION

#將4rp欄位屬性寫入DB的gdm_file(需覆寫時才先刪除後新增)
FUNCTION p_replang_updgdm_m(g_chk06,pa_gdm,p_gdm01,p_gdm03)
   DEFINE pa_gdm     DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE g_chk06    LIKE type_file.chr1
   DEFINE p_gdm01    LIKE gdm_file.gdm01                       #報表樣板ID
   DEFINE p_gdm03    LIKE gdm_file.gdm03                       #語言別
   DEFINE li_i,l_cnt       LIKE type_file.num5              
   DEFINE ls_colname STRING                                    #處理過的欄位名稱
   DEFINE ls_errmsg  STRING
   DEFINE ls_coldesc STRING

   WHENEVER ERROR CALL cl_err_msg_log #TQC-C50078 add
   LET ls_errmsg = "" 
   
   
   SELECT count(*) INTO l_cnt FROM gdm_file WHERE gdm01 = p_gdm01 AND gdm03 = p_gdm03
   IF l_cnt > 0 THEN 
       IF g_chk06="Y" THEN  #覆寫功能，先刪掉
           DELETE FROM gdm_file WHERE gdm01 = p_gdm01 AND gdm03 = p_gdm03
           IF SQLCA.SQLCODE THEN
              LET ls_errmsg = ls_errmsg,SQLCA.SQLCODE," '",
                              pa_gdm[li_i].gdm04 CLIPPED,"' ",
                              cl_getmsg(SQLCA.SQLCODE,g_lang),"\n"
           END IF
              #TQC-C50078 ---add start
               FOR li_i = pa_gdm.getLength() TO 1 STEP -1
                   IF cl_null(pa_gdm[li_i].gdm02) THEN 
                      CALL pa_gdm.deleteElement(li_i)
                   END IF
               END FOR
               #TQC-C50078 ---add end
               #將la_upd_gdm陣列更新到資料庫
               FOR li_i = 1 TO pa_gdm.getLength()    
                  IF cl_null(pa_gdm[li_i].gdm02) THEN CONTINUE FOR END IF #TQC-C50078 
                  #若4rp的多欄位說明為空白時自動取得翻譯的說明內容
                  IF cl_null(pa_gdm[li_i].gdm23) THEN
                     LET ls_colname = p_replang_getcolname(pa_gdm[li_i].gdm04 CLIPPED)
                     LET pa_gdm[li_i].gdm23 = cl_get_feldname(ls_colname,p_gdm03)
                  END IF

                  #單頭欄位說明尾端需加冒號(:)
                  LET ls_coldesc = pa_gdm[li_i].gdm23 CLIPPED               
                  IF pa_gdm[li_i].gdm05 = "1" 
                     AND ls_coldesc.getCharAt(ls_coldesc.getLength()) != ":" 
                  THEN
                     LET pa_gdm[li_i].gdm23 = pa_gdm[li_i].gdm23 CLIPPED,":"
                  END IF

                  INSERT INTO gdm_file VALUES (pa_gdm[li_i].*)
                  IF SQLCA.SQLCODE THEN
                     LET ls_errmsg = ls_errmsg,SQLCA.SQLCODE," '",
                                     pa_gdm[li_i].gdm04 CLIPPED,"' ",
                                     cl_getmsg(SQLCA.SQLCODE,g_lang),"\n"
                  END IF
               END FOR

               IF ls_errmsg.getLength() > 0 THEN
                  CALL cl_err(ls_errmsg,"!",0)
               END IF           
        END IF 
   ELSE  #沒有資料時，寫入
           #將la_upd_gdm陣列更新到資料庫
           FOR li_i = 1 TO pa_gdm.getLength()    
              #若4rp的多欄位說明為空白時自動取得翻譯的說明內容
              IF cl_null(pa_gdm[li_i].gdm23) THEN
                 LET ls_colname = p_replang_getcolname(pa_gdm[li_i].gdm04 CLIPPED)
                 LET pa_gdm[li_i].gdm23 = cl_get_feldname(ls_colname,p_gdm03)
              END IF

              #單頭欄位說明尾端需加冒號(:)
              LET ls_coldesc = pa_gdm[li_i].gdm23 CLIPPED               
              IF pa_gdm[li_i].gdm05 = "1" 
                 AND ls_coldesc.getCharAt(ls_coldesc.getLength()) != ":" 
              THEN
                 LET pa_gdm[li_i].gdm23 = pa_gdm[li_i].gdm23 CLIPPED,":"
              END IF

              INSERT INTO gdm_file VALUES (pa_gdm[li_i].*)
              IF SQLCA.SQLCODE THEN
                 LET ls_errmsg = ls_errmsg,SQLCA.SQLCODE," '",
                                 pa_gdm[li_i].gdm04 CLIPPED,"' ",
                                 cl_getmsg(SQLCA.SQLCODE,g_lang),"\n"
              END IF
           END FOR

           IF ls_errmsg.getLength() > 0 THEN
              CALL cl_err(ls_errmsg,"!",0)
           END IF      
   END IF 

END FUNCTION 

#FUN-C30290  ADD-END=====
