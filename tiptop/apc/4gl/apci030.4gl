# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: "apci030.4gl"
# Descriptions...: 下傳資料設置項作業
# Date & Author..: 10/03/26 by huangrh
# Modify.........: No.FUN-A60066 10/07/11 By bnlent 促銷作業下傳設置改變and鞋服二維資料
#FUN-A30111-----add-- 
# Modify.........: No.FUN-A70084 10/07/28 By lutingting gai_file改串zta_file
# Modify.........: No.FUN-A90033 10/09/17 By suncx UI 界面重新設計, 並新增下傳設定項目.
# Modify.........: No:TQC-AC0206 10/12/16 By wangxin 畫面重新調整，并修改相關邏輯
# Modify.........: No:MOD-AC0225 10/12/20 By wangxin 將右邊的「全部選擇」或「全部取消」按鈕, 移到Toolbar「更改」事件內
# Modify.........: No:FUN-B10011 11/01/07 By wangxin 公告欄隱藏
# Modify.........: No:TQC-B10111 11/01/07 By shiwuying Bug 修改
# Modify.........: No:TQC-B20166 11/02/24 By wangxin 下傳資料添加卡種資料
# Modify.........: No:FUN-B30164 11/03/22 By wangxin 拿掉公告欄隱藏
# Modify.........: No:TQC-B50011 11/05/09 By Cockroach 公告欄中間庫table變動
# Modify.........: No:FUN-B70011 11/07/06 By huangtao 畫面重新調整
# Modify.........: No:FUN-B90049 11/09/07 By huangtao 去掉產品條碼資料
# Modify.........: No:FUN-BC0015 11/12/09 By pauline 新增下傳資料設置 
# Modify.........: No:TQC-C20449 12/02/24 By chenwei 將列印與匯出Excel  Disable
# Modify.........: No:FUN-C50017 12/05/07 By yangxf 更改画面和INPUT操作方式
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.FUN-CA0074 12/10/15 By xumm 增加门店参数资料栏位
# Modify.........: No.FUN-CB0007 12/11/06 By xumm 增加会员等级和会员类型的下传
# Modify.........: No.FUN-CC0116 13/01/14 By xumm 增加专柜抽成资料的下传
# Modify.........: No.FUN-D20020 13/02/20 By dongsz 增加觸屏資料的下傳

DATABASE ds
 
GLOBALS "../../config/top.global"
#mark by suncx FUN-A90033 begin------------ 
#DEFINE g_ryk   DYNAMIC ARRAY OF RECORD 
#                ryk05       LIKE ryk_file.ryk05,
#                ryk01       LIKE ryk_file.ryk01,
#                ryk02       LIKE ryk_file.ryk02,
#                ryk03       LIKE ryk_file.ryk03,
#                ryk04       LIKE ryk_file.ryk04
#                        END RECORD,
#        g_ryk_t RECORD
#                ryk05       LIKE ryk_file.ryk05,
#                ryk01       LIKE ryk_file.ryk01,
#                ryk02       LIKE ryk_file.ryk02,
#                ryk03       LIKE ryk_file.ryk03,
#                ryk04       LIKE ryk_file.ryk04
#                        END RECORD
#mark by suncx FUN-A90033 end  ------------ 

#add by suncx FUN-A90033 begin------------ 
DEFINE  g_ryk   DYNAMIC ARRAY OF RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE type_file.chr1
                END RECORD
                
DEFINE  g_ryk_o DYNAMIC ARRAY OF RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE type_file.chr1
                END RECORD                
                                        
#add by suncx FUN-A90033 end------------ 
DEFINE  g_sql   STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_cnt           LIKE type_file.num10
DEFINE g_choice1   LIKE type_file.chr1   #TQC-AC0206 add
DEFINE g_choice2   LIKE type_file.chr1   #TQC-AC0206 add
DEFINE g_choice3   LIKE type_file.chr1   #TQC-AC0206 add
DEFINE g_choice4   LIKE type_file.chr1   #TQC-AC0206 add
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF

    CALL  cl_used(g_prog,g_time,1)      
         RETURNING g_time   
           
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i030_w AT p_row,p_col WITH FORM "apc/42f/apci030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("ryk01",FALSE)
    #CALL cl_set_comp_visible("ryk0524",FALSE)  #FUN-B10011 add #FUN-B30164 mark
    CALL i030_insert()
    LET g_wc2 = "1=1"
    #CALL i030_b_fill(g_wc2)    #mark by suncx FUN-A90033
    CALL i030_show(g_wc2)   #add by suncx FUN-A90033
    CALL i030_menu()
    CLOSE WINDOW i030_w                   
    CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
#mark by suncx FUN-A90033 begin------------ 
#FUNCTION i030_bp(p_ud)
#   DEFINE   p_ud   LIKE type_file.chr1          
# 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN
#      RETURN
#   END IF
# 
#   LET g_action_choice = ''
# 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_ryk TO s_ryk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   
#      
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#
#      #No.FUN-A60066 ...begin
#      ON ACTION reset 
#         LET g_action_choice="reset"
#         EXIT DISPLAY
#      #No.FUN-A60066 ...end
#
#      ON ACTION selectall 
#         UPDATE ryk_file SET ryk05 = 'Y'
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL cl_err3("upd","ryk_file","","",SQLCA.sqlcode,"","",1)
#         ELSE
#            MESSAGE 'UPDATE O.K'
#            COMMIT WORK
#            CALL i030_b_fill(g_wc2)
#         END IF
#
#      ON ACTION cancelall
#         UPDATE ryk_file SET ryk05 = 'N'
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL cl_err3("upd","ryk_file","","",SQLCA.sqlcode,"","",1)
#         ELSE
#            MESSAGE 'UPDATE O.K'
#            COMMIT WORK
#            CALL i030_b_fill(g_wc2)
#         END IF
#
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                  
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#    ON ACTION controlg
#      LET g_action_choice="controlg"
#      EXIT DISPLAY
# 
#    ON ACTION accept
#      LET g_action_choice="detail"
#      LET l_ac = ARR_CURR()
#      EXIT DISPLAY
# 
#    ON ACTION cancel
#      LET INT_FLAG=FALSE 		
#      LET g_action_choice="exit"
#      EXIT DISPLAY
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
# 
#      ON ACTION about         
#         CALL cl_about()      
#            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#    END DISPLAY
#    CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#mark by suncx FUN-A90033 end------------  
FUNCTION i030_menu()
   #mark by suncx FUN-A90033 begin------------ 
   #WHILE TRUE
   #   CALL i030_bp("G")
   #   CASE g_action_choice
   #      WHEN "detail"
   #         IF cl_chk_act_auth() THEN
   #            CALL i030_b()
   #         ELSE
   #            LET g_action_choice = NULL
   #         END IF
   #      #No.FUN-A60066 ..begin
   #      WHEN "reset"
   #         IF cl_chk_act_auth() THEN
   #            CALL i030_reset()
   #         ELSE
   #            LET g_action_choice = NULL
   #         END IF
   #      #No.FUN-A60066 ..end
   #
   #      WHEN "output"
   #         IF cl_chk_act_auth() THEN
   #            CALL i030_out()
   #         END IF
   #      WHEN "help"
   #         CALL cl_show_help()
   #      WHEN "exit"
   #         EXIT WHILE
   #      WHEN "controlg"
   #         CALL cl_cmdask()       
   #      WHEN "exporttoexcel"
   #          IF cl_chk_act_auth() THEN
   #             CALL cl_export_to_excel
   #             (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryk),'','')
   #          END IF        
   #   END CASE
   #END WHILE
   #mark by suncx FUN-A90033 end------------ 
   
   #add by suncx FUN-A90033 begin------------ 
   MENU ""
      BEFORE MENU

      ON ACTION reset 
         LET g_action_choice = "reset"
         IF cl_chk_act_auth() THEN
            CALL i030_reset()
         END IF
         
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i030_u()
         END IF

#mark by TQC-C20449----sta
#      ON ACTION output
#         IF cl_chk_act_auth() THEN
#            CALL i030_out()
#         END IF
#mark by TQC-C20449----end

      ON ACTION help
         CALL cl_show_help()
         
      ON ACTION controlg   
         CALL cl_cmdask()
         
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU       
      
      COMMAND KEY(INTERRUPT)
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT MENU 
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about         
         CALL cl_about() 
     
#mark by TQC-C20449----sta            
#      ON ACTION exporttoexcel
#         IF cl_chk_act_auth() THEN
#            CALL cl_export_to_excel
#            (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryk),'','')
#         END IF    
#mark by TQC-C20449----end
      
   END MENU
   #add by suncx FUN-A90033 end------------ 
END FUNCTION
#add by suncx FUN-A90033 begin------------ 
FUNCTION i030_u()
DEFINE l_max,l_n INTEGER
   LET g_forupd_sql = "SELECT ryk05,ryk01,ryk02,ryk03,ryk04",
                      " FROM ryk_file",
                      " WHERE ryk01=?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i030_cl CURSOR FROM g_forupd_sql
   CALL cl_opmsg('u')
    
   WHILE TRUE
      CALL i030_i('u')
      LET l_max = g_ryk.getLength()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL i030_show("1=1")  
         EXIT WHILE
      END IF
      BEGIN WORK
      FOR l_n = 1 TO l_max
         OPEN i030_cl USING g_ryk_o[l_n].ryk01 
         IF STATUS THEN
            CALL cl_err("OPEN i030_cl:",STATUS,1)
            CLOSE i030_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_ryk[l_n].ryk05 <> g_ryk_o[l_n].ryk05 THEN
            UPDATE ryk_file SET ryk05 = g_ryk[l_n].ryk05
            WHERE ryk01 = g_ryk[l_n].ryk01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ryk[l_n].ryk01,SQLCA.sqlcode,1)
               RETURN
            END IF
            CLOSE i030_cl
         END IF
      END FOR
      EXIT WHILE
   END WHILE
   COMMIT WORK
#  CALL i030_show("1=1")            #FUN-C50017 mark
   CALL i030_fill()                 #FUN-C50017 add
END FUNCTION

FUNCTION i030_i(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1 
   DEFINE l_max,l_n INTEGER
   
   CALL g_ryk_o.clear()
   LET l_max = g_ryk.getLength()
   FOR l_n = 1 TO l_max
      LET g_ryk_o[l_n].* = g_ryk[l_n].*
   END FOR       

#   DISPLAY g_choice1,g_choice2,g_choice3,g_choice3,   #TQC-AC0206 add
#           g_ryk[1].ryk05,g_ryk[2].ryk05,g_ryk[3].ryk05,g_ryk[5].ryk05,g_ryk[7].ryk05,
#           g_ryk[10].ryk05,g_ryk[11].ryk05,g_ryk[12].ryk05,g_ryk[14].ryk05,
#           g_ryk[15].ryk05,g_ryk[16].ryk05,g_ryk[18].ryk05,g_ryk[19].ryk05,g_ryk[20].ryk05,
#           g_ryk[24].ryk05,g_ryk[25].ryk05,g_ryk[26].ryk05,g_ryk[27].ryk05,g_ryk[28].ryk05,
#           g_ryk[29].ryk05,g_ryk[30].ryk05,g_ryk[31].ryk05,g_ryk[32].ryk05,g_ryk[33].ryk05,
#           g_ryk[41].ryk05,                      #TQC-B20166 add
#           g_ryk[45].ryk05
#        TO pchoice1,pchoice2,pchoice3,pchoice4,  #TQC-AC0206 add
#           ryk051,ryk052,ryk053,ryk055,ryk057,
#           ryk0510,ryk0511,ryk0512,ryk0514,
#           ryk0515,ryk0516,ryk0518,ryk0519,ryk0520,
#           ryk0524,ryk0525,ryk0526,ryk0527,ryk0528,
#           ryk0529,ryk0530,ryk0531,ryk0532,ryk0533,
#           ryk0541,                              #TQC-B20166 add
#           ryk0545
   DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,   
                  g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
#                 g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,       #FUN-C50017 MARK
                  g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,            #FUN-C50017 add
#                 g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,       #FUN-C50017 MARK
#                 g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,       #FUN-B90049 mark
#                 g_ryk[201].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,                        #FUN-B90049 add    #FUN-C50017 MARK
#                 g_ryk[110].ryk05,g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,       #FUN-C50017 add    #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 mark
                  g_ryk[110].ryk05,g_ryk[111].ryk05,                                         #FUN-CC0116 add
                  g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,       #FUN-CC0116 add
#                 g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,g_ryk[208].ryk05,       #FUN-C50017 MARK
                  g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,                        #FUN-C50017 add  #FUN-D20020 add g_ryk[207].ryk05,
                  g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
                  g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05        #FUN-C50017 add g_ryk[404].ryk05    
                  ,g_ryk[405].ryk05,g_ryk[406].ryk05                                         #FUN-CB0007 add
          TO pchoice1,pchoice2,pchoice3,pchoice4,  
             ryk05101,ryk05102,ryk05103,ryk05104,
#            ryk05105,ryk05106,ryk05107,ryk05108,                                            #FUN-C50017 MARK
             ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,                                   #FUN-C50017 add
#            ryk05109,ryk05110,ryk05111,ryk05112,                                            #FUN-C50017 MARK
#            ryk05201,ryk05202,ryk05203,ryk05204,                                            #FUN-B90049 mark
             ryk05110,ryk05111,ryk05201,ryk05202,ryk05203,ryk05204,                          #FUN-B90049 add  #FUN-C50017 add ryk05202  #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111
#            ryk05205,ryk05206,ryk05207,ryk05208,                                            #FUN-C50017 mark
             ryk05205,ryk05206,ryk05207,                                                     #FUN-C50017 add  #FUN-D20020 add ryk05207
             ryk05301,ryk05302,ryk05303,
             ryk05401,ryk05402,ryk05403,ryk05404                                             #FUN-C50017 add ryk05404   
             ,ryk05405,ryk05406                                                              #FUN-CB0007 add        
#   INPUT g_choice1,   #TQC-AC0206 add
#         g_ryk[5].ryk05,g_ryk[18].ryk05,g_ryk[20].ryk05,g_ryk[24].ryk05,g_ryk[19].ryk05,g_ryk[25].ryk05,
#         g_ryk[29].ryk05,g_ryk[31].ryk05,g_ryk[1].ryk05,g_ryk[2].ryk05,g_ryk[3].ryk05,
#         g_ryk[41].ryk05,  #TQC-B20166 add
#         g_choice2,   #TQC-AC0206 add
#         g_ryk[10].ryk05,g_ryk[11].ryk05,g_ryk[12].ryk05,g_ryk[28].ryk05,g_ryk[7].ryk05,
#         g_ryk[26].ryk05,g_ryk[27].ryk05,g_ryk[30].ryk05,
#         g_choice3,   #TQC-AC0206 add
#         g_ryk[14].ryk05,g_ryk[15].ryk05,g_ryk[16].ryk05,
#         g_choice4,   #TQC-AC0206 add
#         g_ryk[32].ryk05,g_ryk[33].ryk05,g_ryk[45].ryk05   
#         WITHOUT DEFAULTS
#   FROM  pchoice1,    #TQC-AC0206 add
#         ryk055,ryk0518,ryk0520,ryk0524,ryk0519,ryk0525,
#         ryk0529,ryk0531,ryk051,ryk052,ryk053,
#         ryk0541,     #TQC-B20166 add
#         pchoice2,    #TQC-AC0206 add
#         ryk0510,ryk0511,ryk0512,ryk0528,ryk057,
#         ryk0526,ryk0527,ryk0530,
#         pchoice3,    #TQC-AC0206 add
#         ryk0514,ryk0515,ryk0516,
#         pchoice4,    #TQC-AC0206 add
#         ryk0532,ryk0533,ryk0545
      INPUT g_choice1,   #TQC-AC0206 add
         g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,g_ryk[105].ryk05,g_ryk[106].ryk05,
         g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,                       #FUN-C50017 add   #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 add g_ryk[111].ryk05 
#        g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,      #FUN-C50017 mark
         g_choice2,   
#        g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,   #FUN-B90049 mark
         g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,  #FUN-C50017 add #FUN-D20020 add g_ryk[207].ryk05
#        g_ryk[201].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,g_ryk[205].ryk05,                    #FUN-B90049 add     #FUN-C50017 mark
#        g_ryk[206].ryk05,g_ryk[207].ryk05,g_ryk[208].ryk05,                                                         #FUN-C50017 mark
         g_choice3,  
         g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
         g_choice4,  
         g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05                                          #FUN-C50017 add g_ryk[404].ryk05 
         ,g_ryk[405].ryk05,g_ryk[406].ryk05                                                                           #FUN-CB0007 add
         WITHOUT DEFAULTS
   FROM  pchoice1,  
         ryk05101,ryk05102,ryk05103,ryk05104,ryk05105,ryk05106,
#        ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,ryk05112,                                  #FUN-C50017 mark
         ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,                                           #FUN-C50017 add  #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111
         pchoice2,   
#        ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,                                           #FUN-B90049 mark 
         ryk05201,ryk05202,ryk05203,ryk05204,ryk05205,ryk05206,ryk05207,                         #FUN-C50017 add  #FUN-D20020 add ryk05207
#        ryk05201,ryk05203,ryk05204,ryk05205,                                                    #FUN-B90049 add #FUN-C50017 mark 
#        ryk05206,ryk05207,ryk05208,                                                             #FUN-C50017 mark
         pchoice3,    
         ryk05301,ryk05302,ryk05303,
         pchoice4,   
         ryk05401,ryk05402,ryk05403,ryk05404                                                     #FUN-C50017 add ryk05404            
         ,ryk05405,ryk05406                                                                      #FUN-CB0007 add   
       
       BEFORE INPUT                              #TQC-AC0206 add
          CALL p030_set_entry(p_cmd)             #TQC-AC0206 add
#         CALL p030_set_no_entry(p_cmd)          #TQC-AC0206 add     #FUN-C50017 MARK 
   
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
#FUN-C50017 add begin ---
          #CALL i030_chk_choice('0','1',101,109)     #FUN-CA0074 mark
          #CALL i030_chk_choice('0','1',101,110)     #FUN-CA0074 add   #FUN-CC0116 mark
          CALL i030_chk_choice('0','1',101,111)      #FUN-CC0116 add
         #CALL i030_chk_choice('0','2',201,206)      #FUN-D20020 mark
          CALL i030_chk_choice('0','2',201,207)      #FUN-D20020 add
          CALL i030_chk_choice('0','3',301,303)
          #CALL i030_chk_choice('0','4',401,404)     #FUN-CB0007 mark
          CALL i030_chk_choice('0','4',401,406)      #FUN-CB0007 add
#FUN-C50017 add end -----
           
#FUN-C50017 MARK BEGIN ---
#TQC-AC0206 add begin------------------------------------
#      ON CHANGE pchoice1
#         CALL p030_choice1(p_cmd)
#         
#      AFTER FIELD pchoice1
#         CALL p030_choice1(p_cmd)
#         
#      ON CHANGE pchoice2
#         CALL p030_choice2(p_cmd)
#   
#      AFTER FIELD pchoice2
#         CALL p030_choice2(p_cmd)
#
#      ON CHANGE pchoice3
#         CALL p030_choice3(p_cmd)
#   
#      AFTER FIELD pchoice3
#         CALL p030_choice3(p_cmd)
#           
#      ON CHANGE pchoice4
#         CALL p030_choice4(p_cmd)
#   
#      AFTER FIELD pchoice4
#         CALL p030_choice4(p_cmd)
#TQC-AC0206 add end--------------------------------------
#FUN-C50017 MARK END ----
#FUN-C50017 add begin ---
      ON CHANGE pchoice1
         #CALL i030_chk_choice('1','1',101,109)      #FUN-CA0074 mark
         #CALL i030_chk_choice('1','1',101,110)      #FUN-CA0074 add   #FUN-CC0116 mark
         CALL i030_chk_choice('1','1',101,111)       #FUN-CC0116 add
         CALL i030_fill()

      ON CHANGE pchoice2
        #CALL i030_chk_choice('1','2',201,206)       #FUN-D20020 mark
         CALL i030_chk_choice('1','2',201,207)       #FUN-D20020 add
         CALL i030_fill()

      ON CHANGE pchoice3
         CALL i030_chk_choice('1','3',301,303)
         CALL i030_fill()

      ON CHANGE pchoice4
         #CALL i030_chk_choice('1','4',401,404)      #FUN-CB0007 mark
         CALL i030_chk_choice('1','4',401,406)       #FUN-CB0007 add
         CALL i030_fill()

#FUN-C50017 add end -----

       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about       
          CALL cl_about()     
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controls                    
          CALL cl_set_head_visible("","AUTO")  
          
       #MOD-AC0225 add ----------------begin----------------------   
       ON ACTION selectall 
          CALL i030_yn('Y')          #FUN-C50017 add
#FUN-C50017 mark begin ---
#         LET g_choice1= 'Y'
#         CALL p030_choice1(p_cmd)
#         LET g_choice2= 'Y'
#         CALL p030_choice2(p_cmd)
#         LET g_choice3= 'Y'
#         CALL p030_choice3(p_cmd)
#         LET g_choice4= 'Y'
#         CALL p030_choice4(p_cmd)
#FUN-C50017 mark end ----

       ON ACTION cancelall
          CALL i030_yn('N')          #FUN-C50017 add
#         LET g_choice1= 'N'         #FUN-C50017 mark
#FUN-B70011 ---------------STA          
#          LET g_ryk[5].ryk05='N'
#          LET g_ryk[18].ryk05='N'
#          LET g_ryk[20].ryk05='N'
#          LET g_ryk[24].ryk05='N'
#          LET g_ryk[19].ryk05='N'
#          LET g_ryk[25].ryk05='N'
#          LET g_ryk[29].ryk05='N'
#          LET g_ryk[31].ryk05='N'
#          LET g_ryk[1].ryk05='N'
#          LET g_ryk[2].ryk05='N'
#          LET g_ryk[3].ryk05='N'
#          LET g_ryk[41].ryk05='N'  #TQC-B20166 add
#          LET g_choice2= 'N'
#          LET g_ryk[10].ryk05='N'
#          LET g_ryk[11].ryk05='N'
#          LET g_ryk[12].ryk05='N'
#          LET g_ryk[28].ryk05='N'
#          LET g_ryk[7].ryk05='N'
#          LET g_ryk[26].ryk05='N'
#          LET g_ryk[27].ryk05='N'
#          LET g_ryk[30].ryk05='N'
#          LET g_choice3= 'N'
#          LET g_ryk[14].ryk05='N'
#          LET g_ryk[15].ryk05='N'
#          LET g_ryk[16].ryk05='N'
#          LET g_choice4= 'N' 
#          LET g_ryk[32].ryk05='N'
#          LET g_ryk[33].ryk05='N'
#          LET g_ryk[45].ryk05='N'
#FUN-C50017 mark begin ---
#          LET g_ryk[101].ryk05='N'
#          LET g_ryk[102].ryk05='N'
#          LET g_ryk[103].ryk05='N'
#          LET g_ryk[104].ryk05='N'
#          LET g_ryk[105].ryk05='N'
#          LET g_ryk[106].ryk05='N'
#          LET g_ryk[107].ryk05='N'
#          LET g_ryk[108].ryk05='N'
#          LET g_ryk[109].ryk05='N'
#          LET g_ryk[110].ryk05='N'
#          LET g_ryk[111].ryk05='N'
#          LET g_ryk[112].ryk05='N' 
#          LET g_choice2= 'N'
#          LET g_ryk[201].ryk05='N'
##         LET g_ryk[202].ryk05='N'             #FUN-B90049 mark
#          LET g_ryk[203].ryk05='N'
#          LET g_ryk[204].ryk05='N'
#          LET g_ryk[205].ryk05='N'
#          LET g_ryk[206].ryk05='N'
#          LET g_ryk[207].ryk05='N'
#          LET g_ryk[208].ryk05='N'
#          LET g_choice3= 'N'
#          LET g_ryk[301].ryk05='N'
#          LET g_ryk[302].ryk05='N'
#          LET g_ryk[303].ryk05='N'
#          LET g_choice4= 'N' 
#          LET g_ryk[401].ryk05='N'
#          LET g_ryk[402].ryk05='N'
#          LET g_ryk[403].ryk05='N'
#FUN-C50017 mark  end -----
#          DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,   
#                  g_ryk[1].ryk05,g_ryk[2].ryk05,g_ryk[3].ryk05,g_ryk[5].ryk05,g_ryk[7].ryk05,
#                  g_ryk[10].ryk05,g_ryk[11].ryk05,g_ryk[12].ryk05,g_ryk[14].ryk05,
#                  g_ryk[15].ryk05,g_ryk[16].ryk05,g_ryk[18].ryk05,g_ryk[19].ryk05,g_ryk[20].ryk05,
#                  g_ryk[24].ryk05,g_ryk[25].ryk05,g_ryk[26].ryk05,g_ryk[27].ryk05,g_ryk[28].ryk05,
#                  g_ryk[29].ryk05,g_ryk[30].ryk05,g_ryk[31].ryk05,g_ryk[32].ryk05,g_ryk[33].ryk05,
#                  g_ryk[41].ryk05, #TQC-B20166 add
#                  g_ryk[45].ryk05
#          TO pchoice1,pchoice2,pchoice3,pchoice4,  
#             ryk051,ryk052,ryk053,ryk055,ryk057,
#             ryk0510,ryk0511,ryk0512,ryk0514,
#             ryk0515,ryk0516,ryk0518,ryk0519,ryk0520,
#             ryk0524,ryk0525,ryk0526,ryk0527,ryk0528,
#             ryk0529,ryk0530,ryk0531,ryk0532,ryk0533,
#             ryk0541,   #TQC-B20166 add
#             ryk0545
         DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,   
                  g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
                  g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,
                  g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,                          #FUN-B90049 add   #FUN-CA0074 add g_ryk[110].ryk05  #FUN-CC0116 add g_ryk[111].ryk05
#                 g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,         #FUN-B90049 mark
#                 g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,         #FUN-B90049 mark
#                 g_ryk[201].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,                          #FUN-B90049 add   #FUN-D20020 mark
#                 g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,g_ryk[208].ryk05,         #FUN-D20020 mark
                  g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,                          #FUN-D20020 add
                  g_ryk[204].ryk05,g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,         #FUN-D20020 add
                  g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
                  g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05
                  ,g_ryk[405].ryk05,g_ryk[406].ryk05                                           #FUN-CB0007 add
          TO pchoice1,pchoice2,pchoice3,pchoice4,  
             ryk05101,ryk05102,ryk05103,ryk05104,
             ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,                   #FUN-B90049 add   #FUN-CA0074 add ryk05110  #FUN-CC0116 add ryk05111
#            ryk05109,ryk05110,ryk05111,ryk05112,                                              #FUN-B90049 mark
#            ryk05201,ryk05202,ryk05203,ryk05204,                                              #FUN-B90049 mark
#            ryk05201,ryk05203,ryk05204,                                                       #FUN-B90049 add   #FUN-D20020 mark
#            ryk05205,ryk05206,ryk05207,ryk05208,                                              #FUN-D20020 mark
             ryk05201,ryk05202,ryk05203,                                                       #FUN-D20020 add
             ryk05204,ryk05205,ryk05206,ryk05207,                                              #FUN-D20020 add
             ryk05301,ryk05302,ryk05303,
             ryk05401,ryk05402,ryk05403,ryk05404
             ,ryk05405,ryk05406                                                                #FUN-CB0007 add
#FUN-B70011 -----------------END
#FUN-C50017 mark begin ---
#          CALL p030_set_entry(p_cmd)       
#          CALL p030_set_no_entry(p_cmd)                 
#FUN-C50017 mark end ---
      #MOD-AC0225 add ----------------begin----------------------
   END INPUT
   
END FUNCTION

FUNCTION i030_show(p_wc2)
DEFINE   p_wc2       STRING 
DEFINE   l_i       STRING
DEFINE  l_ryk   RECORD 
                ryk01       LIKE ryk_file.ryk01,
                ryk05       LIKE type_file.chr1
                END RECORD    
   LET g_sql = "SELECT ryk01,ryk05 FROM ryk_file WHERE ",p_wc2," ORDER BY ryk01"
   PREPARE i030_ryk05 FROM g_sql
   DECLARE ryk_cs CURSOR FOR i030_ryk05
  
   CALL g_ryk.clear()

   FOREACH ryk_cs INTO l_ryk.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
      LET g_ryk[l_ryk.ryk01].* = l_ryk.*
      LET g_ryk_o[l_ryk.ryk01].* = g_ryk[l_ryk.ryk01].*
   END FOREACH
#FUN-C50017 add begin ---
   #CALL i030_chk_choice('0','1',101,109) #组归类变量赋值   #FUN-CA0074 mark
   #CALL i030_chk_choice('0','1',101,110) #组归类变量赋值   #FUN-CA0074 add   #FUN-CC0116 mark
   CALL i030_chk_choice('0','1',101,111) #组归类变量赋值    #FUN-CC0116 add
  #CALL i030_chk_choice('0','2',201,206) #组归类变量赋值    #FUN-D20020 mark
   CALL i030_chk_choice('0','2',201,207) #组归类变量赋值    #FUN-D20020 add
   CALL i030_chk_choice('0','3',301,303) #组归类变量赋值
   #CALL i030_chk_choice('0','4',401,404) #组归类变量赋值   #FUN-CB0007 mark
   CALL i030_chk_choice('0','4',401,406)  #组归类变量赋值   #FUN-CB0007 add
#FUN-C50017 add end -----   
#FUN-C50017 mark begin ---
#  #TQC-AC0206 add begin------------------------------------
#  LET g_choice1= 'Y' 
#  LET g_choice2= 'Y' 
#  LET g_choice3= 'Y' 
#  LET g_choice4= 'Y' 
#  CALL p030_chk_choice1()
#  CALL p030_chk_choice2()
#  CALL p030_chk_choice3()
#  CALL p030_chk_choice4()
#  #TQC-AC0206 add end--------------------------------------
#FUN-C50017 mark end ----
#   DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,   #TQC-AC0206 add
#           g_ryk[1].ryk05,g_ryk[2].ryk05,g_ryk[3].ryk05,g_ryk[5].ryk05,g_ryk[7].ryk05,
#           g_ryk[10].ryk05,g_ryk[11].ryk05,g_ryk[12].ryk05,g_ryk[14].ryk05,
#           g_ryk[15].ryk05,g_ryk[16].ryk05,g_ryk[18].ryk05,g_ryk[19].ryk05,g_ryk[20].ryk05,
#           g_ryk[24].ryk05,g_ryk[25].ryk05,g_ryk[26].ryk05,g_ryk[27].ryk05,g_ryk[28].ryk05,
#           g_ryk[29].ryk05,g_ryk[30].ryk05,g_ryk[31].ryk05,g_ryk[32].ryk05,g_ryk[33].ryk05,
#           g_ryk[41].ryk05, #TQC-B20166 add
#           g_ryk[45].ryk05
#        TO pchoice1,pchoice2,pchoice3,pchoice4,  #TQC-AC0206 add
#           ryk051,ryk052,ryk053,ryk055,ryk057,
#           ryk0510,ryk0511,ryk0512,ryk0514,
#           ryk0515,ryk0516,ryk0518,ryk0519,ryk0520,
#           ryk0524,ryk0525,ryk0526,ryk0527,ryk0528,
#           ryk0529,ryk0530,ryk0531,ryk0532,ryk0533,
#           ryk0541,   #TQC-B20166 add
#           ryk0545
#FUN-C50017 mark begin ---
#    DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,   
#                  g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
#                  g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,
#                  g_ryk[109].ryk05,g_ryk[110].ryk05,g_ryk[111].ryk05,g_ryk[112].ryk05,
##                 g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,       #FUN-B90049 mark
#                  g_ryk[201].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,                        #FUN-B90049 add
#                  g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,g_ryk[208].ryk05,
#                  g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
#                  g_ryk[401].ryk05,g_ryk[402].ryk05, g_ryk[403].ryk05
#          TO pchoice1,pchoice2,pchoice3,pchoice4,  
#             ryk05101,ryk05102,ryk05103,ryk05104,
#             ryk05105,ryk05106,ryk05107,ryk05108,
#             ryk05109,ryk05110,ryk05111,ryk05112,
##            ryk05201,ryk05202,ryk05203,ryk05204,                                            #FUN-B90049 mark
#             ryk05201,ryk05203,ryk05204,                                                     #FUN-B90049 add
#             ryk05205,ryk05206,ryk05207,ryk05208,
#             ryk05301,ryk05302,ryk05303,
#             ryk05401,ryk05402,ryk05403
#FUN-C50017 mark end ---
#FUN-C50017 add begin ---
    DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,
                  g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
                  g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,   #FUN-CA0074 add g_ryk[110].ryk05
                  g_ryk[111].ryk05,                                                           #FUN-CC0116 add
                  g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05, 
                  g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,                   #FUN-D20020 add g_ryk[207].ryk05
                  g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
                  g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05
                  ,g_ryk[405].ryk05,g_ryk[406].ryk05                         #FUN-CB0007 add
          TO pchoice1,pchoice2,pchoice3,pchoice4,
             ryk05101,ryk05102,ryk05103,ryk05104,
             ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,        #FUN-CA0074 add ryk05110    #FUN-CC0116 addryk05111
             ryk05201,ryk05202,ryk05203,ryk05204,
             ryk05205,ryk05206,ryk05207,                                     #FUN-D20020 add ryk05207
             ryk05301,ryk05302,ryk05303,
             ryk05401,ryk05402,ryk05403,ryk05404
             ,ryk05405,ryk05406                                              #FUN-CB0007 add
#FUN-C40017 add end ---
END FUNCTION
#add by suncx FUN-A90033 end------------
 
#FUN-C50017 add begin ---
FUNCTION i030_yn(p_y)
DEFINE i     LIKE type_file.num5
DEFINE p_y   LIKE type_file.chr1
     FOR i=1 TO g_ryk.getLength()
        LET g_ryk[i].ryk05= p_y
     END FOR
     LET g_choice1= p_y
     LET g_choice2= p_y
     LET g_choice3= p_y
     LET g_choice4= p_y
     CALL i030_fill()
END FUNCTION

FUNCTION i030_fill()
    DISPLAY g_choice1,g_choice2,g_choice3,g_choice4,
                  g_ryk[101].ryk05,g_ryk[102].ryk05,g_ryk[103].ryk05,g_ryk[104].ryk05,
                  g_ryk[105].ryk05,g_ryk[106].ryk05,g_ryk[107].ryk05,g_ryk[108].ryk05,g_ryk[109].ryk05,g_ryk[110].ryk05,    #FUN-CA0074 add g_ryk[110].ryk05
                  g_ryk[111].ryk05,                                                         #FUN-CC0116 add
                  g_ryk[201].ryk05,g_ryk[202].ryk05,g_ryk[203].ryk05,g_ryk[204].ryk05,     
                  g_ryk[205].ryk05,g_ryk[206].ryk05,g_ryk[207].ryk05,                       #FUN-D20020 add g_ryk[207].ryk05
                  g_ryk[301].ryk05,g_ryk[302].ryk05,g_ryk[303].ryk05,
                  g_ryk[401].ryk05,g_ryk[402].ryk05,g_ryk[403].ryk05,g_ryk[404].ryk05
                  ,g_ryk[405].ryk05,g_ryk[406].ryk05                       #FUN-CB0007 add
          TO pchoice1,pchoice2,pchoice3,pchoice4,
             ryk05101,ryk05102,ryk05103,ryk05104,
             ryk05105,ryk05106,ryk05107,ryk05108,ryk05109,ryk05110,ryk05111,        #FUN-CA0074 add ryk05110   #FUN-CC0116 add ryk05111
             ryk05201,ryk05202,ryk05203,ryk05204,          
             ryk05205,ryk05206,ryk05207,                                   #FUN-D20020 add ryk05207
             ryk05301,ryk05302,ryk05303,
             ryk05401,ryk05402,ryk05403,ryk05404
             ,ryk05405,ryk05406                                            #FUN-CB0007 add
END FUNCTION
#FUN-C50017 add end -----

#mark by suncx FUN-A90033 begin------------ 
#FUNCTION i030_b_fill(p_wc2)              
#DEFINE   p_wc2       STRING        
#
#    LET g_sql = "SELECT ryk05,ryk01,ryk02,ryk03,ryk04 FROM ryk_file ",
#                " WHERE ",p_wc2 CLIPPED
#                
#    IF NOT cl_null(p_wc2) THEN
#      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
#    END IF
#    LET g_sql = g_sql CLIPPED,"ORDER BY ryk02 " 
#    PREPARE i030_pb FROM g_sql
#    DECLARE ryk_cs CURSOR FOR i030_pb
# 
#    CALL g_ryk.clear()
#    LET g_cnt = 1
#    MESSAGE "Searching!"
#    FOREACH ryk_cs INTO g_ryk[g_cnt].*  
#        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
#        EXIT FOREACH
#        END IF
#        LET g_cnt = g_cnt + 1
#        IF g_cnt > g_max_rec THEN
#           CALL cl_err( '', 9035, 0 )
#           EXIT FOREACH
#        END IF
#    END FOREACH
# 
#    CALL g_ryk.deleteElement(g_cnt)
#    MESSAGE ""
#    LET g_rec_b = g_cnt-1
#    LET g_cnt = 0
#        
#END FUNCTION
#
#FUNCTION i030_b()
#        DEFINE l_ac_t LIKE type_file.num5,
#                l_n     LIKE type_file.num5,
#                l_lock_sw       LIKE type_file.chr1,
#                p_cmd   LIKE type_file.chr1
#                
#        LET g_action_choice=""
#        IF s_shut(0) THEN 
#                RETURN
#        END IF
# 
#        CALL cl_opmsg('b')
#        
#        LET g_forupd_sql="SELECT ryk05,ryk01,ryk02,ryk03,ryk04",
#                        " FROM ryk_file",
#                        " WHERE ryk01=?",
#                        " FOR UPDATE "
#        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#        DECLARE i030_bcl CURSOR FROM g_forupd_sql
#        
#        
#        INPUT ARRAY g_ryk WITHOUT DEFAULTS FROM s_ryk.*
#                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                        INSERT ROW=FALSE,DELETE ROW=FALSE,
#                        APPEND ROW=FALSE)
#        BEFORE INPUT
#                
#                IF g_rec_b !=0 THEN 
#                   CALL fgl_set_arr_curr(l_ac)
#                   CALL cl_set_comp_entry("ryk02,ryk03,ryk04",FALSE)
#                END IF
#        BEFORE ROW
#                LET l_ac =ARR_CURR()
#                LET l_lock_sw ='N'
#                LET l_n =ARR_COUNT()
#                
#                BEGIN WORK 
#                            
#                IF g_rec_b>=l_ac THEN 
#                        LET g_ryk_t.*=g_ryk[l_ac].*
#                        
#                        LET g_before_input_done = FALSE                                                                                      
#                        LET g_before_input_done = TRUE
#                        
#                        OPEN i030_bcl USING g_ryk_t.ryk01
#                        IF STATUS THEN
#                                CALL cl_err("OPEN i030_bcl:",STATUS,1)
#                                LET l_lock_sw='Y'
#                        ELSE
#                                FETCH i030_bcl INTO g_ryk[l_ac].*
#                                IF SQLCA.sqlcode THEN
#                                        CALL cl_err(g_ryk_t.ryk01,SQLCA.sqlcode,1)
#                                        LET l_lock_sw="Y"
#                                END IF
#                        END IF
#              END IF
# 
#        ON ROW CHANGE
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_ryk[l_ac].* = g_ryk_t.*
#              CLOSE i030_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_ryk[l_ac].ryk02,-263,1)
#              LET g_ryk[l_ac].* = g_ryk_t.*
#           ELSE
#             
#              UPDATE ryk_file SET ryk05 = g_ryk[l_ac].ryk05
#                 WHERE ryk01=g_ryk_t.ryk01
#              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                 CALL cl_err3("upd","ryk_file",g_ryk_t.ryk01,g_ryk_t.ryk02,SQLCA.sqlcode,"","",1) 
#                 LET g_ryk[l_ac].* = g_ryk_t.*
#              ELSE
#                 MESSAGE 'UPDATE O.K'
#                 COMMIT WORK
#              END IF
#           END IF
# 
#        AFTER ROW
#           DISPLAY  "AFTER ROW!!"
#           LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac
# 
#           IF INT_FLAG THEN
#              CALL cl_err('',9001,0)
#              LET INT_FLAG = 0
#              LET g_ryk[l_ac].* = g_ryk_t.*
#              CLOSE i030_bcl
#              ROLLBACK WORK
#              EXIT INPUT
#           END IF
#           CLOSE i030_bcl
#           COMMIT WORK
# 
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
# 
#        ON ACTION CONTROLF
#           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#        ON ACTION about       
#           CALL cl_about()     
# 
#        ON ACTION help          
#           CALL cl_show_help()  
# 
#        ON ACTION controls                    
#           CALL cl_set_head_visible("","AUTO")  
#    END INPUT
#  
#    CLOSE i030_bcl
#    COMMIT WORK
#    
#END FUNCTION 
#mark by suncx FUN-A90033 end------------                          
                                                   
FUNCTION i030_bp_refresh()
 
  DISPLAY ARRAY g_ryk TO s_ryk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION i030_out()                                                     
DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "apci030" "',g_wc2 CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
    
END FUNCTION           

#No.FUN-A60066 ..begin
FUNCTION i030_reset()
   IF NOT cl_confirm('abx-080') THEN RETURN END IF
   BEGIN WORK
   DELETE FROM ryk_file
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ryk_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   #TQC-AC0206 add begin---------
   LET g_choice1= 'Y'
   LET g_choice2= 'Y'
   LET g_choice3= 'Y'
   LET g_choice4= 'Y'
   DISPLAY BY NAME g_choice1,g_choice2,g_choice3,g_choice4
   #TQC-AC0206 add end-----------
   CALL i030_insert()
   #CALL i030_b_fill(" 1=1")
      
END FUNCTION           
#No.FUN-A60066 ..end

FUNCTION i030_insert()
DEFINE l_count  LIKE type_file.num5
DEFINE l_string LIKE ze_file.ze03  #FUN-BC0015 add     
    SELECT COUNT(*) INTO l_count FROM ryk_file 
    IF l_count > 0 THEN RETURN END IF   #No.FUN-A60066

     #預設值
#門店基本資料
     INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 5,UPPER(gat01),'POSAL',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='rtz_file' AND gat02=g_lang
#      SELECT 5,UPPER(zta01),'POSAL',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#      SELECT 101,UPPER(zta01),'POSAL',COALESCE(gat03,' '),'Y'  #FUN-B70011  add   #FUN-C50017 mark
       SELECT 101,UPPER(zta01),'ta_ShopInfo',COALESCE(gat03,' '),'Y'               #FUN-C50017 add 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'rtz_file' 
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    
#FUN-C50017 add begin ---
#门店权限资料
     INSERT INTO ryk_file
       SELECT 102,UPPER(zta01),'th_Role',COALESCE(gat03,' '),'Y'
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'ryr_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add end ---
#POS使用者資料
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 22,UPPER(gat01),'POSCA',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='ryi_file' AND gat02=g_lang
#      SELECT 18,UPPER(zta01),'POSCA',COALESCE(gat03,' '),'Y'        #FUN-B70011  mark
#     SELECT 102,UPPER(zta01),'POSCA',COALESCE(gat03,' '),'Y'        #FUN-B70011  add  #FUN-C50017 mark
      SELECT 103,UPPER(zta01),'th_Staffs',COALESCE(gat03,' '),'Y'        #FUN-C50017 add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'ryi_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 mark begin ---
##POS授權碼資料    
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 24,UPPER(gat01),'POSCC',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='occ_file' AND gat02=g_lang
##      SELECT 20,UPPER(zta01),'POSCD',COALESCE(gat03,' '),'Y'      #FUN-B70011  mark
#      SELECT 103,UPPER(zta01),'POSCD',COALESCE(gat03,' '),'Y'       #FUN-B70011  add 
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'ryw_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF  
##客戶資料    
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 23,UPPER(gat01),'POSCB',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='lpj_file' AND gat02=g_lang
##      SELECT 19,UPPER(zta01),'POSCC',COALESCE(gat03,' '),'Y'       #FUN-B70011  mark
#       SELECT 104,UPPER(zta01),'POSCC',COALESCE(gat03,' '),'Y'       #FUN-B70011  add
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'occ_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
##發票資料    
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 31,UPPER(gat01),'POSZF',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='ryv_file' AND gat02=g_lang
##      SELECT 25,UPPER(zta01),'POSANC',COALESCE(gat03,' '),'Y'  #FUN-B70011  mark  
#      SELECT 105,UPPER(zta01),'POSANC',COALESCE(gat03,' '),'Y'  #FUN-B70011  add
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'oom_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
##稅別資料    
#    INSERT INTO ryk_file
##      SELECT 29,UPPER(zta01),'POSANB',COALESCE(gat03,' '),'Y'   #FUN-B70011  mark
#     SELECT 106,UPPER(zta01),'POSANB',COALESCE(gat03,' '),'Y'     #FUN-B70011  add
#       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'gec_file'
#         AND zta02 = g_dbs
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#FUN-C50017 MARK end ---
#商戶攤位資料    
     INSERT INTO ryk_file
#     SELECT 31,UPPER(zta01),'POSBOA',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#     SELECT 107,UPPER(zta01),'POSBOA',COALESCE(gat03,' '),'Y'   #FUN-B70011  add   #FUN-C50017 MARK
      SELECT 104,UPPER(zta01),'tb_Counter',COALESCE(gat03,' '),'Y'   #FUN-C50017 add
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lnt_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF  

#FUN-C50017 MARK begin ---
#券類型維護檔    
#    INSERT INTO ryk_file 
#     #FUN-A70084--mod--str--
#     #SELECT 1,UPPER(gat01),'POSAD',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='rxw_file' AND gat02=g_lang
#
##     SELECT 1,UPPER(zta01),'POSAD',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#      SELECT 108,UPPER(zta01),'POSAD',COALESCE(gat03,' '),'Y'  #FUN-B70011  add 
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01='lpx_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#FUN-C50017 MARK end ---
#FUN-C50017 add begin ---
#款别资料
    INSERT INTO ryk_file
      SELECT 105,UPPER(zta01),'ta_Payment',COALESCE(gat03,' '),'Y' 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'ryd_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#券种资料
    INSERT INTO ryk_file
      SELECT 106,UPPER(zta01),'ta_Coupon',COALESCE(gat03,' '),'Y' 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lpx_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add end ----
#聯盟卡種資料    
    INSERT INTO ryk_file
     #FUN-A70084--mod--str-
     #SELECT 2,UPPER(gat01),'POSAD',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='lpx_file' AND gat02=g_lang
#     SELECT 2,UPPER(zta01),'POSAD',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#     SELECT 109,UPPER(zta01),'POSAD',COALESCE(gat03,' '),'Y'  #FUN-B70011  add   #FUN-C50017 mark 
      SELECT 107,UPPER(zta01),'ta_ExpenseCard',COALESCE(gat03,' '),'Y'  #FUN-C50017 add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'rxw_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF

#FUN-C50017 add begin ---
#發票簿資料
    INSERT INTO ryk_file
      SELECT 108,UPPER(zta01),'ta_InvoiceBook',COALESCE(gat03,' '),'Y' 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'oom_file'
         AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","oom_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF

#稅別資料
    INSERT INTO ryk_file
      SELECT 109,UPPER(zta01),'tb_TaxCategory',COALESCE(gat03,' '),'Y'  
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'gec_file'
         AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","gec_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add end -----
#FUN-CA0074-----add---str
#门店参数资料
     INSERT INTO ryk_file
      SELECT 110,UPPER(zta01),'tb_BaseSet',COALESCE(gat03,' '),'Y'
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'rzc_file'
         AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","rzc_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-CA0074-----add---end
#FUN-CC0116-----add---str
#专柜抽成资料
   INSERT INTO ryk_file
   SELECT 111,UPPER(zta01),'tb_MallCode',COALESCE(gat03,' '),'Y'
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'rca_file'
         AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","rca_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF 
#FUN-CC0116-----add---end
#FUN-C50017 MARK begin ---
##公告資料
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 30,UPPER(gat01),'POSGE',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='rus_file' AND gat02=g_lang
#     #SELECT 24,UPPER(zta01),'POSZF',COALESCE(gat03,' '),'Y'   #FUN-B30164 mark#FUN-B10011 mark mark公告欄，為未選中 #TQC-B50011 MARK
#     #SELECT 24,UPPER(zta01),'POSZF',COALESCE(gat03,' '),'N'  #FUN-B30164 mark#FUN-B10011 mark mark公告欄，為未選中
##      SELECT 24,UPPER(zta01),'POSSAF',COALESCE(gat03,' '),'Y'  #TQC-B50011 ADD    #FUN-B70011  mark
#      SELECT 110,UPPER(zta01),'POSSAF',COALESCE(gat03,' '),'Y'                      #FUN-B70011  add
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'ryv_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
##卡種資料
#    #TQC-B20166 add ---begin---
#    INSERT INTO ryk_file
##      SELECT 41,UPPER(zta01),'POSLPH',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#      SELECT 111,UPPER(zta01),'POSLPH',COALESCE(gat03,' '),'Y'    #FUN-B70011  add
#       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'lph_file'
#         AND zta02 = g_dbs
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#    #TQC-B20166 add ---end---
#
##專櫃抽成資料    
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 3,UPPER(gat01),'POSAE',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='lpz_file' AND gat02=g_lang
##     SELECT 3,UPPER(zta01),'POSAE',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#      SELECT 112,UPPER(zta01),'POSBEA',COALESCE(gat03,' '),'Y'   #FUN-B70011  add
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
##       WHERE zta01 = 'lpz_file'                               #FUN-B70011  mark
#        WHERE zta01 = 'rca_file'                               #FUN-B70011  add
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF    
#FUN-C50017 MARK end ----
#產品基本資料
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 10,UPPER(gat01),'POSBA',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='rte_file' AND gat02=g_lang
#     SELECT 10,UPPER(zta01),'POSBA',COALESCE(gat03,' '),'Y'   #FUN-B70011  mark
#     SELECT 201,UPPER(zta01),'POSBA',COALESCE(gat03,' '),'Y'   #FUN-B70011  add   #FUN-C50017 mark
      SELECT 201,UPPER(zta01),'tb_Feature',COALESCE(gat03,' '),'Y'  #FUN-C50017 add 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'rte_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF  
#FUN-B90049 -----------------------STA
#產品條碼資料    
#   INSERT INTO ryk_file
#    #FUN-A70084--mod--str--
#    #SELECT 11,UPPER(gat01),'POSBB',COALESCE(gat03,' '),'Y'
#    # FROM gat_file
#    # WHERE gat01='rta_file' AND gat02=g_lang
#      SELECT 11,UPPER(zta01),'POSBB',COALESCE(gat03,' '),'Y'   #FUN-B70011  mark
#     SELECT 202,UPPER(zta01),'POSBB',COALESCE(gat03,' '),'Y'    #FUN-B70011  add
#       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#      WHERE zta01 = 'rta_file'
#        AND zta02 = g_dbs
#    #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#      CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#      RETURN
#   END IF
#FUN-B90049 -----------------------END
#FUN-C50017 add begin ---
#价格策略（自定价）
   INSERT INTO ryk_file
     SELECT 202,UPPER(zta01),'tb_Price',COALESCE(gat03,' '),'Y'   
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
      WHERE zta01 = 'rtg_file'
        AND zta02 = g_dbs
#  IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
   IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
      CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

#商戶產品資料
    INSERT INTO ryk_file
      SELECT 203,UPPER(zta01),'tb_CounterGoods',COALESCE(gat03,' '),'Y'   
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lmv_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add end -----
#FUN-C50017 mark begin ---
#產品價格資料
#    INSERT INTO ryk_file
#     #FUN-A70084--mod--str--
#     #SELECT 13,UPPER(gat01),'POSBC',COALESCE(gat03,' '),'Y'
#     # FROM gat_file
#     # WHERE gat01='rth_file' AND gat02=g_lang
#     #SELECT 12,'RTH_FILE、RTG_FILE','POSBC',COALESCE(gat03,' '),'Y'  #TQC-B10111 By shi 
##      SELECT 12,'RTG_FILE','POSBC',COALESCE(gat03,' '),'Y'            #TQC-B10111 By shi   #FUN-B70011  mark
#      SELECT 203,'RTG_FILE','POSBC',COALESCE(gat03,' '),'Y'                                  #FUN-B70011  mark
#        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'rtg_file'
#         AND zta02 = g_dbs
#     #FUN-A70084--mod--end
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#產品款號資料    
#    INSERT INTO ryk_file
##      SELECT 28,'RTE_FILE-2','POSAQ',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#      SELECT 204,'RTE_FILE-2','POSAQ',COALESCE(gat03,' '),'Y'    #FUN-B70011  add
#       FROM gat_file
#       WHERE gat01='rte_file' AND gat02=g_lang
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
##商戶產品資料    
#    INSERT INTO ryk_file
##     SELECT 30,UPPER(zta01),'POSBOB',COALESCE(gat03,' '),'Y'     #FUN-B70011  mark
#      SELECT 205,UPPER(zta01),'POSBOB',COALESCE(gat03,' '),'Y'     #FUN-B70011  add
#       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#       WHERE zta01 = 'lmv_file'
#         AND zta02 = g_dbs
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#FUN-C50017 mark end ---
#顏色資料
    INSERT INTO ryk_file
#     SELECT 26,UPPER(gat01),'POSAV',COALESCE(gat03,' '),'Y'   #FUN-B70011  mark 
#     SELECT 206,UPPER(gat01),'POSAV',COALESCE(gat03,' '),'Y'    #FUN-B70011 add    #FUN-C50017 MARK 
      SELECT 204,UPPER(gat01),'tb_Attribute1',COALESCE(gat03,' '),'Y'  #FUN-C50017 add
       FROM gat_file
       WHERE gat01='tqa_file' AND gat02=g_lang
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#尺寸資料
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 33,UPPER(gat01),'POSAV',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='tqa_file' AND gat02=g_lang
#     SELECT 27,UPPER(zta01),'POSAW',COALESCE(gat03,' '),'Y'   #FUN-B70011  mark
#     SELECT 207,UPPER(zta01),'POSAW',COALESCE(gat03,' '),'Y'  #FUN-B70011  add  #FUN-C50017 MARK
      SELECT 205,UPPER(zta01),'tb_Attribute2',COALESCE(gat03,' '),'Y'  #FUN-C50017 add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'tqa_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#單位資料
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 7,UPPER(gat01),'POSAN',COALESCE(gat03,' '),'Y'
     # FROM gat_file
     # WHERE gat01='gfe_file' AND gat02=g_lang
#     SELECT 7,UPPER(zta01),'POSAN',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#     SELECT 208,UPPER(zta01),'POSAN',COALESCE(gat03,' '),'Y'   #FUN-B70011  add  #FUN-C50017 MARK  
      SELECT 206,UPPER(zta01),'tb_Unit',COALESCE(gat03,' '),'Y'   #FUN-C50017 add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'gfe_file'
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-D20020--add--str---    
#觸屏資料
   INSERT INTO ryk_file
   SELECT 207,UPPER(zta01),'tb_Class',COALESCE(gat03,' '),'Y'
     FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
    WHERE zta01 = 'rzi_file'
      AND zta02 = g_dbs
   IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
      CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
#FUN-D20020--add--end---
    #INSERT INTO ryk_file
    # #FUN-A70084--mod--str--
    # #SELECT 12,UPPER(gat01),'POSBC',COALESCE(gat03,' '),'Y'
    # # FROM gat_file
    # # WHERE gat01='rtg_file' AND gat02=g_lang
    #  SELECT 12,UPPER(zta01),'POSBC',COALESCE(gat03,' '),'Y'
    #    FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
    #   WHERE zta01 = 'rtg_file' 
    #     AND zta02 = g_dbs
    # #FUN-A70084--mod--end
    #IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
    #   CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
    #   RETURN
    #END IF

#滿額促銷資料    
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 15,UPPER(gat01),'POSECA',COALESCE(gat03,' '),'Y'  #No.FUN-A60066 ..POSBE --> POSECA
     # FROM gat_file
     # WHERE gat01='rah_file' AND gat02=g_lang                 #No.FUN-A60066 ..rwf_file -> rah_file
#      SELECT 14,UPPER(zta01),'POSECA',COALESCE(gat03,' '),'Y'          #FUN-B70011  mark
#     SELECT 301,UPPER(zta01),'POSECA',COALESCE(gat03,' '),'Y'           #FUN-B70011  add  #FUN-C50017 MARK
      SELECT 301,UPPER(zta01),'te_Gen',COALESCE(gat03,' '),'Y'   #FUN-C50017  add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#      WHERE zta01 = 'rah_file'                                          #FUN-C50017 mark
       WHERE zta01 = 'rab_file'                                          #FUN-C50017 add
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#    INSERT INTO ryk_file
#      SELECT 16,UPPER(gat01),'POSBF',COALESCE(gat03,' '),'Y'
#       FROM gat_file
#       WHERE gat01='rwg_file' AND gat02=g_lang
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#一般促銷資料
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 17,UPPER(gat01),'POSEAA',COALESCE(gat03,' '),'Y'  #No.FUN-A60066 ..POSBG --> POSEAA
     # FROM gat_file
     # WHERE gat01='rab_file' AND gat02=g_lang                 #No.FUN-A60066 ..rwc_file -> rab_file
#      SELECT 15,UPPER(zta01),'POSEAA',COALESCE(gat03,' '),'Y'        #FUN-B70011  mark
#     SELECT 302,UPPER(zta01),'POSEAA',COALESCE(gat03,' '),'Y'        #FUN-B70011  add #FUN-C50017 mark
      SELECT 302,UPPER(zta01),'te_Comb',COALESCE(gat03,' '),'Y'                #FUN-C50017  add 
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#      WHERE zta01 = 'rab_file'                                #FUN-C50017 mark
       WHERE zta01 = 'rae_file'                                #FUN-C50017  add 
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN  #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#組合促銷作業    
    INSERT INTO ryk_file
     #FUN-A70084--mod--str--
     #SELECT 18,UPPER(gat01),'POSEBA',COALESCE(gat03,' '),'Y'  #No.FUN-A60066 ..POSBH --> POSEBA
     # FROM gat_file
     # WHERE gat01='rae_file' AND gat02=g_lang                 #No.FUN-A60066 ..rwd_file -> rae_file
#      SELECT 16,UPPER(zta01),'POSEBA',COALESCE(gat03,' '),'Y'     #FUN-B70011  mark
#     SELECT 303,UPPER(zta01),'POSEBA',COALESCE(gat03,' '),'Y'     #FUN-B70011  add  #FUN-C50017 mark
      SELECT 303,UPPER(zta01),'te_Full',COALESCE(gat03,' '),'Y'              #FUN-C50017  add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
#      WHERE zta01 = 'rae_file'                                                      #FUN-C50017 mark
       WHERE zta01 = 'rah_file'                                                      #FUN-C50017  add
         AND zta02 = g_dbs
     #FUN-A70084--mod--end
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#    INSERT INTO ryk_file
#      SELECT 19,UPPER(gat01),'POSBI',COALESCE(gat03,' '),'Y'
#       FROM gat_file
#       WHERE gat01='rwk_file' AND gat02=g_lang
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
    
#    INSERT INTO ryk_file
#      SELECT 21,UPPER(gat01),'POSBN',COALESCE(gat03,' '),'Y'
#       FROM gat_file
#       WHERE gat01='rtc_file' AND gat02=g_lang
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF

#會員基本資料
    INSERT INTO ryk_file
#      SELECT 32,UPPER(zta01),'POSLPK',COALESCE(gat03,' '),'Y'    #FUN-B70011  mark
#    SELECT 401,UPPER(zta01),'POSLPK',COALESCE(gat03,' '),'Y'      #FUN-B70011  add    #FUN-C50017 mark
     SELECT 401,UPPER(zta01),'tf_Member',COALESCE(gat03,' '),'Y'   #FUN-C50017 add
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lpk_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add begin ---
#会员卡种资料
    INSERT INTO ryk_file
#    SELECT 402,UPPER(zta01),'POSLPK',COALESCE(gat03,' '),'Y'       #FUN-C50017 mark
     SELECT 402,UPPER(zta01),'tf_CardType',COALESCE(gat03,' '),'Y'  #FUN-C50017 add
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lph_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-C50017 add end -----
#會員卡明細資料    
    INSERT INTO ryk_file
#      SELECT 33,UPPER(zta01),'POSLPJ',COALESCE(gat03,' '),'Y'     #FUN-B70011  mark
#    SELECT 402,UPPER(zta01),'POSLPJ',COALESCE(gat03,' '),'Y'       #FUN-B70011  add #FUN-C50017 mark
     SELECT 403,UPPER(zta01),'tf_CardType_Status',COALESCE(gat03,' '),'Y'                 #FUN-C50017 add
       FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lpj_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#積分/折扣規則資料    
    INSERT INTO ryk_file
#      SELECT 45,UPPER(zta01),'POSLRP',COALESCE(gat03,' '),'Y'     #FUN-B70011  mark
#      SELECT 403,UPPER(zta01),'POSLRP',COALESCE(gat03,' '),'Y'     #FUN-B70011  add  #FUN-C50017 mark
       SELECT 404,UPPER(zta01),'tf_CardType_Rule',COALESCE(gat03,' '),'Y'             #FUN-C50017 add
        FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
       WHERE zta01 = 'lrp_file'
         AND zta02 = g_dbs
#   IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN #CHI-C30115 mark
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF

#FUN-CB0007-------add----str
#会员等级资料
    INSERT INTO ryk_file
       SELECT 405,UPPER(zta01),'tf_Member_Grade',COALESCE(gat03,' '),'Y'
         FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
        WHERE zta01 = 'lpc_file'
          AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#会员类型资料
    INSERT INTO ryk_file
       SELECT 406,UPPER(zta01),'tf_Member_Type',COALESCE(gat03,' '),'Y'
         FROM zta_file LEFT OUTER JOIN gat_file ON zta01 = gat01 AND gat02=g_lang
        WHERE zta01 = 'lpc_file'
          AND zta02 = g_dbs
    IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN
       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
#FUN-CB0007-------add----end
#FUN-BC0015 add START
   #利用p_ze檔存POS Table Name 避免將名稱直接寫死
   #交易單資料檔
#FUN-C50017 mark begin ---
#    LET l_string = ' '
#    SELECT ze03 INTO l_string FROM ze_file WHERE ze01= 'apc-146' AND ze02= g_lang
#    INSERT INTO ryk_file
##       VALUES (901,'POSDA','POSDA',l_string,'Y')                 #FUN-C50017 mark
#        VALUES (901,'td_SaleHead','td_SaleHead',l_string,'Y')     #FUN-C50017 add 
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#
#   #客戶訂貨單資料檔
#    LET l_string = ' '
#    SELECT ze03 INTO l_string FROM ze_file WHERE ze01= 'apc-147' AND ze02= g_lang
#    INSERT INTO ryk_file
##       VALUES (902,'POSDG','POSDG',l_string,'Y')                 #FUN-C50017 mark
#        VALUES (902,'td_SaleHead','td_SaleHead',l_string,'Y')     #FUN-C50017 add
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#
#   #訂金退回資料
#    LET l_string = ' '
#    SELECT ze03 INTO l_string FROM ze_file WHERE ze01= 'apc-148' AND ze02= g_lang
#    INSERT INTO ryk_file
##       VALUES (903,'POSDJ','POSDJ',l_string,'Y')                 #FUN-C50017 mark
#        VALUES (903,'td_SaleHead','td_SaleHead',l_string,'Y')     #FUN-C50017 add
#    IF SQLCA.sqlcode AND SQLCA.sqlcode<>-239 THEN
#       CALL cl_err3("ins","ryk_file","","",SQLCA.sqlcode,"","",1)
#       RETURN
#    END IF
#FUN-C50017 mark end ---
#FUN-BC0015 add END

    COMMIT WORK
    CALL i030_show('1=1')
END FUNCTION

#TQC-AC0206 add begin------------------------------------
FUNCTION p030_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         

    IF g_choice1='Y' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk055",FALSE)
#      CALL cl_set_comp_entry("ryk0518",FALSE)
#      CALL cl_set_comp_entry("ryk0520",FALSE)
#      CALL cl_set_comp_entry("ryk0524",FALSE)
#      CALL cl_set_comp_entry("ryk0519",FALSE)
#      CALL cl_set_comp_entry("ryk0525",FALSE)
#      CALL cl_set_comp_entry("ryk0529",FALSE)
#      CALL cl_set_comp_entry("ryk0531",FALSE)
#      CALL cl_set_comp_entry("ryk051",FALSE)
#      CALL cl_set_comp_entry("ryk052",FALSE)
#      CALL cl_set_comp_entry("ryk053",FALSE)
#      CALL cl_set_comp_entry("ryk0541",FALSE)  #TQC-B20166 add
       CALL cl_set_comp_entry("ryk05101",FALSE)
       CALL cl_set_comp_entry("ryk05102",FALSE)
       CALL cl_set_comp_entry("ryk05103",FALSE)
       CALL cl_set_comp_entry("ryk05104",FALSE)
       CALL cl_set_comp_entry("ryk05105",FALSE)
       CALL cl_set_comp_entry("ryk05106",FALSE)
       CALL cl_set_comp_entry("ryk05107",FALSE)
       CALL cl_set_comp_entry("ryk05108",FALSE)
       CALL cl_set_comp_entry("ryk05109",FALSE)
       CALL cl_set_comp_entry("ryk05110",FALSE)
       CALL cl_set_comp_entry("ryk05111",FALSE)
       CALL cl_set_comp_entry("ryk05112",FALSE)
#FUN-B70011 ---------------END      
    END IF
    IF g_choice2='Y' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk0510",FALSE)
#      CALL cl_set_comp_entry("ryk0511",FALSE)
#      CALL cl_set_comp_entry("ryk0512",FALSE)
#      CALL cl_set_comp_entry("ryk0528",FALSE)
#      CALL cl_set_comp_entry("ryk057",FALSE)
#      CALL cl_set_comp_entry("ryk0526",FALSE)
#      CALL cl_set_comp_entry("ryk0527",FALSE) 
#      CALL cl_set_comp_entry("ryk0530",FALSE) 
       CALL cl_set_comp_entry("ryk05201",FALSE) 
#      CALL cl_set_comp_entry("ryk05202",FALSE)       #FUN-B90049 mark
       CALL cl_set_comp_entry("ryk05203",FALSE)
       CALL cl_set_comp_entry("ryk05204",FALSE)
       CALL cl_set_comp_entry("ryk05205",FALSE) 
       CALL cl_set_comp_entry("ryk05206",FALSE) 
       CALL cl_set_comp_entry("ryk05207",FALSE) 
       CALL cl_set_comp_entry("ryk05208",FALSE) 
#FUN-B70011 ---------------END
    END IF
    IF g_choice3='Y' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk0514",FALSE)
#      CALL cl_set_comp_entry("ryk0515",FALSE)
#      CALL cl_set_comp_entry("ryk0516",FALSE)
       CALL cl_set_comp_entry("ryk05301",FALSE)
       CALL cl_set_comp_entry("ryk05302",FALSE)
       CALL cl_set_comp_entry("ryk05303",FALSE)
#FUN-B70011 ---------------END
    END IF
    IF g_choice4='Y' THEN
#FUN-B70011 ---------------STA
#      CALL cl_set_comp_entry("ryk0532",FALSE)
#      CALL cl_set_comp_entry("ryk0533",FALSE)
#      CALL cl_set_comp_entry("ryk0545",FALSE)
       CALL cl_set_comp_entry("ryk05401",FALSE)
       CALL cl_set_comp_entry("ryk05402",FALSE)
       CALL cl_set_comp_entry("ryk05403",FALSE)
#FUN-B70011 ---------------END      
    END IF
END FUNCTION

FUNCTION p030_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         

    IF g_choice1='N' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk055",TRUE)
#      CALL cl_set_comp_entry("ryk0518",TRUE)
#      CALL cl_set_comp_entry("ryk0520",TRUE)
#      CALL cl_set_comp_entry("ryk0524",TRUE)
#      CALL cl_set_comp_entry("ryk0519",TRUE)
#      CALL cl_set_comp_entry("ryk0525",TRUE)
#      CALL cl_set_comp_entry("ryk0529",TRUE)
#      CALL cl_set_comp_entry("ryk0531",TRUE)
#      CALL cl_set_comp_entry("ryk051",TRUE)
#      CALL cl_set_comp_entry("ryk052",TRUE)
#      CALL cl_set_comp_entry("ryk053",TRUE)
#      CALL cl_set_comp_entry("ryk0541",TRUE)  #TQC-B20166 add
       CALL cl_set_comp_entry("ryk05101",TRUE)
       CALL cl_set_comp_entry("ryk05102",TRUE)
       CALL cl_set_comp_entry("ryk05103",TRUE)
       CALL cl_set_comp_entry("ryk05104",TRUE)
       CALL cl_set_comp_entry("ryk05105",TRUE)
       CALL cl_set_comp_entry("ryk05106",TRUE)
       CALL cl_set_comp_entry("ryk05107",TRUE)
       CALL cl_set_comp_entry("ryk05108",TRUE)
       CALL cl_set_comp_entry("ryk05109",TRUE)
       CALL cl_set_comp_entry("ryk05110",TRUE)
       CALL cl_set_comp_entry("ryk05111",TRUE)
       CALL cl_set_comp_entry("ryk05112",TRUE)
#FUN-B70011 ---------------END  
    END IF
    IF g_choice2='N' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk0510",TRUE)
#      CALL cl_set_comp_entry("ryk0511",TRUE)
#      CALL cl_set_comp_entry("ryk0512",TRUE)
#      CALL cl_set_comp_entry("ryk0528",TRUE)
#      CALL cl_set_comp_entry("ryk057",TRUE)
#      CALL cl_set_comp_entry("ryk0526",TRUE)
#      CALL cl_set_comp_entry("ryk0527",TRUE) 
#      CALL cl_set_comp_entry("ryk0530",TRUE) 
       CALL cl_set_comp_entry("ryk05201",TRUE) 
#      CALL cl_set_comp_entry("ryk05202",TRUE)          #FUN-B90049 mark
       CALL cl_set_comp_entry("ryk05203",TRUE)
       CALL cl_set_comp_entry("ryk05204",TRUE)
       CALL cl_set_comp_entry("ryk05205",TRUE) 
       CALL cl_set_comp_entry("ryk05206",TRUE) 
       CALL cl_set_comp_entry("ryk05207",TRUE) 
       CALL cl_set_comp_entry("ryk05208",TRUE) 
#FUN-B70011 ---------------END 
    END IF
    IF g_choice3='N' THEN
#FUN-B70011 ---------------STA    
#      CALL cl_set_comp_entry("ryk0514",TRUE)
#      CALL cl_set_comp_entry("ryk0515",TRUE)
#      CALL cl_set_comp_entry("ryk0516",TRUE)
       CALL cl_set_comp_entry("ryk05301",TRUE)
       CALL cl_set_comp_entry("ryk05302",TRUE)
       CALL cl_set_comp_entry("ryk05303",TRUE)
#FUN-B70011 ---------------END
    END IF
    IF g_choice4='N' THEN
#FUN-B70011 ---------------STA
#      CALL cl_set_comp_entry("ryk0532",TRUE)
#      CALL cl_set_comp_entry("ryk0533",TRUE)
#      CALL cl_set_comp_entry("ryk0545",TRUE)
       CALL cl_set_comp_entry("ryk05401",TRUE)
       CALL cl_set_comp_entry("ryk05402",TRUE)
       CALL cl_set_comp_entry("ryk05403",TRUE)
#FUN-B70011 ---------------END     
    END IF
END FUNCTION

#FUN-B70011 ---------------STA
FUNCTION p030_chk_choice1()
#   IF g_ryk[5].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF      
#   IF g_ryk[18].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[20].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
   #FUN-B30164 mark
   #FUN-B10011 mark begin
#   IF g_ryk[24].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
   #FUN-B10011 mark end
#   IF g_ryk[19].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[25].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[29].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[31].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[1].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[2].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF
#   IF g_ryk[3].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF    
   #TQC-B20166 add ---begin---
#   IF g_ryk[41].ryk05 = "N" THEN
#      LET g_choice1 = "N"
#   END IF  
   #TQC-B20166 add ---end---   

   IF g_ryk[101].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF      
   IF g_ryk[102].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[103].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   #FUN-B30164 mark
   #FUN-B10011 mark begin
   IF g_ryk[104].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   #FUN-B10011 mark end
   IF g_ryk[105].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[106].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[107].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[108].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[109].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[110].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF
   IF g_ryk[111].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF    
   IF g_ryk[112].ryk05 = "N" THEN
      LET g_choice1 = "N"
   END IF      
END FUNCTION
  
FUNCTION p030_chk_choice2()
#   IF g_ryk[10].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[11].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[12].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[28].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[7].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF   
#   IF g_ryk[26].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[27].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF
#   IF g_ryk[30].ryk05 = "N" THEN
#      LET g_choice2 = "N"
#   END IF   

   IF g_ryk[201].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF
#  IF g_ryk[202].ryk05 = "N" THEN                 #FUN-B90049 mark
#     LET g_choice2 = "N"
#  END IF
   IF g_ryk[203].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF
   IF g_ryk[204].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF
   IF g_ryk[205].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF   
   IF g_ryk[206].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF
   IF g_ryk[207].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF
   IF g_ryk[208].ryk05 = "N" THEN
      LET g_choice2 = "N"
   END IF    
END FUNCTION

FUNCTION p030_chk_choice3()

#   IF g_ryk[14].ryk05 = "N" THEN
#      LET g_choice3 = "N"
#   END IF   
#   IF g_ryk[15].ryk05 = "N" THEN
#      LET g_choice3 = "N"
#   END IF 
#   IF g_ryk[16].ryk05 = "N" THEN
#      LET g_choice3 = "N"
#   END IF

   IF g_ryk[301].ryk05 = "N" THEN
      LET g_choice3 = "N"
   END IF   
   IF g_ryk[302].ryk05 = "N" THEN
      LET g_choice3 = "N"
   END IF 
   IF g_ryk[303].ryk05 = "N" THEN
      LET g_choice3 = "N"
   END IF
END FUNCTION

FUNCTION p030_chk_choice4()
#   IF g_ryk[32].ryk05 = "N" THEN
#      LET g_choice4 = "N"
#   END IF   
#   IF g_ryk[33].ryk05 = "N" THEN
#      LET g_choice4 = "N"
#   END IF 
#   IF g_ryk[45].ryk05 = "N" THEN
#      LET g_choice4 = "N"
#   END IF  

   IF g_ryk[401].ryk05 = "N" THEN
      LET g_choice4 = "N"
   END IF   
   IF g_ryk[402].ryk05 = "N" THEN
      LET g_choice4 = "N"
   END IF 
   IF g_ryk[403].ryk05 = "N" THEN
      LET g_choice4 = "N"
   END IF    
END FUNCTION

#FUN-C50017 add begin ---
FUNCTION i030_chk_choice(p_type,p_z,p_n1,p_n2)     #组/内容信息切换回写
DEFINE  p_type  LIKE  type_file.chr1               #0 代表根据内容赋值组变量、1代表根据组变量赋值内容变量
DEFINE  p_z     LIKE  type_file.chr1               #组类型 1/2/3/4  例如1代表基本资料
DEFINE  p_n1    LIKE  type_file.num5               #开始项次
DEFINE  p_n2    LIKE  type_file.num5               #结束项次
DEFINE  l_y     LIKE  type_file.chr1               #
DEFINE  l_i     LIKE  type_file.num5               #循环遍历

     IF p_type = '0'  THEN            #内容赋值给组
             LET l_y = 'Y'
             FOR l_i = p_n1 TO p_n2
                 IF g_ryk[l_i].ryk05  = "N" THEN
                   LET l_y = "N"
                   EXIT FOR
                 END IF
             END FOR
             CASE p_z
                  WHEN "1"  LET g_choice1 = l_y
                  WHEN "2"  LET g_choice2 = l_y
                  WHEN "3"  LET g_choice3 = l_y
                  WHEN "4"  LET g_choice4 = l_y
             END CASE
     ELSE
            CASE p_z
                  WHEN "1"  LET l_y = g_choice1
                  WHEN "2"  LET l_y = g_choice2
                  WHEN "3"  LET l_y = g_choice3
                  WHEN "4"  LET l_y = g_choice4
             END CASE
             FOR l_i = p_n1 TO p_n2
                LET g_ryk[l_i].ryk05= l_y
             END FOR
     END IF
END FUNCTION
#FUN-C50017 add end -----

#MOD-AC0225 add begin-------------------------------------
FUNCTION p030_choice1(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF g_choice1 = 'Y' THEN
#      LET g_ryk[5].ryk05='Y'
#      LET g_ryk[18].ryk05='Y'
#      LET g_ryk[20].ryk05='Y'
#      LET g_ryk[24].ryk05='Y'
#      LET g_ryk[19].ryk05='Y'
#      LET g_ryk[25].ryk05='Y'
#      LET g_ryk[29].ryk05='Y'
#      LET g_ryk[31].ryk05='Y'
#      LET g_ryk[1].ryk05='Y'
#      LET g_ryk[2].ryk05='Y'
#      LET g_ryk[3].ryk05='Y' 
#      LET g_ryk[41].ryk05='Y'  #TQC-B20166 add
      LET g_ryk[101].ryk05='Y'
      LET g_ryk[102].ryk05='Y'
      LET g_ryk[103].ryk05='Y'
      LET g_ryk[104].ryk05='Y'
      LET g_ryk[105].ryk05='Y'
      LET g_ryk[106].ryk05='Y'
      LET g_ryk[107].ryk05='Y'
      LET g_ryk[108].ryk05='Y'
      LET g_ryk[109].ryk05='Y'
      LET g_ryk[110].ryk05='Y'
      LET g_ryk[111].ryk05='Y' 
      LET g_ryk[112].ryk05='Y'  
   END IF
#   DISPLAY g_ryk[5].ryk05 TO ryk055
#   DISPLAY g_ryk[18].ryk05 TO ryk0518
#   DISPLAY g_ryk[20].ryk05 TO ryk0520
#   DISPLAY g_ryk[24].ryk05 TO ryk0524
#   DISPLAY g_ryk[19].ryk05 TO ryk0519
#   DISPLAY g_ryk[25].ryk05 TO ryk0525
#   DISPLAY g_ryk[29].ryk05 TO ryk0529
#   DISPLAY g_ryk[31].ryk05 TO ryk0531
#   DISPLAY g_ryk[1].ryk05 TO ryk051
#   DISPLAY g_ryk[2].ryk05 TO ryk052
#   DISPLAY g_ryk[3].ryk05 TO ryk053
#   DISPLAY g_ryk[41].ryk05 TO ryk0541  #TQC-B20166 add

   DISPLAY g_ryk[101].ryk05 TO ryk05101
   DISPLAY g_ryk[102].ryk05 TO ryk05102
   DISPLAY g_ryk[103].ryk05 TO ryk05103
   DISPLAY g_ryk[104].ryk05 TO ryk05104
   DISPLAY g_ryk[105].ryk05 TO ryk05105
   DISPLAY g_ryk[106].ryk05 TO ryk05106
   DISPLAY g_ryk[107].ryk05 TO ryk05107
   DISPLAY g_ryk[108].ryk05 TO ryk05108
   DISPLAY g_ryk[109].ryk05 TO ryk05109
   DISPLAY g_ryk[110].ryk05 TO ryk05110
   DISPLAY g_ryk[111].ryk05 TO ryk05111
   DISPLAY g_ryk[112].ryk05 TO ryk05112  
   DISPLAY g_choice1 TO pchoice1
   CALL p030_set_entry(p_cmd)       
   CALL p030_set_no_entry(p_cmd)        
END FUNCTION

FUNCTION p030_choice2(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF g_choice2 = 'Y' THEN
#      LET g_ryk[10].ryk05='Y'
#      LET g_ryk[11].ryk05='Y'
#      LET g_ryk[12].ryk05='Y'
#      LET g_ryk[28].ryk05='Y'
#      LET g_ryk[7].ryk05='Y'
#      LET g_ryk[26].ryk05='Y'
#      LET g_ryk[27].ryk05='Y'
#      LET g_ryk[30].ryk05='Y'  
      LET g_ryk[201].ryk05='Y'
#     LET g_ryk[202].ryk05='Y'              #FUN-B90049 mark
      LET g_ryk[203].ryk05='Y'
      LET g_ryk[204].ryk05='Y'
      LET g_ryk[205].ryk05='Y'
      LET g_ryk[206].ryk05='Y'
      LET g_ryk[207].ryk05='Y'
      LET g_ryk[208].ryk05='Y' 
   END IF
#   DISPLAY g_ryk[10].ryk05 TO ryk0510
#   DISPLAY g_ryk[11].ryk05 TO ryk0511
#   DISPLAY g_ryk[12].ryk05 TO ryk0512
#   DISPLAY g_ryk[28].ryk05 TO ryk0528
#   DISPLAY g_ryk[7].ryk05 TO ryk057
#   DISPLAY g_ryk[26].ryk05 TO ryk0526
#   DISPLAY g_ryk[27].ryk05 TO ryk0527
#   DISPLAY g_ryk[30].ryk05 TO ryk0530

   DISPLAY g_ryk[201].ryk05 TO ryk05201
#  DISPLAY g_ryk[202].ryk05 TO ryk05202     #FUN-B90049 mark
   DISPLAY g_ryk[203].ryk05 TO ryk05203
   DISPLAY g_ryk[204].ryk05 TO ryk05204
   DISPLAY g_ryk[205].ryk05 TO ryk05205
   DISPLAY g_ryk[206].ryk05 TO ryk05206
   DISPLAY g_ryk[207].ryk05 TO ryk05207
   DISPLAY g_ryk[208].ryk05 TO ryk05208
   DISPLAY g_choice2 TO pchoice2
   CALL p030_set_entry(p_cmd)       
   CALL p030_set_no_entry(p_cmd)        
END FUNCTION

FUNCTION p030_choice3(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF g_choice3 = 'Y' THEN
#      LET g_ryk[14].ryk05='Y'
#      LET g_ryk[15].ryk05='Y'
#      LET g_ryk[16].ryk05='Y'  
      LET g_ryk[301].ryk05='Y'
      LET g_ryk[302].ryk05='Y'
      LET g_ryk[303].ryk05='Y' 
   END IF
#   DISPLAY g_ryk[14].ryk05 TO ryk0514
#   DISPLAY g_ryk[15].ryk05 TO ryk0515
#   DISPLAY g_ryk[16].ryk05 TO ryk0516
   DISPLAY g_ryk[301].ryk05 TO ryk05301
   DISPLAY g_ryk[302].ryk05 TO ryk05302
   DISPLAY g_ryk[303].ryk05 TO ryk05303
   DISPLAY g_choice3 TO pchoice3
   CALL p030_set_entry(p_cmd)       
   CALL p030_set_no_entry(p_cmd)            
END FUNCTION

FUNCTION p030_choice4(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF g_choice4 = 'Y' THEN
#      LET g_ryk[32].ryk05='Y'
#      LET g_ryk[33].ryk05='Y'
#      LET g_ryk[45].ryk05='Y'  
      LET g_ryk[401].ryk05='Y'
      LET g_ryk[402].ryk05='Y'
      LET g_ryk[403].ryk05='Y'
   END IF
#   DISPLAY g_ryk[32].ryk05 TO ryk0532
#   DISPLAY g_ryk[33].ryk05 TO ryk0533
#   DISPLAY g_ryk[45].ryk05 TO ryk0545
   DISPLAY g_ryk[401].ryk05 TO ryk05401
   DISPLAY g_ryk[402].ryk05 TO ryk05402
   DISPLAY g_ryk[403].ryk05 TO ryk05403
   DISPLAY g_choice4 TO pchoice4
   CALL p030_set_entry(p_cmd)       
   CALL p030_set_no_entry(p_cmd)           
END FUNCTION
#MOD-AC0225 add end--------------------------------------
#TQC-AC0206 add end--------------------------------------
#FUN-B30164 
#FUN-A30111---add
#FUN-B70011 ---------------END
