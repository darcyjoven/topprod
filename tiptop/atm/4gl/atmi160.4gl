# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi160.4gl
# Descriptions...: 集團銷售預測版本維護作業
# Date & Author..: 06/02/15 By Sarah
# Modify.........: No.FUN-620032 06/02/15 By Sarah 新增"集團銷售預測版本維護作業"
# Modify.........: No.TQC-650048 06/05/12 By Sarah 出表出現Error
# Modify.........: NO.FUN-660104 06/06/15 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By Rayven '時距類型'的缺省值在字段維護中有說明，但沒有控管
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730069 07/04/11 By kim 起始日無法修改
# Modify.........: No.fun-760083 07/07/13 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0080 10/12/10 By houlia 對odb07、odb09做有效性判斷
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_odb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        odb01       LIKE odb_file.odb01,  
        odb02       LIKE odb_file.odb02,
        odb03       LIKE odb_file.odb03,
        odb04       LIKE odb_file.odb04,
        odb05       LIKE odb_file.odb05,
        odb06       LIKE odb_file.odb06,
        odb09       LIKE odb_file.odb09,
        odb07       LIKE odb_file.odb07,
        tqb02       LIKE tqb_file.tqb02,
        odb08       LIKE odb_file.odb08,
        odbacti     LIKE odb_file.odbacti
                    END RECORD,
    g_odb_t         RECORD                 #程式變數 (舊值)
        odb01       LIKE odb_file.odb01,  
        odb02       LIKE odb_file.odb02,
        odb03       LIKE odb_file.odb03,
        odb04       LIKE odb_file.odb04,
        odb05       LIKE odb_file.odb05,
        odb06       LIKE odb_file.odb06,
        odb09       LIKE odb_file.odb09,
        odb07       LIKE odb_file.odb07,
        tqb02       LIKE tqb_file.tqb02,
        odb08       LIKE odb_file.odb08,
        odbacti     LIKE odb_file.odbacti
                    END RECORD,
    g_wc2,g_sql     STRING, 
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5              #No.FUN-680120 SMALLINT
DEFINE l_table      STRING                                     #No.FUN-760083
DEFINE g_str        STRING                                     #No.FUN-760083
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
#No.FUN-760083 --BEGIN--
   LET g_sql="odb01.odb_file.odb01,",
             "odb02.odb_file.odb02,",
             "odb03.odb_file.odb03,",
             "odb04.odb_file.odb04,",
             "odb05.odb_file.odb05,",
             "odb06.odb_file.odb06,",
             "odb09.odb_file.odb09,",
             "odb07.odb_file.odb07,",
             "tqb02.tqb_file.tqb02,",
             "odb08.odb_file.odb08,",
             "odbacti.odb_file.odbacti,",
             "gae04.gae_file.gae04"
   LET l_table=cl_prt_temptable("atmi160",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
    CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083 --END--
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW i160_w AT p_row,p_col WITH FORM "atm/42f/atmi160"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i160_b_fill(g_wc2)
   CALL i160_menu()
   CLOSE WINDOW i160_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i160_menu()
 
   WHILE TRUE
      CALL i160_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i160_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i160_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i160_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_odb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i160_q()
   CALL i160_b_askkey()
END FUNCTION
 
FUNCTION i160_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680120 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
   l_m             LIKE type_file.num5,                #TQC-AC0080  
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680120 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680120 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT odb01,odb02,odb03,odb04,odb05,odb06,",
                      "       odb09,odb07,'',odb08,odbacti",
                      "  FROM odb_file WHERE odb01=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_odb WITHOUT DEFAULTS FROM s_odb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_odb_t.* = g_odb[l_ac].*  #BACKUP
            LET g_before_input_done = FALSE                                                                                      
            CALL i160_set_entry_b(p_cmd)                                                                                         
            CALL i160_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
 
            BEGIN WORK
 
            OPEN i160_bcl USING g_odb_t.odb01
            IF STATUS THEN
               CALL cl_err("OPEN i160_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i160_bcl INTO g_odb[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_odb_t.odb01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT tqb02 INTO g_odb[l_ac].tqb02
                 FROM tqb_file WHERE tqb01 = g_odb[l_ac].odb07 
            END IF
            CALL cl_show_fld_cont()    
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                                                                      
         CALL i160_set_entry_b(p_cmd)                                                                                         
         CALL i160_set_no_entry_b(p_cmd)                                                                                      
         LET g_before_input_done = TRUE                                                                                       
         INITIALIZE g_odb[l_ac].* TO NULL      
         LET g_odb_t.* = g_odb[l_ac].*         
         LET g_odb[l_ac].odb04 = '1'    #No.TQC-710043
         LET g_odb[l_ac].odb08 = 'N'
         LET g_odb[l_ac].odbacti = 'Y'
         CALL cl_show_fld_cont()     
         NEXT FIELD odb01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO odb_file(odb01,odb02,odb03,odb04,odb05,
                              odb06,odb07,odb08,odb09,odbacti)
                       VALUES(g_odb[l_ac].odb01,g_odb[l_ac].odb02,
                              g_odb[l_ac].odb03,g_odb[l_ac].odb04,
                              g_odb[l_ac].odb05,g_odb[l_ac].odb06,
                              g_odb[l_ac].odb07,g_odb[l_ac].odb08,
                              g_odb[l_ac].odb09,g_odb[l_ac].odbacti)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_odb[l_ac].odb01,SQLCA.sqlcode,0)
             CALL cl_err3("ins","odb_file",g_odb[l_ac].odb01,"",SQLCA.sqlcode,
                          "","",1)  #No.FUN-660104
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
 
      AFTER FIELD odb01                        #check 編號是否重複
         IF NOT cl_null(g_odb[l_ac].odb01) THEN 
            IF g_odb[l_ac].odb01 != g_odb_t.odb01 OR
               (g_odb[l_ac].odb01 IS NOT NULL AND g_odb_t.odb01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM odb_file
                 WHERE odb01 = g_odb[l_ac].odb01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_odb[l_ac].odb01 = g_odb_t.odb01
                   NEXT FIELD odb01
                END IF
            END IF
         END IF
 
      AFTER FIELD odb03                                                                                 
         IF NOT cl_null(g_odb[l_ac].odb03) THEN                                                                                       
            IF cl_null(g_odb[l_ac].odb05) THEN #FUN-730069
               LET g_odb[l_ac].odb05=MDY(MONTH(g_odb[l_ac].odb03),1,YEAR(g_odb[l_ac].odb03))
               DISPLAY BY NAME g_odb[l_ac].odb05 #FUN-730069
            END IF
            IF cl_null(g_odb[l_ac].odb06) THEN #FUN-730069
               LET g_odb[l_ac].odb06=MDY(1,1,YEAR(g_odb[l_ac].odb03)+1)-1
               DISPLAY BY NAME g_odb[l_ac].odb06 #FUN-730069
            END IF
         END IF  
 
      AFTER FIELD odb05                                                                                 
         IF NOT cl_null(g_odb[l_ac].odb06) AND  
            NOT cl_null(g_odb[l_ac].odb05) THEN
            IF g_odb[l_ac].odb05 > g_odb[l_ac].odb06 THEN
               CALL cl_err('','mfg6164',1)
               NEXT FIELD odb05
            END IF
         END IF
 
      AFTER FIELD odb06                                                                                 
         IF NOT cl_null(g_odb[l_ac].odb06) AND  
            NOT cl_null(g_odb[l_ac].odb05) THEN
            IF g_odb[l_ac].odb05 > g_odb[l_ac].odb06 THEN
               CALL cl_err('','mfg6164',1)
               NEXT FIELD odb06
            END IF
         END IF
 
      AFTER FIELD odb07
         IF NOT cl_null(g_odb[l_ac].odb07) THEN  
            #TQC-AC0080 --add
            SELECT count(*) INTO l_m FROM tqb_file 
             WHERE tqb01=g_odb[l_ac].odb07
               AND tqbacti='Y'
            IF l_m <= 0 THEN 
               CALL cl_err('','odb-001',0)
               LET g_odb[l_ac].odb07 = g_odb_t.odb07
               NEXT FIELD odb07
            END IF 
            #TQC-AC0080 --end
            SELECT tqb02 INTO g_odb[l_ac].tqb02 FROM tqb_file 
             WHERE tqb01=g_odb[l_ac].odb07
            IF cl_null(g_odb[l_ac].tqb02) THEN LET g_odb[l_ac].tqb02 = '' END IF
            DISPLAY BY NAME g_odb[l_ac].tqb02
         END IF
      
#TQC-AC0080 --add
      AFTER FIELD odb09
         IF NOT cl_null(g_odb[l_ac].odb09) THEN
            SELECT count(*) INTO l_m FROM azi_file
             WHERE azi01=g_odb[l_ac].odb09
               AND aziacti='Y'
            IF l_m <= 0 THEN
               CALL cl_err('','odb-002',0)
               LET g_odb[l_ac].odb09 = g_odb_t.odb09
               NEXT FIELD odb09
            END IF
         END IF
#TQC-AC0080 --end
                                                                                 
      AFTER FIELD odbacti                                                         
         IF NOT cl_null(g_odb[l_ac].odbacti) THEN                                   
            IF g_odb[l_ac].odbacti NOT MATCHES'[yYnN]' THEN                         
               NEXT FIELD odbacti                                                 
            END IF                                                                
         END IF   
 
      BEFORE DELETE                            #是否取消單身
         IF g_odb_t.odb01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM odb_file WHERE odb01 = g_odb_t.odb01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_odb_t.odb01,SQLCA.sqlcode,0)
                CALL cl_err3("del","odb_file",g_odb_t.odb01,"",SQLCA.sqlcode,
                             "","",1)  #No.FUN-660104
                ROLLBACK WORK
                CANCEL DELETE 
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2 
             MESSAGE "Delete OK"
             CLOSE i160_bcl
             COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_odb[l_ac].* = g_odb_t.*
            CLOSE i160_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_odb[l_ac].odb01,-263,1)
            LET g_odb[l_ac].* = g_odb_t.*
         ELSE
            UPDATE odb_file SET odb01   = g_odb[l_ac].odb01,
                                odb02   = g_odb[l_ac].odb02,
                                odb03   = g_odb[l_ac].odb03,
                                odb04   = g_odb[l_ac].odb04,
                                odb05   = g_odb[l_ac].odb05,
                                odb06   = g_odb[l_ac].odb06,
                                odb07   = g_odb[l_ac].odb07,
                                odb08   = g_odb[l_ac].odb08,
                                odb09   = g_odb[l_ac].odb09,
                                odbacti = g_odb[l_ac].odbacti
              WHERE odb01 = g_odb_t.odb01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_odb[l_ac].odb01,SQLCA.sqlcode,0)
               CALL cl_err3("upd","odb_file",g_odb[l_ac].odb01,"",SQLCA.sqlcode,
                            "","",1)  #No.FUN-660104
               LET g_odb[l_ac].* = g_odb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i160_bcl
               COMMIT WORK
            END IF
         END IF
      
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30033 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_odb[l_ac].* = g_odb_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_odb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i160_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30033 add
         CLOSE i160_bcl
         COMMIT WORK
 
      ON ACTION CONTROLN
         CALL i160_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(odb01) AND l_ac > 1 THEN
            LET g_odb[l_ac].* = g_odb[l_ac-1].*
            NEXT FIELD odb01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP                                                      
         CASE                                                                 
             WHEN INFIELD(odb07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_tqb"
                  LET g_qryparam.default1 = g_odb[l_ac].odb07
                  CALL cl_create_qry() RETURNING g_odb[l_ac].odb07
                  DISPLAY BY NAME g_odb[l_ac].odb07
             WHEN INFIELD(odb09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_odb[l_ac].odb09
                  CALL cl_create_qry() RETURNING g_odb[l_ac].odb09
                  DISPLAY BY NAME g_odb[l_ac].odb09
         END CASE  
 
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
 
   END INPUT
 
   CLOSE i160_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i160_b_askkey()
   CLEAR FORM
   CALL g_odb.clear()
   CONSTRUCT g_wc2 ON odb01,odb02,odb03,odb04,odb05,odb06,odb09,odb07,odb08,odbacti
                 FROM s_odb[1].odb01,s_odb[1].odb02,s_odb[1].odb03,
                      s_odb[1].odb04,s_odb[1].odb05,s_odb[1].odb06,
                      s_odb[1].odb09,s_odb[1].odb07,s_odb[1].odb08,
                      s_odb[1].odbacti
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP                                                       
         CASE                                                                  
            WHEN INFIELD(odb07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqb"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_odb[l_ac].odb07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_odb[1].odb07
            WHEN INFIELD(odb09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_odb[l_ac].odb09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_odb[1].odb09
         END CASE 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
   
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
   CALL i160_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i160_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2        LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   LET g_sql =
       "SELECT odb01,odb02,odb03,odb04,odb05,odb06,odb09,odb07,tqb02,odb08,odbacti",
       "  FROM odb_file,tqb_file ",
       " WHERE odb07 = tqb01 AND ", p_wc2 CLIPPED,                     #單身
       " ORDER BY odb01"
   PREPARE i160_pb FROM g_sql
   DECLARE odb_curs CURSOR FOR i160_pb
 
   CALL g_odb.clear()
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
   FOREACH odb_curs INTO g_odb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH 
       END IF
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_odb.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odb TO s_odb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()            
 
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
         CALL cl_show_fld_cont()     
 
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i160_out()
   DEFINE
        sr              RECORD
            odb01       LIKE odb_file.odb01,
            odb02       LIKE odb_file.odb02,
            odb03       LIKE odb_file.odb03,
            odb04       LIKE odb_file.odb04,
            odb05       LIKE odb_file.odb05,
            odb06       LIKE odb_file.odb06,
            odb09       LIKE odb_file.odb09,
            odb07       LIKE odb_file.odb07,
            tqb02       LIKE tqb_file.tqb02,
            odb08       LIKE odb_file.odb08,
            odbacti     LIKE odb_file.odbacti
                        END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20          #No.FUN-680120 VARCHAR(20)         
 DEFINE l_gae04         LIKE gae_file.gae04 
   IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
   CALL cl_wait()
   CALL cl_del_data(l_table)                            #No.FUN-760083 
   LET g_str=''                                         #No.FUN-760083
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog    #No.FUN-760083
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   LET g_sql="SELECT odb01,odb02,odb03,odb04,odb05,odb06,odb09,odb07,tqb02,odb08,odbacti",
             "  FROM odb_file,tqb_file ",     
             " WHERE odb07 = tqb01 AND ",g_wc2 CLIPPED
   PREPARE i160_p1 FROM g_sql            
   DECLARE i160_co                      
       CURSOR FOR i160_p1
 
   LET g_rlang = g_lang                      
   #CALL cl_outnam('atmi160') RETURNING l_name               #No.FUN-760083
   #START REPORT i160_rep TO l_name                          #No.FUN-760083
 
   FOREACH i160_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #OUTPUT TO REPORT i160_rep(sr.*)                        #No.FUN-760083
#No.FUN-760083 --BEGIN--
      CASE sr.odb04                                                                                                              
             WHEN "1"                                                                                                               
                SELECT gae04 INTO l_gae04 FROM gae_file                                                                             
                 WHERE gae01='atmi160' AND gae02='odb04_1' AND gae03=g_lang                                                         
             WHEN "2"                                                                                                               
                SELECT gae04 INTO l_gae04 FROM gae_file                                                                             
                 WHERE gae01='atmi160' AND gae02='odb04_2' AND gae03=g_lang                                                         
             WHEN "3"                                                                                                               
                SELECT gae04 INTO l_gae04 FROM gae_file                                                                             
                 WHERE gae01='atmi160' AND gae02='odb04_3' AND gae03=g_lang                                                         
             WHEN "4"                                                                                                               
                SELECT gae04 INTO l_gae04 FROM gae_file                                                                             
                 WHERE gae01='atmi160' AND gae02='odb04_4' AND gae03=g_lang                                                         
             WHEN "5"                                                                                                               
                SELECT gae04 INTO l_gae04 FROM gae_file                                                                             
                 WHERE gae01='atmi160' AND gae02='odb04_5' AND gae03=g_lang                                                         
      END CASE                                                           
      EXECUTE insert_prep USING sr.odb01,sr.odb02,sr.odb03,sr.odb04,
                                sr.odb05,sr.odb06,sr.odb09,sr.odb07,
                                sr.tqb02,sr.odb08,sr.odbacti,l_gae04
#No.FUN-760083 --END--
   END FOREACH
 
   #FINISH REPORT i160_rep                                    #No.FUN-760083
 
   CLOSE i160_co
   ERROR ""
   #CALL cl_prt(l_name,' ','1',g_len)                         #No.FUN-760083
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #No.FUN-760083
   IF g_zz05 ='Y' THEN                                               #No.FUN-760083
      CALL cl_wcchp(g_wc2,'odb01,odb02,odb03,odb04,odb05,odb06,odb09,odb07,odb08,odbacti')   #No.FUN-760083
      RETURNING g_wc2                                                #No.FUN-760083
   END IF                                                            #No.FUN-760083
   LET g_str=g_wc2                                                   #No.FUN-760083 
   CALL cl_prt_cs3("atmi160","atmi160",g_sql,g_str)                  #No.FUN-760083 
 
END FUNCTION
 
#No.FUN-760083 --BEGIN--
{
REPORT i160_rep(sr)
   DEFINE
       sr              RECORD
           odb01       LIKE odb_file.odb01,
           odb02       LIKE odb_file.odb02,
           odb03       LIKE odb_file.odb03,
           odb04       LIKE odb_file.odb04,
           odb05       LIKE odb_file.odb05,
           odb06       LIKE odb_file.odb06,
           odb09       LIKE odb_file.odb09,
           odb07       LIKE odb_file.odb07,
           tqb02       LIKE tqb_file.tqb02,
           odb08       LIKE odb_file.odb08,
           odbacti     LIKE odb_file.odbacti
                       END RECORD,
       l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
       l_gae04         LIKE gae_file.gae04,
       l_msg           STRING
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
   ORDER BY sr.odb01
 
   FORMAT
     PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<','/pageno'
         PRINT g_head CLIPPED, pageno_total
         PRINT ''
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41] 
         PRINT g_dash1                                
         LET l_trailer_sw = 'y'
 
     ON EVERY ROW
        #start TQC-650048 modify
         CASE sr.odb04
             WHEN "1"
                SELECT gae04 INTO l_gae04 FROM gae_file
                 WHERE gae01='atmi160' AND gae02='odb04_1' AND gae03=g_lang 
             WHEN "2" 
                SELECT gae04 INTO l_gae04 FROM gae_file
                 WHERE gae01='atmi160' AND gae02='odb04_2' AND gae03=g_lang 
             WHEN "3" 
                SELECT gae04 INTO l_gae04 FROM gae_file
                 WHERE gae01='atmi160' AND gae02='odb04_3' AND gae03=g_lang 
             WHEN "4" 
                SELECT gae04 INTO l_gae04 FROM gae_file
                 WHERE gae01='atmi160' AND gae02='odb04_4' AND gae03=g_lang 
             WHEN "5" 
                SELECT gae04 INTO l_gae04 FROM gae_file
                 WHERE gae01='atmi160' AND gae02='odb04_5' AND gae03=g_lang 
         END CASE
        #end TQC-650048 modify
         LET l_msg = sr.odb04 CLIPPED,':',l_gae04 CLIPPED 
         PRINT COLUMN g_c[31],sr.odb01 CLIPPED,
               COLUMN g_c[32],sr.odb02 CLIPPED, 
               COLUMN g_c[33],sr.odb03 CLIPPED, 
               COLUMN g_c[34],l_msg CLIPPED, 
               COLUMN g_c[35],sr.odb05 CLIPPED, 
               COLUMN g_c[36],sr.odb06 CLIPPED, 
               COLUMN g_c[37],sr.odb09 CLIPPED, 
               COLUMN g_c[38],sr.odb07 CLIPPED, 
               COLUMN g_c[39],sr.tqb02 CLIPPED,
               COLUMN g_c[40],sr.odb08 CLIPPED, 
               COLUMN g_c[41],sr.odbacti CLIPPED
 
     ON LAST ROW                                                             
         PRINT g_dash[1,g_len]                                               
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED       
         LET l_trailer_sw = 'n'                                              
                                                                             
     PAGE TRAILER                                                            
         IF l_trailer_sw = 'y' THEN                                          
            PRINT g_dash[1,g_len]                                            
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    
         ELSE                                                                
            SKIP 2 LINE                                                      
         END IF                                                              
END REPORT          
}
#No.FUN-760083  --END--
 
FUNCTION i160_set_entry_b(p_cmd)                                                                                                    
   DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680120 VARCHAR(1)
                                                                                                                                     
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
      CALL cl_set_comp_entry("odb01",TRUE)                                                                                           
   END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
 
FUNCTION i160_set_no_entry_b(p_cmd)                                                                                                 
   DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("odb01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
