# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp600.4gl
# Descriptions...: 廠商整批拋轉作業 
# Date & Author..: 08/02/26 By lilingyu
# Modify.........: NO.FUN-820028 08/03/20 By lilingyu 單身筆數顯示
# Modify.........: NO.FUN-820028 08/04/01 By lilingyu 拿掉pmc1921拋轉次數
# Modify.........: NO.FUN-840033 08/04/08 BY yiting 1.apmp600 call apmi600直接開啟主畫面
#                                                   2.呼叫拋轉歷史應傳入key值直接開啟目前此筆資料記錄
#                                                   3.進畫面之後，1.按取消 2.按查詢 3.按確定，都沒有辦法再查出資料
#                                                   4.按「廠商明細」時沒有反應
#                                                   5.無勾選任何資料，直接按「資料下載」要提示錯誤訊息
#                                                   6.查詢時，應開放開窗查詢
# Modify.........: No.MOD-910037 09/01/06 By Smapmin 選擇資料拋轉時程式會當掉
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"
#GLOBALS "../../sub/4gl/s_apmi600_center.global"  
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02,
                  #wc       LIKE type_file.chr1000
                  wc             STRING           #NO.FUN-910082
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_pmc   DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  pmc01    LIKE pmc_file.pmc01,
                  pmc03    LIKE pmc_file.pmc03,
                  pmc081   LIKE pmc_file.pmc081,
                  pmc24    LIKE pmc_file.pmc24,
                  pmc14    LIKE pmc_file.pmc14,
                  pmc02    LIKE pmc_file.pmc02,
                  pmc30    LIKE pmc_file.pmc30,
                  pmc04    LIKE pmc_file.pmc04,
                  pmc901   LIKE pmc_file.pmc901,
                  pmc05    LIKE pmc_file.pmc05,
                  pmcacti  LIKE pmc_file.pmcacti
                # pmc1921  LIKE pmc_file.pmc1921   #NO.FUN-820028
                 END RECORD
DEFINE  g_pmcx  DYNAMIC ARRAY OF RECORD                                                 
                 sel       LIKE type_file.chr1,                                                                                  
                 pmc01     LIKE pmc_file.pmc01                                                                                   
                END RECORD
DEFINE  g_pmc_p  DYNAMIC ARRAY OF RECORD                                                 
                 sel       LIKE type_file.chr1,                                                                                  
                 pmc01     LIKE pmc_file.pmc01                                                                                   
                END RECORD               
                                            
DEFINE 
       #g_sql      LIKE type_file.chr1000
       g_sql        STRING       #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE l_count    LIKE type_file.num10
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_gev04    LIKE gev_file.gev04   #NO.FUN-840033
MAIN
  DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p600_w AT p_row,p_col
        WITH FORM "apm/42f/apmp600"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   SELECT * FROM gev_file WHERE gev01 = '5' AND gev02 = g_plant                                                             
                            AND gev03 = 'Y'                                                                                 
   IF SQLCA.sqlcode THEN                                                                                                    
       CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB                                                                      
       EXIT PROGRAM                                                                                                          
   END IF
 
   CALL p600_tm()
   CALL p600_menu()
 
   CLOSE WINDOW p600_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p600_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000  
 
   WHILE TRUE
      CALL p600_bp("G")
      CASE g_action_choice
      #  WHEN "dantou"
        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p600_tm()
            END IF
 
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p600_b() 
            END IF
 
        WHEN "vendor_detail"
            IF cl_chk_act_auth() THEN            
               #NO.FUN-840033 add----
               IF l_ac > 0 THEN
                  LET l_cmd="apmi600  '",g_pmc[l_ac].pmc01,"' 'Y' " #no.FUN-840033
                  CALL cl_cmdrun(l_cmd)
               END IF
               #NO.FUN-840033 add----
               #CALL vendor_detail()
            END IF
            
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p600_carry()
               ERROR ""
            END IF
 
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p600_download()
            END IF
 
         WHEN "qry_carry_history"
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(tm1.gev04) THEN
                #--NO.FUN-840033 start--
                SELECT gev04 INTO g_gev04 FROM gev_file                                                                           
                 WHERE gev01 = '5' AND gev02 = g_plant                                                                            
                IF NOT cl_null(g_gev04) THEN                                                                                         
                   LET l_cmd='aooq604 "',g_gev04,'" "5" "',g_prog,'" "',g_pmc[l_ac].pmc01,'"'                                              
                   CALL cl_cmdrun(l_cmd)                                                                                             
                END IF     
                #LET l_cmd='aooq604 "',tm1.gev04,'" "5"'
              END IF
              #--NO.FUN-840033 end-----
            END IF
            
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_pmc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p600_tm()
  DEFINE l_sql          STRING
  DEFINE l_where        STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    CLEAR FORM
    CALL g_pmc.clear()
    INITIALIZE tm1.* TO NULL            
#   CALL p600_init_b()
 
    LET tm1.gev04=NULL
    LET tm1.geu02=NULL
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
           WHERE gev01 = '5' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
           WHERE geu01 = tm1.gev04
    DISPLAY tm1.gev04 TO gev04
    DISPLAY tm1.geu02 TO geu02
 
#    DISPLAY BY NAME tm1.*
 
#    INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
#       AFTER FIELD gev04
#          IF NOT cl_null(tm1.gev04) THEN
#             CALL p600_gev04()
#             IF NOT cl_null(g_errno) THEN
#                CALL cl_err(tm1.gev04,g_errno,0)
#                NEXT FIELD gev04
#             END IF
#          ELSE
#             DISPLAY '' TO geu02
#          END IF
 
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(gev04)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_gev04"
#                LET g_qryparam.arg1 = "5"
#                LET g_qryparam.arg2 = g_plant
#                CALL cl_create_qry() RETURNING tm1.gev04
#                DISPLAY BY NAME tm1.gev04
#                NEXT FIELD gev04
##             OTHERWISE EXIT CASE
 #         END CASE
#
 #      ON ACTION locale
#          CALL cl_show_fld_cont()
#          LET g_action_choice = "locale"
 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
#
#       ON ACTION controlg
#          CALL cl_cmdask()
 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#
#    END INPUT
 
 #   IF INT_FLAG THEN
 #      LET INT_FLAG=0
 #      CLOSE WINDOW p600_w
 #      CALL cl_used(g_prog,g_time,2) RETURNING g_time
 #      EXIT PROGRAM
 #   END IF
     
     CALL g_pmc.clear()                                                                                                      
     CONSTRUCT tm1.wc ON pmc01,pmc03,pmc081,pmc24,pmc14,pmc02,                                                              
                      #   pmc30,pmc04,pmc901,pmc05,pmcacti,pmc1921   #NO.FUN-820028                                                        
                         pmc30,pmc04,pmc901,pmc05,pmcacti                                                           
                    FROM s_pmc[1].pmc01,s_pmc[1].pmc03,s_pmc[1].pmc081,                                                                
                         s_pmc[1].pmc24,s_pmc[1].pmc14,s_pmc[1].pmc02,                                                                
                         s_pmc[1].pmc30,s_pmc[1].pmc04,s_pmc[1].pmc901,s_pmc[1].pmc05,                                                                
                       # s_pmc[1].pmcacti,s_pmc[1].pmc1921                                                        
                         s_pmc[1].pmcacti                                                       
 
     BEFORE CONSTRUCT                                                                                                     
           CALL cl_qbe_init()                                                                                                
 
 
     #----NO.FUN-840033 start---
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmc01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc01
            WHEN INFIELD(pmc02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmy"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc02
            WHEN INFIELD(pmc04) #查詢付款廠商檔
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc04
            WHEN INFIELD(pmc901) #查詢出貨廠商檔
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmc901
            OTHERWISE EXIT CASE
         END CASE
     #--NO.FUN-840033 end-------------
 
     ON IDLE g_idle_seconds                                                                                               
        CALL cl_on_idle()                                                                                                 
        CONTINUE CONSTRUCT                                                                                                
 
     ON ACTION about                                                                                                      
        CALL cl_about()                                                                                                   
   
     ON ACTION help 
        CALL cl_show_help()                                                                                               
 
     ON ACTION controlg                                                                                                   
        CALL cl_cmdask()                                                                                                  
 
     ON ACTION qbe_select                                                                                                 
        CALL cl_qbe_select()                                                                                              
 
     ON ACTION qbe_save                                                                                                   
        CALL cl_qbe_save()                                                                                                
 
    END CONSTRUCT                                                                                                           
    LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup') #FUN-980030
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        RETURN 
    END IF 
 
    CALL p600_init_b()
    CALL p600_b()
 
END FUNCTION
 
FUNCTION p600_b()
 
   SELECT * FROM gev_file
      WHERE gev01 = '5' AND gev02 = g_plant
        AND gev03 = 'Y' AND gev04 = tm1.gev04
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_plant,'aoo-036',1)
      RETURN
   END IF
 
   IF g_pmc.getLength()=0 THEN
      LET g_action_choice=''
      RETURN
   END IF  
 
    INPUT ARRAY g_pmc WITHOUT DEFAULTS FROM s_pmc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
       
      BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
       
       AFTER ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p600_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p600_sel_all_1("N")
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg
          CALL cl_cmdask() 
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p600_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_pmc.getLength()
       LET g_pmc[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p600_gev04()
    DEFINE l_geu00   LIKE geu_file.geu00
    DEFINE l_geu02   LIKE geu_file.geu02
    DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
      FROM geu_file WHERE geu01=tm1.gev04
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    ELSE
       SELECT * FROM gev_file WHERE gev01 = '5' AND gev02 = g_plant
                                AND gev03 = 'Y' AND gev04 = tm1.gev04
       IF SQLCA.sqlcode THEN
          LET g_errno = 'aoo-036'   #Not Carry DB
       END IF
    END IF
    IF cl_null(g_errno) THEN
       LET tm1.geu02 = l_geu02
    END IF
    DISPLAY BY NAME tm1.geu02
END FUNCTION
 
FUNCTION p600_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
   DEFINE l_flag    LIKE type_file.chr1    #NO.FUN-840033
 
   #no.FUN-840033 start--
   LET l_flag = 'N'
   FOR l_i = 1 TO g_pmc.getLength()    
      IF g_pmc[l_i].sel = 'N' THEN
         CONTINUE FOR
      END IF                                                                                   
      LET l_flag = 'Y'
   END FOR                                                                                                                  
 
   IF l_flag= 'N' THEN
      CALL cl_err('','aoo-096',1)
      RETURN
   END IF
   #NO.FUN-840033 end-----
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(tm1.gev04,'5')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
   
   CALL g_pmc_p.clear()
   LET l_j = 1   #MOD-910037
   FOR l_i = 1 TO g_pmc.getLength()
       IF g_pmc[l_i].sel = 'Y' THEN
          LET g_pmc_p[l_j].sel   = g_pmc[l_i].sel
          LET g_pmc_p[l_j].pmc01 = g_pmc[l_i].pmc01
          LET l_j = l_j + 1   #MOD-910037
       END IF
   END FOR
   CALL g_pmc_p.deleteElement(l_j)   #MOD-910037
   
   CALL s_showmsg_init()
   CALL s_apmi600_carry_pmc(g_pmc_p,g_azp,tm1.gev04,'0') #NO.FUN-820028 
   #畫面拋轉次數
   CALL p600_init_b()
   DISPLAY ARRAY g_pmc TO s_pmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
   CALL s_showmsg() 
 
END FUNCTION
 
FUNCTION p600_init_b()
  DEFINE l_sql,l_where   STRING
 
    CALL g_pmc.clear()
    LET l_sql="SELECT 'N',pmc01,pmc03,pmc081,pmc24,pmc14,pmc02,",
                     # "pmc30,pmc04,pmc901,pmc05,pmcacti,pmc1921",
                       "pmc30,pmc04,pmc901,pmc05,pmcacti",
                 " FROM pmc_file ",
                 " WHERE ",tm1.wc,
                 " ORDER BY pmc01"
           
    SELECT count(*) INTO l_count FROM pmc_file 
   
    PREPARE p600_prepare FROM l_sql
    DECLARE p600_bc SCROLL CURSOR FOR p600_prepare
 
    LET g_cnt = 1
     FOREACH p600_bc INTO g_pmc[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF 
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          EXIT FOREACH 
       END IF    
     END FOREACH
    CALL g_pmc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1         
    DISPLAY g_rec_b TO FORMONLY.cnt  #NO.FUN-820028 
END FUNCTION
 
FUNCTION p600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice="detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmc TO s_pmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query 
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac =1
         EXIT DISPLAY      
 
      ON ACTION vendor_detail
         LET g_action_choice="vendor_detail"
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice="download"
         EXIT DISPLAY
 
      ON ACTION qry_carry_history
         LET g_action_choice="qry_carry_history"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p600_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10                                                                                  
  DEFINE l_j          LIKE type_file.num10                                                                                  
  DEFINE l_flag       LIKE type_file.chr1    #NO.FUN-840033
       
     LET l_flag = 'N'                
     CALL g_pmcx.clear()                                                                                                      
     FOR l_i = 1 TO g_pmc.getLength()    
        IF cl_null(g_pmc[l_i].pmc01) THEN
            CONTINUE FOR
        END IF
        IF g_pmc[l_i].sel = 'N' THEN
           CONTINUE FOR
        END IF                                                                                   
        LET g_pmcx[l_i].sel   = 'Y'                                                                                          
        LET g_pmcx[l_i].pmc01 = g_pmc[l_i].pmc01 
        LET l_flag = 'Y'
     END FOR                                                                                                                  
 
     #no.FUN-840033 start--
     IF l_flag= 'N' THEN
        CALL cl_err('','aoo-096',0)
        RETURN
     END IF
     #NO.FUN-840033 end---
     CALL s_apmi600_download(g_pmcx)
 
END FUNCTION     
 
FUNCTION vendor_detail()
  DEFINE l_i       LIKE type_file.num10
  DEFINE p_cmd    LIKE type_file.chr1000 
 
  FOR l_i = 1 TO g_pmc.getLength()      
       IF cl_null(g_pmc[l_i].pmc01) THEN
          CONTINUE FOR
       END IF   
       IF g_pmc[l_i].sel = 'Y' THEN
          LET p_cmd="apmi600  '",g_pmc[l_i].pmc01,"' "
          CALL cl_cmdrun(p_cmd)         
          EXIT FOR
       END IF      
    END FOR   
   
END FUNCTION  
