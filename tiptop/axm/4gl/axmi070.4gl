# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axmi070.4gl
# Descriptions...: 費用代碼維護作業
# Date & Author..: 94/12/13 By Danny
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.TQC-650082 06/06/14 By alexstar (下一頁)(結尾)靠右
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/08/31 By bnlent 欄位型態定義，改為LIKE
#
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80105 10/08/23 By lixh1 以業態判別加入零售及招商維護欄位
# Modify.........: No.FUN-B10052 11/01/28 By lilingyu 科目查詢自動過濾
# Modify.........: No:FUN-B40071 11/04/29 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oaj           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oaj01       LIKE oaj_file.oaj01,  
        oaj02       LIKE oaj_file.oaj02,
        oaj031      LIKE oaj_file.oaj031,     #FUN-A80105
        lnj02       LIKE lnj_file.lnj02,      #FUN-A80105
        oaj04       LIKE oaj_file.oaj04,      #FUN-A80105
        aag02       LIKE aag_file.aag02,      #FUN-A80105
        oaj041      LIKE oaj_file.oaj041,     #FUN-A80105
        aag021      LIKE aag_file.aag02,      #FUN-A80105
        oaj05       LIKE oaj_file.oaj05,      #FUN-A80105
        oaj07       LIKE oaj_file.oaj07,      #FUN-A80105
        oajacti     LIKE oaj_file.oajacti,    #FUN-A80105
        oajpos      LIKE oaj_file.oajpos      #FUN-A80105        
                    END RECORD,
    g_oaj_t         RECORD                 #程式變數 (舊值)
        oaj01       LIKE oaj_file.oaj01,  
        oaj02       LIKE oaj_file.oaj02,
        oaj031      LIKE oaj_file.oaj031,     #FUN-A80105
        lnj02       LIKE lnj_file.lnj02,      #FUN-A80105
        oaj04       LIKE oaj_file.oaj04,      #FUN-A80105
        aag02       LIKE aag_file.aag02,      #FUN-A80105
        oaj041      LIKE oaj_file.oaj041,     #FUN-A80105
        aag021      LIKE aag_file.aag02,      #FUN-A80105        
        oaj05       LIKE oaj_file.oaj05,      #FUN-A80105
        oaj07       LIKE oaj_file.oaj07,      #FUN-A80105
        oajacti     LIKE oaj_file.oajacti,    #FUN-A80105
        oajpos      LIKE oaj_file.oajpos      #FUN-A80105          
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql string  #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109           #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 3 LET p_col = 16
 
    OPEN WINDOW i070_w AT p_row,p_col WITH FORM "axm/42f/axmi070"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
#FUN-A80105 --Begin--
    IF g_aza.aza63 = 'N' THEN 
       CALL cl_set_comp_visible("oaj041,aag021",FALSE)
    ELSE
    	 CALL cl_set_comp_visible("oaj041,aag021",TRUE)
    END IF  

    IF g_aza.aza88 = 'Y' THEN
       CALL cl_set_comp_visible("oajpos",TRUE)       
    ELSE
       CALL cl_set_comp_visible("oajpos",FALSE)
    END IF
    
    IF g_azw.azw04 = '1' THEN
       CALL cl_set_comp_visible("oaj031,lnj02",FALSE)   
       CALL cl_set_comp_visible("oaj04,aag02",FALSE) 
       CALL cl_set_comp_visible("oaj041,aag021",FALSE)        
       CALL cl_set_comp_visible("oaj05,oaj07",FALSE)
       CALL cl_set_comp_visible("oajacti,oajpos",FALSE)  
    END IF       
#FUN-A80105 --End--
        
    LET g_wc2 = '1=1' 
    CALL i070_b_fill(g_wc2)
    CALL i070_menu()
    CLOSE WINDOW i070_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i070_menu()
   WHILE TRUE
      CALL i070_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i070_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i070_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i070_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oaj),'','')
            END IF
 
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i070_q()
   CALL i070_b_askkey()
END FUNCTION
 
FUNCTION i070_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                 #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5,                 #可刪除否        #No.FUN-680137 SMALLINT
    l_n1            LIKE type_file.num5                  #FUN-A80105 

#FUN-A80105 --Begin-- 
DEFINE
   l_lnj02         LIKE lnj_file.lnj02,
   l_lnj02_1       LIKE lnj_file.lnj02,
   l_lnj03         LIKE lnj_file.lnj03,    
   l_lnj03_1       LIKE lnj_file.lnj03, 
   l_aagacti       LIKE aag_file.aagacti, 
   l_aagacti_1     LIKE aag_file.aagacti,
   l_aag00         LIKE aag_file.aag00, 
   l_aag00_1       LIKE aag_file.aag00,
   l_aag02         LIKE aag_file.aag02,
   l_aag02_1       LIKE aag_file.aag02, 
   l_aag03         LIKE aag_file.aag03,    
   l_aag07         LIKE aag_file.aag07   
#FUN-A80105 --End--
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
#    LET g_forupd_sql = "SELECT oaj01,oaj02 FROM oaj_file WHERE oaj01=? FOR UPDATE"       #FUN-A80105
#FUN-A80105 --Begin--
    LET g_forupd_sql = "SELECT oaj01,oaj02,oaj031,'',oaj04,'',oaj041,'',oaj05,oaj07,oajacti,oajpos ",
                       "  FROM oaj_file WHERE  ",                
                       " oaj01= ?  FOR UPDATE "
#FUN-A80105 --End--
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i070_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_oaj WITHOUT DEFAULTS FROM s_oaj.*              #FUN-A80105
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, #FUN-A80105
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) #FUN-A80105
          
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
#No.FUN-A80105 --Begin--                 
      ON ACTION controlp
         CASE
              WHEN INFIELD(oaj031)                                                                                   
                 CALL cl_init_qry_var()                                                                                
                 LET g_qryparam.form ="q_lnj"                                                                        
                 LET g_qryparam.default1 = g_oaj[l_ac].oaj031                                                        
                 CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj031                                                
                 DISPLAY g_oaj[l_ac].oaj031 TO oaj031                                                               
                 NEXT FIELD oaj031   
                  
               WHEN INFIELD(oaj04)                                                                                   
                 CALL cl_init_qry_var()                                                                                
                 LET g_qryparam.form ="q_aag04"                                                                        
                 LET g_qryparam.default1 = g_oaj[l_ac].oaj04                                                        
                 LET g_qryparam.arg1 = g_aza.aza81                                                                
                 CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj04                                                
                 DISPLAY g_oaj[l_ac].oaj04 TO oaj04                                                               
                 NEXT FIELD oaj04 
               WHEN INFIELD(oaj041)                                                                                   
                 CALL cl_init_qry_var()                                                                                
                 LET g_qryparam.form ="q_aag04"                                                                        
                 LET g_qryparam.default1 = g_oaj[l_ac].oaj041                                                        
                 LET g_qryparam.arg1 = g_aza.aza82                                                                
                 CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj041                                                
                 DISPLAY g_oaj[l_ac].oaj041 TO oaj041                                                               
                 NEXT FIELD oaj041                     
               
            OTHERWISE EXIT CASE
         END CASE 
#No.FUN-A80105 --End--                         
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_oaj_t.* = g_oaj[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i070_set_entry_b(p_cmd)                                                                                         
               CALL i070_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   
 
               BEGIN WORK
 
               OPEN i070_bcl USING g_oaj_t.oaj01
               IF STATUS THEN
                  CALL cl_err("OPEN i070_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i070_bcl INTO g_oaj[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_oaj_t.oaj01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL i070_xxx()          #FUN-A80105                  
               END IF
              
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
#            INSERT INTO oaj_file(oaj01,oaj02)           #FUN-A80105
#            VALUES(g_oaj[l_ac].oaj01,g_oaj[l_ac].oaj02) #FUN-A80105
#FUN-A80105 --Begin--
         IF g_azw.azw04 = '1' THEN  
            INSERT INTO oaj_file(oaj01,oaj02)           
            VALUES(g_oaj[l_ac].oaj01,g_oaj[l_ac].oaj02) 
         ELSE     
            INSERT INTO oaj_file(oaj01,oaj02,oaj031,oaj04,oaj041,oaj05,oaj07,oajacti,oajpos)
            VALUES(g_oaj[l_ac].oaj01,g_oaj[l_ac].oaj02,g_oaj[l_ac].oaj031,g_oaj[l_ac].oaj04,g_oaj[l_ac].oaj041,
                   g_oaj[l_ac].oaj05,g_oaj[l_ac].oaj07,g_oaj[l_ac].oajacti,g_oaj[l_ac].oajpos)
         END IF           
#FUN-A80105 --End-- 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oaj[l_ac].oaj01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","oaj_file",g_oaj[l_ac].oaj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2 
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i070_set_entry_b(p_cmd)                                                                                         
            CALL i070_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   

            INITIALIZE g_oaj[l_ac].* TO NULL      #900423
            LET g_oaj_t.* = g_oaj[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)

#FUN-A80105 --Begin--
            LET g_oaj[l_ac].oajacti = 'Y' 
            IF g_aza.aza88 = 'Y' THEN                                            
               LET g_oaj[l_ac].oajpos = '1' #NO.FUN-B40071                                      
            END IF     
            NEXT FIELD oaj01
#FUN-A80105 --End--            
 
        AFTER FIELD oaj01                        #check 編號是否重複
            IF g_oaj[l_ac].oaj01 IS NOT NULL THEN 
            IF g_oaj[l_ac].oaj01 != g_oaj_t.oaj01 OR
               (g_oaj[l_ac].oaj01 IS NOT NULL AND g_oaj_t.oaj01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM oaj_file
                    WHERE oaj01 = g_oaj[l_ac].oaj01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_oaj[l_ac].oaj01 = g_oaj_t.oaj01
                    NEXT FIELD oaj01
                END IF
            END IF
            END IF
#FUN-A80105 --Begin--
      AFTER FIELD oaj031
         IF NOT cl_null(g_oaj[l_ac].oaj031) THEN
             IF g_oaj[l_ac].oaj031 != g_oaj_t.oaj031 OR
                g_oaj_t.oaj031 IS NULL THEN
                SELECT count(*) INTO l_n1 FROM lnj_file
                 WHERE lnj01 = g_oaj[l_ac].oaj031                
                IF l_n1 < 1 THEN
                   CALL cl_err(g_oaj[l_ac].oaj031,'axm0000',1)
                   LET g_oaj[l_ac].oaj031 = g_oaj_t.oaj031
                   NEXT FIELD oaj031
                 ELSE
                 	 SELECT lnj03 INTO l_lnj03 FROM lnj_file
                 	  WHERE lnj01 = g_oaj[l_ac].oaj031
                    IF l_lnj03 != 'Y' THEN 
                       CALL cl_err(g_oaj[l_ac].oaj031,'axm0000',1)
                       LET g_oaj[l_ac].oaj031 = g_oaj_t.oaj031
                       NEXT FIELD oaj031                      
                    ELSE
                    	  SELECT lnj02 INTO l_lnj02 FROM lnj_file                  
                         WHERE lnj01 = g_oaj[l_ac].oaj031
                    	  LET g_oaj[l_ac].lnj02 = l_lnj02
                    	  DISPLAY BY NAME g_oaj[l_ac].lnj02                     	           
                    END IF    
                END IF
             END IF
          ELSE
              LET g_oaj[l_ac].lnj02 = ''
           	  DISPLAY BY NAME g_oaj[l_ac].lnj02   
          END IF   
          
       AFTER FIELD oaj04
           IF NOT cl_null(g_oaj[l_ac].oaj04) THEN
             IF g_oaj[l_ac].oaj04 != g_oaj_t.oaj04 OR
                g_oaj_t.oaj04 IS NULL THEN
                LET l_n1 = 0 
                SELECT count(*) INTO l_n1 FROM aag_file
                 WHERE aag01 = g_oaj[l_ac].oaj04
                   AND aag00 = g_aza.aza81     
                IF l_n1 < 1 THEN
#FUN-B10052 --begin--                 
#                  CALL cl_err(g_oaj[l_ac].oaj04,'alm-088',1)         
                   CALL cl_err(g_oaj[l_ac].oaj04,'alm-088',0)    
#                  LET g_oaj[l_ac].oaj04 = g_oaj_t.oaj04 

                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag04"
                 LET g_qryparam.default1 = g_oaj[l_ac].oaj04
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.where = " aag01 LIKE '",g_oaj[l_ac].oaj04 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj04
                 DISPLAY g_oaj[l_ac].oaj04 TO oaj04 

          	     SELECT aag02 INTO l_aag02 FROM aag_file
                  WHERE aag01 = g_oaj[l_ac].oaj04
                    AND aag00 = g_aza.aza81
                    AND aag03 = '2'
                    AND (aag07 = '2' OR aag07 = '3')
                    AND aagacti = 'Y'
                 LET g_oaj[l_ac].aag02 = l_aag02
                 DISPLAY BY NAME g_oaj[l_ac].aag02                                  
#FUN-B10052 --end--                   
                   NEXT FIELD oaj04
                 ELSE                	
                 	 SELECT aagacti INTO l_aagacti FROM aag_file
                 	  WHERE aag01 = g_oaj[l_ac].oaj04
                      AND aag00 = g_aza.aza81 
                    IF l_aagacti != 'Y' THEN 
                       CALL cl_err(g_oaj[l_ac].oaj04,'alm-089',1)
                       LET g_oaj[l_ac].oaj04 = g_oaj_t.oaj04
                       NEXT FIELD oaj04
                    ELSE
                    	  SELECT aag03 INTO l_aag03 FROM aag_file
                    	   WHERE aag01 = g_oaj[l_ac].oaj04
                    	     AND aag00 = g_aza.aza81
                   	   IF l_aag03 != '2' THEN 
                   	      CALL cl_err('','alm-447',1)
                   	      NEXT FIELD oaj04
                    	    ELSE
                    	    	 SELECT aag07 INTO l_aag07 FROM aag_file
                    	    	  WHERE aag01 = g_oaj[l_ac].oaj04
                    	    	    AND aag00 = g_aza.aza81 
                    	    	  IF l_aag07 = '2' OR l_aag07 = '3' THEN 
                    	    	     SELECT aag02 INTO l_aag02 FROM aag_file
                    	    	     WHERE aag01 = g_oaj[l_ac].oaj04
                    	    	       AND aag00 = g_aza.aza81
                    	    	       AND aag03 = '2'
                    	    	       AND (aag07 = '2' OR aag07 = '3')
                    	    	       AND aagacti = 'Y'
                    	    	       LET g_oaj[l_ac].aag02 = l_aag02
                    	             DISPLAY BY NAME g_oaj[l_ac].aag02                      	    	    
                    	    	   ELSE                       	    	      
                    	    	     CALL cl_err('','alm-448',1)
                    	    	     NEXT FIELD oaj04 
                    	        END IF                     	   
                    	     END IF                 	           
                      END IF  
                  END IF
               END IF
            ELSE
            	   LET g_oaj[l_ac].aag02 = ''
            	   DISPLAY BY NAME g_oaj[l_ac].aag02    
           END IF   
          
         AFTER FIELD oaj041
           IF NOT cl_null(g_oaj[l_ac].oaj041) THEN
             IF g_oaj[l_ac].oaj041 != g_oaj_t.oaj041 OR
                g_oaj_t.oaj041 IS NULL THEN
                LET l_n1 = 0 
                SELECT count(*) INTO l_n1 FROM aag_file
                 WHERE aag01 = g_oaj[l_ac].oaj041
                   AND aag00 = g_aza.aza82
                IF l_n1 < 1 THEN
#FUN-B10052 --begin--          
#                  CALL cl_err(g_oaj[l_ac].oaj041,'alm-088',1)
                   CALL cl_err(g_oaj[l_ac].oaj041,'alm-088',0)
#                  LET g_oaj[l_ac].oaj041 = g_oaj_t.oaj041

                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag04"
                 LET g_qryparam.default1 = g_oaj[l_ac].oaj041
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.where = " aag01 LIKE '",g_oaj[l_ac].oaj041 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_oaj[l_ac].oaj041
                 DISPLAY g_oaj[l_ac].oaj041 TO oaj041

                SELECT aag02 INTO l_aag02_1 FROM aag_file
                 WHERE aag01 = g_oaj[l_ac].oaj041
                   AND aag00 = g_aza.aza82
                   AND aagacti = 'Y'
                   AND aag03 = '2'
                   AND (aag07='2' OR aag07 = '3') 
                  LET g_oaj[l_ac].aag021 = l_aag02_1
                  DISPLAY BY NAME g_oaj[l_ac].aag021                  
#FUN-B10052 --end--                   
                   NEXT FIELD oaj041
                 ELSE
                 	 SELECT aagacti INTO l_aagacti_1 FROM aag_file
                 	  WHERE aag01 = g_oaj[l_ac].oaj041
                      AND aag00 = g_aza.aza82 
                    IF l_aagacti_1 != 'Y' THEN 
                       CALL cl_err(g_oaj[l_ac].oaj041,'alm-089',1)
                       LET g_oaj[l_ac].oaj041 = g_oaj_t.oaj041
                       NEXT FIELD oaj041
                    ELSE
                    	  SELECT aag03 INTO l_aag03 FROM aag_file
                    	   WHERE aag01 = g_oaj[l_ac].oaj041
                    	    AND aag00 = g_aza.aza82
                   	   IF l_aag03 != '2' THEN 
                   	      CALL cl_err('','alm-447',1)
                          NEXT FIELD oaj041
                    	  ELSE
                    	  	  SELECT aag07 INTO l_aag07 FROM aag_file
                    	  	   WHERE aag01 = g_oaj[l_ac].oaj041
                    	  	     AND aag00 = g_aza.aza82
                    	  	    IF l_aag07 = '2' OR l_aag07 = '3' THEN 
                    	  	       SELECT aag02 INTO l_aag02_1 FROM aag_file
                    	    	      WHERE aag01 = g_oaj[l_ac].oaj041
                    	    	        AND aag00 = g_aza.aza82
                    	    	        AND aagacti = 'Y'
                    	    	        AND aag03 = '2'
                    	    	        AND (aag07='2' OR aag07 = '3') 
                    	    	      LET g_oaj[l_ac].aag021 = l_aag02_1
                    	            DISPLAY BY NAME g_oaj[l_ac].aag021                    	  	    
                    	  	     ELSE  
                    	    	      CALL cl_err('','alm-448',1)
                    	  	        NEXT FIELD oaj041 
                    	         END IF   
                  	    END IF                     	                       	                   	           
                    END IF    
                END IF
             END IF
          ELSE  
          	    LET g_oaj[l_ac].aag021 = ''
          	    DISPLAY BY NAME g_oaj[l_ac].aag021        
          END IF     

#FUN-A80105 --End--            
 
        BEFORE DELETE                            #是否取消單身
            IF g_oaj_t.oaj01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
#FUN-A80105 --Begin--                
                IF g_aza.aza88 = 'Y' THEN
                  #FUN-B40071 --START--
                   #IF g_oaj[l_ac].oajacti = 'Y' THEN
                   #   CALL cl_err("",'art-648',0)
                   #   CANCEL DELETE 
                   #END IF
                   #IF g_oaj[l_ac].oajacti = 'N' THEN                      
                   #   IF  g_oaj[l_ac].oajpos = 'Y' THEN
                   #      
                   #   END IF
                   #   IF  g_oaj[l_ac].oajpos = 'N' THEN
                   #       CALL cl_err("",'art-648',0)
                   #       CANCEL DELETE 
                   #   END IF                      
                   #END IF                  
                  
                END IF                 
                #IF NOT cl_delete() THEN
                #     CANCEL DELETE
                #END IF
                 #FUN-B40071 --END--   
#FUN-A80105 --End--                
{ckp#1}         DELETE FROM oaj_file WHERE oaj01 = g_oaj_t.oaj01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oaj_t.oaj01,SQLCA.sqlcode,0) #No.FUN-660167
                   CALL cl_err3("del","oaj_file",g_oaj_t.oaj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                MESSAGE "Delete OK"
                CLOSE i070_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oaj[l_ac].* = g_oaj_t.*
               CLOSE i070_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF                      
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oaj[l_ac].oaj01,-263,1)
               LET g_oaj[l_ac].* = g_oaj_t.*
            ELSE
              #FUN-B40071 --START--
              IF g_oaj[l_ac].oajpos <> '1' THEN
                 LET g_oaj[l_ac].oajpos = '2'
              ELSE
                 LET g_oaj[l_ac].oajpos = '1'
              END IF            
              #FUN-B40071 --END--  
               UPDATE oaj_file SET oaj01=g_oaj[l_ac].oaj01,
                                   oaj02=g_oaj[l_ac].oaj02,
                                   oaj031=g_oaj[l_ac].oaj031,    #FUN-A80105
                                   oaj04=g_oaj[l_ac].oaj04,      #FUN-A80105
                                   oaj041=g_oaj[l_ac].oaj041,    #FUN-A80105
                                   oaj05=g_oaj[l_ac].oaj05,      #FUN-A80105
                                   oaj07=g_oaj[l_ac].oaj07,      #FUN-A80105
                                   oajacti=g_oaj[l_ac].oajacti,  #FUN-A80105
                                   oajpos=g_oaj[l_ac].oajpos     #FUN-A80105                                   
                 WHERE oaj01 = g_oaj_t.oaj01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oaj[l_ac].oaj01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","oaj_file",g_oaj_t.oaj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_oaj[l_ac].* = g_oaj_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i070_bcl
                   COMMIT WORK
               END IF
            
            END IF
 
        
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oaj[l_ac].* = g_oaj_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_oaj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i070_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i070_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i070_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oaj01) AND l_ac > 1 THEN
                LET g_oaj[l_ac].* = g_oaj[l_ac-1].*
                NEXT FIELD oaj01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i070_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i070_b_askkey()
    CLEAR FORM
    CALL g_oaj.clear()
#    CONSTRUCT g_wc2 ON oaj01,oaj02          #FUN-A80105
#        FROM s_oaj[1].oaj01,s_oaj[1].oaj02  #FUN-A80105
#FUN-A80105 --Begin--
    CONSTRUCT g_wc2 ON oaj01,oaj02,oaj031,oaj04,oaj041,oaj05,oaj07,oajacti,oajpos            
           FROM s_oaj[1].oaj01,s_oaj[1].oaj02,s_oaj[1].oaj031,s_oaj[1].oaj04,s_oaj[l_ac].oaj041,  
                s_oaj[1].oaj05,s_oaj[1].oaj07,s_oaj[1].oajacti,s_oaj[1].oajpos
#FUN-A80105 --End--
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
#No.FUN-A80105 --Begin--                 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oaj031)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_oaj7"                                                                       
               LET g_qryparam.state='c'                                                                             
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO oaj031                                                               
               NEXT FIELD oaj031  
                      
            WHEN INFIELD(oaj04)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_oaj8"                                                                       
               LET g_qryparam.state='c'                                                                             
               LET g_qryparam.arg1 = g_aza.aza81
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO oaj04                                                               
               NEXT FIELD oaj04
                     
            WHEN INFIELD(oaj041)                                                    
               CALL cl_init_qry_var()                                      
               LET g_qryparam.form ="q_oaj81"                                                                       
               LET g_qryparam.state='c'                                                                             
               LET g_qryparam.arg1 = g_aza.aza82                                                                 
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                   
               DISPLAY g_qryparam.multiret TO oaj041                                                               
               NEXT FIELD oaj041  
               
            OTHERWISE EXIT CASE
         END CASE 
#No.FUN-A80105 --End--                        
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
   #   RETURN             #FUN-A80105
   END IF
#No.TQC-710076 -- end --
    CALL i070_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i070_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
#    LET g_sql =                                              #FUN-A80105
#        "SELECT oaj01,oaj02",                                #FUN-A80105 
#        " FROM oaj_file",                                    #FUN-A80105
#        " WHERE ", p_wc2 CLIPPED,                     #單身   #FUN-A80105
#        " ORDER BY 1"                                        #FUN-A80105
#FUN-A80105 --Begin--
    LET g_sql = "SELECT oaj01,oaj02,oaj031,'',oaj04,'',oaj041,'',oaj05,oaj07,oajacti,oajpos ",                                
               " FROM oaj_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY oaj01"
#FUN-A80105 --End-- 
    PREPARE i070_pb FROM g_sql
    DECLARE oaj_curs CURSOR FOR i070_pb
 
    CALL g_oaj.clear()
    LET g_cnt = 1
 
    MESSAGE "Searching!" 
    FOREACH oaj_curs INTO g_oaj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL i070_x()          #FUN-A80105       
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_oaj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i070_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oaj TO s_oaj.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-A80105 --Begin--
FUNCTION i070_xxx()
  DEFINE l_lnj02       LIKE lnj_file.lnj02
  DEFINE l_aag02       LIKE aag_file.aag02
  DEFINE l_aag02_1     LIKE aag_file.aag02
  
  SELECT lnj02 INTO l_lnj02 FROM lnj_file
   WHERE lnj01 = g_oaj[l_ac].oaj031
   LET g_oaj[l_ac].lnj02 = l_lnj02
   DISPLAY BY NAME g_oaj[l_ac].lnj02                     	           
           
  SELECT aag02 INTO l_aag02 FROM aag_file
   WHERE aag01 = g_oaj[l_ac].oaj04
     LET g_oaj[l_ac].aag02 = l_aag02
   DISPLAY BY NAME g_oaj[l_ac].aag02  
                    	 
   
    SELECT aag02 INTO l_aag02_1 FROM aag_file
     WHERE aag01 = g_oaj[l_ac].oaj041
       LET g_oaj[l_ac].aag021 = l_aag02_1
     DISPLAY BY NAME g_oaj[l_ac].aag021
     
END FUNCTION 
#FUN-A80105 --End--

#FUN-A80105 --Begin--
FUNCTION i070_x()
  DEFINE l_lnj02       LIKE lnj_file.lnj02
  DEFINE l_aag02       LIKE aag_file.aag02
  DEFINE l_aag02_1     LIKE aag_file.aag02
  
  SELECT lnj02 INTO l_lnj02 FROM lnj_file
   WHERE lnj01 = g_oaj[g_cnt].oaj031
     LET g_oaj[g_cnt].lnj02 = l_lnj02
                    	           
           
  SELECT aag02 INTO l_aag02 FROM aag_file
   WHERE aag01 = g_oaj[g_cnt].oaj04
     LET g_oaj[g_cnt].aag02 = l_aag02
 
                    	 
   
    SELECT aag02 INTO l_aag02_1 FROM aag_file
     WHERE aag01 = g_oaj[g_cnt].oaj041
       LET g_oaj[g_cnt].aag021 = l_aag02_1

     
END FUNCTION
#FUN-A80105 --End--
#No.FUN-7C0043--start--  
FUNCTION i070_out()
     DEFINE
         l_oaj           RECORD LIKE oaj_file.*,
         l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         l_za05          LIKE type_file.chr1000                #        #No.FUN-680137 VARCHAR(40)
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
     IF g_wc2 IS NULL THEN                                                                                                          
        CALL cl_err('','9057',0) RETURN END IF                                                                                      
     LET l_cmd = 'p_query "axmi070" "',g_wc2 CLIPPED,'"'                                                                            
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN   
#    IF g_wc2 IS NULL THEN
#       CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#
#   LET g_sql="SELECT * FROM oaj_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i070_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i070_co                         # CURSOR
#        CURSOR FOR i070_p1
#
#    LET g_rlang = g_lang                               #FUN-4C0096 add
#    CALL cl_outnam('axmi070') RETURNING l_name
#    START REPORT i070_rep TO l_name
#
#    FOREACH i070_co INTO l_oaj.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i070_rep(l_oaj.*)
#    END FOREACH
#
#    FINISH REPORT i070_rep
#
#    CLOSE i070_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i070_rep(sr)
#    DEFINE
#        l_trailer_sw     LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
#        sr RECORD LIKE oaj_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.oaj01
#
##FUN-4C0096 modify
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED, pageno_total
#            PRINT ''
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31], 
#                  g_x[32] 
#            PRINT g_dash1                                
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.oaj01,
#                  COLUMN g_c[32],sr.oaj02 
#
#       ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #TQC-650082
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-650082
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-7C0043--end--      
#No.FUN-570109 --start--                                                                                                            
FUNCTION i070_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                   #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oaj01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i070_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oaj01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end-- 
