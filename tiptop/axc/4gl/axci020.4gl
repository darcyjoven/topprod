# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axci020.4gl
# Descriptions...: 成本階數名稱維護作業
# Date & Author..: 96/02/15  By  Felicity Tseng
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-570110 05/07/15 By wujie 修正建檔程式key值是否可更改 Modify.........: No.FUN-4C0099 05/01/06 By kim 報表轉XML功能
# Modify.........: No.TQC-5C0030 05/12/07 By kevin  欄位沒對齊
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0007 06/12/11 By johnray 修改報表格式
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-790064 07/09/14 By destiny 成本階數可以為負數BUG修改
# Modify.........: No.FUN-7C0043 07/12/20 By Sunyanchun   把老報表改成p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AC0050 11/05/04 By xianghui  增加全部可重工，全部不可重工兩個ACTION
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ccd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ccd01       LIKE ccd_file.ccd01,   
        ccd02       LIKE ccd_file.ccd02,  
        ccd03       LIKE ccd_file.ccd03
                    END RECORD,
    g_ccd_t         RECORD                 #程式變數 (舊值)
        ccd01       LIKE ccd_file.ccd01,   
        ccd02       LIKE ccd_file.ccd02,  
        ccd03       LIKE ccd_file.ccd03
                    END RECORD,
    g_ccdacti       LIKE  ccd_file.ccdacti,     
    g_ccduser       LIKE  ccd_file.ccduser,     
    g_ccdgrup       LIKE  ccd_file.ccdgrup,     
    g_ccdmodu       LIKE  ccd_file.ccdmodu,     
    g_ccddate       LIKE  ccd_file.ccddate,     
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_i             LIKE type_file.num5                 #處理全可重工和全不可重工   #FUN-AC0050
#FUN-AC0050-add-start-- 
DEFINE g_ccd_tt DYNAMIC ARRAY OF RECORD
        ccd01       LIKE ccd_file.ccd01,
        ccd02       LIKE ccd_file.ccd02,
        ccd03       LIKE ccd_file.ccd03
                    END RECORD
#FUN-AC0050-add-end--
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10                                       #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680122 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5            #No.FUN-570110          #No.FUN-680122 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5                                         #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i020_w AT p_row,p_col WITH FORM "axc/42f/axci020"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i020_b_fill(g_wc2)
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i020_menu()
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i020_out()     
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ccd),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION
 
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                   #No.FUN-680122 VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1,                                   #No.FUN-680122 VARCHAR(01)
    p_u             LIKE type_file.chr1                                   #FUN-AC0050

 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ccd01,ccd02,ccd03 FROM ccd_file WHERE ccd01= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_ccd WITHOUT DEFAULTS FROM s_ccd.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac) 
          END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ccd_t.* = g_ccd[l_ac].*  #BACKUP
               #FUN-AC0050-add-start--
               FOR l_i=1 TO g_rec_b
                  LET g_ccd_tt[l_i].* = g_ccd[l_i].*
               END FOR
               #FUN-AC0050-add-end--
#No.FUN-570110--begin                                                           
               LET g_before_input_done = FALSE                                  
               CALL i020_set_entry_b(p_cmd)                                     
               CALL i020_set_no_entry_b(p_cmd)                                  
               LET g_before_input_done = TRUE                                   
#No.FUN-570110--end   
               BEGIN WORK
 
               OPEN i020_bcl USING g_ccd_t.ccd01
               IF STATUS THEN
                  CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i020_bcl INTO g_ccd[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ccd_t.ccd01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF 
         {  SELECT ccdacti,ccduser,ccdgrup,ccddate,ccdmodu 
              INTO g_ccdacti,g_ccduser,g_ccdgrup,g_ccddate,g_ccdmodu 
              FROM ccd_file WHERE ccd01 = g_ccd[l_ac].ccd01 
            IF cl_null(g_ccdacti) THEN LET g_ccdacti = 'Y'    END IF 
            IF cl_null(g_ccduser) THEN LET g_ccduser = g_user END IF 
            IF cl_null(g_ccduser) THEN LET g_            IF cl_null(g_ccduser) THEN LET g_ccd.            IF cl_null(g_ccduser) THEN LET g_ccdoriu = g_user #FUN-980030
            IF cl_null(g_ccduser) THEN LET g_            IF cl_null(g_ccduser) THEN LET g_ccd.            IF cl_null(g_ccduser) THEN LET g_ccdorig = g_grup #FUN-980030
            #使用者所屬群
            IF cl_null(g_ccdgrup) THEN LET g_ccdgrup = g_grup END IF
            IF cl_null(g_ccddate) THEN LET g_ccddate = g_today END IF 
            DISPLAY  g_ccduser,g_ccdgrup,g_ccddate,g_ccdmodu 
                 TO    ccduser,  ccdgrup,  ccddate ,  ccdmodu 
         }
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i020_set_entry_b(p_cmd)                                        
            CALL i020_set_no_entry_b(p_cmd)                                     
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end      
            INITIALIZE g_ccd[l_ac].* TO NULL      #900423
            LET g_ccd_t.* = g_ccd[l_ac].*         #新輸入資料
            LET g_ccd[l_ac].ccd03 = 'N'           #no.7383
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ccd01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
#           CALL g_ccd.deleteElement(l_ac)   # 重要
#           IF g_rec_b != 0 THEN
#             LET g_action_choice = "detail"
#           END IF
#           EXIT INPUT
         END IF
         INSERT INTO ccd_file(ccd01,ccd02,ccd03,
                              ccdacti,ccduser,ccdgrup,ccdmodu,
                              ccddate,ccdoriu,ccdorig)
         VALUES(g_ccd[l_ac].ccd01,g_ccd[l_ac].ccd02,
                g_ccd[l_ac].ccd03,
                g_ccdacti,g_ccduser,
                g_ccdgrup,g_ccdmodu,g_ccddate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_ccd[l_ac].ccd01,SQLCA.sqlcode,0)   #No.FUN-660127
             CALL cl_err3("ins","ccd_file",g_ccd[l_ac].ccd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD ccd01                        #check 編號是否重複
            IF NOT cl_null(g_ccd[l_ac].ccd01) THEN
               IF g_ccd[l_ac].ccd01 != g_ccd_t.ccd01 OR
                 (g_ccd[l_ac].ccd01 IS NOT NULL AND g_ccd_t.ccd01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM ccd_file
                   WHERE ccd01 = g_ccd[l_ac].ccd01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_ccd[l_ac].ccd01 = g_ccd_t.ccd01
                     NEXT FIELD ccd01
                  END IF
               END IF
#No.TQC-790064--begin--   成本階數不能小于0
               IF g_ccd[l_ac].ccd01 <0 THEN 
                  CALL cl_err('','axc-207',1)
                  NEXT FIELD ccd01
               END IF
#No.TQC-790064--end--
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ccd_t.ccd01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM ccd_file WHERE ccd01 = g_ccd_t.ccd01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ccd_t.ccd01,SQLCA.sqlcode,0)   #No.FUN-660127
                   CALL cl_err3("del","ccd_file",g_ccd_t.ccd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   ROLLBACK WORK 
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i020_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ccd[l_ac].* = g_ccd_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ccd[l_ac].ccd01,-263,1)
              LET g_ccd[l_ac].* = g_ccd_t.*
           ELSE
                        UPDATE ccd_file SET ccd01= g_ccd[l_ac].ccd01,
                                            ccd02= g_ccd[l_ac].ccd02,
                                            ccd03= g_ccd[l_ac].ccd03,
                                            ccdmodu = g_ccdmodu,
                                            ccddate = g_ccddate
                         WHERE CURRENT OF i020_bcl
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ccd[l_ac].ccd01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","ccd_file",g_ccd[l_ac].ccd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET g_ccd[l_ac].* = g_ccd_t.*
              ELSE
                  DISPLAY  g_ccdmodu,g_ccddate
                       TO    ccdmodu,  ccddate
                  MESSAGE 'UPDATE O.K'
                  CLOSE i020_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_ccd[l_ac].* = g_ccd_t.*                                    
               #FUN-D40030---add---str---
               ELSE
                  CALL g_ccd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
           #FUN-AC0050-add-start--
               IF p_u = 'u' THEN
                  FOR l_i = 1 TO g_rec_b
                     LET g_ccd[l_i].* = g_ccd_tt[l_i].*
                  END FOR
               END IF
           #FUN-AC0050-add-send--
               CLOSE i020_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i020_bcl                                                      
            COMMIT WORK            
 

        ON ACTION CONTROLN
            CALL i020_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ccd01) AND l_ac > 1 THEN
                LET g_ccd[l_ac].* = g_ccd[l_ac-1].*
                NEXT FIELD ccd01
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()

        #FUN-AC0050-add-start--
        ON ACTION rework 
           CALL i020_rwork('1') RETURNING p_u

        ON ACTION unrework
           CALL i020_rwork('0') RETURNING p_u
        #FUN-AC0050-add-end--
 
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
 
    CLOSE i020_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i020_b_askkey()
    CLEAR FORM
    CALL g_ccd.clear()
    CONSTRUCT g_wc2 ON ccd01,ccd02,ccd03
            FROM s_ccd[1].ccd01,s_ccd[1].ccd02,s_ccd[1].ccd03  
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ccduser', 'ccdgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i020_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT ccd01,ccd02,ccd03",
        " FROM ccd_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i020_pb FROM g_sql
    DECLARE ccd_curs CURSOR FOR i020_pb
 
    CALL g_ccd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ccd_curs INTO g_ccd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_ccd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ccd TO s_ccd.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-AC0050-add-start--
FUNCTION i020_rwork(p_f)
   DEFINE p_f  STRING
   DEFINE p_u LIKE type_file.chr1
   DEFINE l_ccd03 LIKE ccd_file.ccd03
   LET p_u = 'u'
   FOR l_i=1 TO g_rec_b
      IF p_f = '0' THEN
         LET g_ccd[l_i].ccd03 = 'N'
      ELSE
         LET g_ccd[l_i].ccd03 = 'Y'
      END IF
      UPDATE ccd_file
         SET ccd03 = g_ccd[l_i].ccd03,
           ccdmodu = g_ccdmodu,
           ccddate = g_ccddate
       WHERE ccd01 = g_ccd[l_i].ccd01
   END FOR
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ccd_file",g_ccd[l_i].ccd01,"",SQLCA.sqlcode,"","",1)
       LET g_ccd[l_ac].* = g_ccd_t.*
   ELSE
       DISPLAY  g_ccdmodu,g_ccddate
            TO    ccdmodu,  ccddate
       MESSAGE 'UPDATE O.K'
   END IF
   RETURN p_u
END FUNCTION

#FUN-AC0050-add-end--

#NO.FUN-7C0043---Begin
FUNCTION i020_out()
#    DEFINE
#        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
#        l_ccd   RECORD LIKE ccd_file.*,
#        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),               #
#        l_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc2) THEN                                                                                                         
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
     END IF                                                                                                                         
     LET l_cmd = 'p_query "axci020" "',g_wc2 CLIPPED,'"'                                                                            
     CALL cl_cmdrun(l_cmd)     
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN
#       LET g_wc2=" ccd01='",g_ccd[l_ac].ccd01,"'" END IF
#   IF cl_null(g_wc2) THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
#No.TQC-710076 -- end --
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
#    CALL cl_wait()
#   LET l_name = 'axci020.out'
#   CALL cl_outnam('axci020') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ccd_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i020_co CURSOR FOR i020_p1
 
#   START REPORT i020_rep TO l_name
 
#   FOREACH i020_co INTO l_ccd.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i020_rep(l_ccd.*)
#   END FOREACH
 
#   FINISH REPORT i020_rep
 
#   CLOSE i020_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i020_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1) 
#       sr RECORD LIKE ccd_file.*,
#       l_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ccd01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    No.TQC-6B0007
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   # No.TQC-6B0007
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#       ON EVERY ROW
#           IF sr.ccdacti = 'N' THEN PRINT '*'; END IF
#            PRINT COLUMN g_c[31],sr.ccd01 USING "##########",#No.TQC-5C0030 #No.TQC-6B0007
#           PRINT COLUMN g_c[31],sr.ccd01 USING "#######&",    #No.TQC-6B0007
#                 COLUMN g_c[32],sr.ccd02,
#                 COLUMN g_c[33],sr.ccd03
#       ON LAST ROW
#           IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#              CALL cl_wcchp(g_wc2,'ccd01,ccd02')
#                   RETURNING g_sql
#               PRINT g_dash1   #No.TQC-6B0007
#              PRINT g_dash   #No.TQC-6B0007
#           #TQC-630166
#           {
#              IF g_sql[001,080] > ' ' THEN
#       	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#              IF g_sql[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#              IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           }
#             CALL cl_prt_pos_wc(g_sql)
#           #END TQC-630166
 
#           END IF
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6]  #No.TQC-6B0007
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7]  #No.TQC-6B0007
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[7] #No.TQC-6B0007
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6]  #No.TQC-6B0007
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043---END
#No.FUN-570110--begin                                                           
FUNCTION i020_set_entry_b(p_cmd)                                                
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ccd01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i020_set_no_entry_b(p_cmd)                                             
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ccd01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570110--end         
