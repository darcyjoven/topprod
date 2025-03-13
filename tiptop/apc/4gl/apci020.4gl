# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: apci020.4gl
# Descriptions...: POS傳輸營運中心維護作業 
# Date & Author..: 10/03/25 By Cockroach 
# Modify.........: No:FUN-A30091 10/03/25 By Cockroach
# Modify.........: No:FUN-A30116 10/05/12 By Cockroach  增加新增按鈕等
# Modify.........: No:FUN-C50017 12/06/11 By yangxf 添加控管，營運中心必須是arti200中已確認的營運中心
# Modify.........: No:FUN-C50017 12/07/25 By yangxf 添加全部选择，全部取消按钮，已经新增时开窗可以多选
# Modify.........: No.FUN-C80045 12/08/16 By nanbing 增加ryz10控管
# Modify.........: No.FUN-C90039 12/09/10 By baogc 分佈上傳時營運中心判斷邏輯調整
# Modify.........: No.TQC-D20003 13/02/05 By pauline 開窗多選新增時未給予ryg02值導致新增錯誤
# Modify.........: No.FUN-D30017 13/03/14 By xumm 单头dblink不可维护
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_ryg   DYNAMIC ARRAY OF RECORD
                   ryg01       LIKE ryg_file.ryg01,
                   ryg01_desc  LIKE azw_file.azw08,
                  #ryg02       LIKE ryg_file.ryg02,
                   rygacti     LIKE ryg_file.rygacti 
                        END RECORD,
        g_ryg_t RECORD
                   ryg01       LIKE ryg_file.ryg01,
                   ryg01_desc  LIKE azw_file.azw08,
                  #ryg02       LIKE ryg_file.ryg02,
                   rygacti     LIKE ryg_file.rygacti 
                        END RECORD
DEFINE  g_ryg00   LIKE ryg_file.ryg00            
DEFINE  g_ryg00_t LIKE ryg_file.ryg00            
DEFINE  g_ryg02   LIKE ryg_file.ryg02
DEFINE  g_ryg02_t LIKE ryg_file.ryg02
DEFINE  g_sql      STRING,
        g_wc       STRING,
        g_rec_b    LIKE type_file.num5,
        l_ac       LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  l_sql           LIKE type_file.chr1000
DEFINE  g_argv1         LIKE type_file.chr1000
DEFINE  g_n,n           LIKE type_file.num10
DEFINE  g_before_input_done LIKE type_file.num5 
DEFINE  g_multi_ryg01   STRING

MAIN
        OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    WHENEVER ERROR CALL cl_err_msg_log

    LET g_argv1 = ARG_VAL(1)
    LET g_ryg00 = g_argv1

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    IF (NOT cl_setup("APC")) THEN
       EXIT PROGRAM
    END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 12 LET p_col = 40
    OPEN WINDOW apci020_w AT p_row,p_col WITH FORM "apc/42f/apci020"
     ATTRIBUTE(STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

   #DISPLAY g_pos TO FORMONLY.ryg00
    LET g_wc = "1=1"           #FUN-A30116 ADD
    CALL i020_b_fill(g_wc)     #FUN-A30116 ADD

    CALL i020_menu()

    CLOSE WINDOW i020_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i020_menu()
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
        #FUN-A30116 ADD---------------
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ryg00) THEN 
                  LET g_action_choice="detail"
                  CALL i020_b()
               ELSE
                  CALL i020_a()
               END IF
            END IF
        #FUN-A30116 END---------------
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i020_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         #WHEN "output"
         #   IF cl_chk_act_auth() THEN
         #      CALL i020_out()
         #   END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_ryg[l_ac].ryg01 IS NOT NULL THEN
                  LET g_doc.column1 = "ryg01"
                  LET g_doc.value1 = g_ryg[l_ac].ryg01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryg),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ''

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_ryg TO s_ryg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

      ON ACTION insert    #FUN-A30116 ADD
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
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

#FUN-C70015 add begin ---
      ON ACTION selectall
         LET g_action_choice="selectall"
         IF cl_chk_act_auth() THEN
            CALL i020_yn('Y')
         END IF

      ON ACTION cancelall
         LET g_action_choice="cancelall"
         IF cl_chk_act_auth() THEN
            CALL i020_yn('N')
         END IF
#FUN-C70015 add end -----

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

FUNCTION i020_q()

   CALL i020_b_askkey()

END FUNCTION

FUNCTION i020_b_askkey()

    CLEAR FORM
    CALL g_ryg.clear()
#   LET g_ryg00 = g_argv1       
#   DISPLAY g_ryg00 TO ryg00

    CONSTRUCT g_wc ON ryg00,ryg02,ryg01,rygacti
         FROM ryg00,ryg02,s_ryg[1].ryg01,s_ryg[1].rygacti

        BEFORE CONSTRUCT
          CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(ryg01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryg01"
                 LET g_qryparam.state = "c"
                #LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryg01
                 NEXT FIELD ryg01      
              OTHERWISE
                 EXIT CASE
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

        ON ACTION qbe_select
     	  CALL cl_qbe_select()

        ON ACTION qbe_save
          CALL cl_qbe_save()

    END CONSTRUCT
    LET g_wc=g_wc CLIPPED,cl_get_extra_cond('ryguser','ryggrup')

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_wc = NULL
        RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
  # LET g_sql="SELECT UNIQUE ryg00 FROM ryg_file",
  #           " WHERE ",g_wc CLIPPED,
  #           " ORDER BY ryg00"
  # PREPARE i020_prepare FROM g_sql
  # DECLARE i020_bcs
  #   SCROLL CURSOR WITH HOLD FOR i020_prepare

    CALL i020_b_fill(g_wc)

END FUNCTION

FUNCTION i020_b_fill(p_wc)
DEFINE   p_wc        STRING
   
    LET g_sql="SELECT UNIQUE ryg00 FROM ryg_file",
              " WHERE ",p_wc CLIPPED,
              " ORDER BY ryg00"
    PREPARE i020_prepare FROM g_sql
    DECLARE i020_bcs
      SCROLL CURSOR WITH HOLD FOR i020_prepare

    OPEN i020_bcs 
    FETCH i020_bcs INTO g_ryg00
    SELECT UNIQUE ryg02 INTO g_ryg02 FROM ryg_file
     WHERE ryg00=g_ryg00
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ryg_file",g_ryg02,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF
    DISPLAY g_ryg00 TO ryg00
    DISPLAY g_ryg02 TO ryg02
    CLOSE i020_bcs

    LET g_sql = "SELECT ryg01,'',rygacti FROM ryg_file ",
                " WHERE ",p_wc CLIPPED,
                " ORDER BY ryg01"

    PREPARE i020_pb FROM g_sql
    DECLARE b_ryg_cs CURSOR FOR i020_pb

    CALL g_ryg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH b_ryg_cs INTO g_ryg[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH
        END IF
        CALL i020_get_azw08(g_ryg[g_cnt].ryg01)
                   RETURNING g_ryg[g_cnt].ryg01_desc
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_ryg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    CALL i020_bp_refresh()
END FUNCTION

FUNCTION i020_a()                                                               
   MESSAGE ""                                                                   
   CLEAR FORM                                                                   
   CALL g_ryg.clear()

   IF s_shut(0) THEN RETURN END IF
   
   LET g_ryg00  =NULL
   LET g_ryg00_t=NULL
   LET g_ryg02  =NULL
   LET g_ryg02_t=NULL

   CALL cl_opmsg('a')                                                           
                                                                                
    WHILE TRUE                                                            
       CALL i020_i("a")
       IF INT_FLAG THEN
          LET INT_FLAG = 0                                                      
          CALL cl_err('',9001,0)   
          CLEAR FORM                                              
          EXIT WHILE                                                            
       END IF                     
       IF cl_null(g_ryg00) THEN                                                 
          CONTINUE WHILE                                                        
       END IF                
      #IF SQLCA.sqlcode THEN                                                    
      #   ROLLBACK WORK                                                         
      #   CALL cl_err(g_ryg00,SQLCA.sqlcode,1)                                  
      #   CONTINUE WHILE                                                        
      #ELSE                                                                     
      #   COMMIT WORK                                                           
      #END IF
 
       CALL g_ryg.clear()                                                       
       LET g_rec_b = 0                                                          
       DISPLAY g_rec_b TO FORMONLY.cn2                                          
                                                                                
       CALL i020_b()                                     
       IF SQLCA.sqlcode THEN 
           CALL cl_err(g_ryg00,SQLCA.sqlcode,0)
       END IF
     # IF g_flag = 'Y' THEN   #FUN-9C0048
     #    CALL i931_b2()   #FUN-9C0048
     #    CALL i931_b3()   #FUN-9C0048
     # END IF              #FUN-9C0048
                                                                                
       LET g_ryg00_t = g_ryg00                                
       EXIT WHILE                                                               
    END WHILE                                                                   
    LET g_wc=' ' 
                                                    
END FUNCTION  

FUNCTION i020_u()
 DEFINE l_n   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF

   IF cl_null(g_ryg00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK 
    WHILE TRUE
       LET g_ryg02_t=g_ryg02
        CALL i020_i("u")
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ryg02=g_ryg02_t
           DISPLAY g_ryg02 TO ryg02
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
      
        IF g_ryg02<>g_ryg02_t THEN
           IF cl_null(g_ryg02) THEN LET g_ryg02=' ' END IF
           UPDATE ryg_file SET ryg02  = g_ryg02,
                               rygmodu= g_user,          
                               rygdate= g_today
            WHERE ryg00=g_ryg00
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","ryg_file",g_ryg02,"",SQLCA.sqlcode,"","",1)
              CONTINUE WHILE
           END IF
        END IF
        EXIT WHILE
     END WHILE
   COMMIT WORK
   CALL i020_b_fill("1=1") 

END FUNCTION  
     
#######################
FUNCTION i020_i(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_n     LIKE type_file.num5

       CALL cl_set_head_visible("","YES")
    
       INPUT g_ryg00,g_ryg02 WITHOUT DEFAULTS FROM ryg00,ryg02
     
       BEFORE INPUT 
          LET g_before_input_done = FALSE
          IF p_cmd='a' THEN
             CALL cl_set_comp_entry("ryg00",TRUE)
          ELSE
             CALL cl_set_comp_entry("ryg00",FALSE)
          END IF
         #CALL cl_set_comp_entry("ryg02",TRUE)    #FUN-D30017 Mark
          CALL cl_set_comp_entry("ryg02",FALSE)   #FUN-D30017 Add
          LET g_before_input_done = TRUE
          DISPLAY g_ryg02 TO ryg02      

       AFTER FIELD ryg00
            IF NOT cl_null(g_ryg00) THEN
               CASE cl_db_get_database_type()
                  WHEN "ORA"
                     IF NOT i020_chk_ora_dbname() THEN    
                        CALL cl_err("","aoo-989",1)
                        NEXT FIELD ryg00
                     END IF
                  WHEN "IFX"
                     IF (NOT i020_get_dbname()) THEN 
                        NEXT FIELD ryg00
                     END IF
                  WHEN "MSV"
                     IF NOT i020_chk_msv_dbname() THEN 
                        CALL cl_err("","aoo-989",1)
                        NEXT FIELD ryg00
                     END IF
               END CASE
            END IF

       AFTER FIELD ryg02
          IF cl_null(g_ryg02) THEN
             LET g_ryg02=' '
             DISPLAY  g_ryg02 TO ryg02
          ELSE
             IF g_ryg02<>g_ryg02_t THEN
                SELECT COUNT(*) INTO l_n 
                  FROM all_db_links 
                 WHERE DB_LINK = g_ryg02 
               #FUN-C50017 Mark By shi
               #IF l_n = 0 OR cl_null(l_n) THEN 
               #   CALL cl_err(g_ryg02,'apc-091',1)
               #   LET g_ryg02 = g_ryg02_t
               #   DISPLAY BY NAME g_ryg02
               #   NEXT FIELD ryg02
               #END IF
             END IF
          END IF

       AFTER INPUT 
          IF INT_FLAG THEN EXIT INPUT END IF

          IF cl_null(g_ryg00) THEN    #FUN-A30116 ADD
             CALL cl_err(g_ryg00,'ask-014',1)
             LET g_ryg00 = g_ryg00_t
             NEXT FIELD ryg00
          END IF

          IF cl_null(g_ryg02) THEN 
             LET g_ryg02=' '
          END IF
   
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
     
          ON ACTION CONTROLO              
             IF INFIELD(ryg02) THEN
                LET g_ryg02 = g_ryg02_t
                DISPLAY BY NAME g_ryg02
                NEXT FIELD ryg02
             END IF

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
     
     
       END INPUT                 

#######################
 
END FUNCTION


FUNCTION i020_b()
DEFINE
    l_ac_t,li_cnt   LIKE type_file.num5,                #未取消的ARRAY CNT SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  VARCHAR(1)
    l_cnt           LIKE type_file.num10,               # INTEGER
    l_flag          LIKE type_file.chr1                 #check DBlink name
DEFINE 
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE l_ryz10      LIKE ryz_file.ryz10   #FUN-C80045 add
DEFINE l_ryg03      LIKE ryg_file.ryg03   #FUN-C80045 add
    
    LET g_action_choice = ""
    IF cl_null(g_ryg00) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT ryg01,'',rygacti",
                       "  FROM ryg_file WHERE ",
                       " ryg00 = '",g_ryg00 CLIPPED,"' AND ryg01=? FOR UPDATE"

    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_ryg WITHOUT DEFAULTS FROM s_ryg.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
          #LET g_ryg00_t = g_ryg00              #BACKUP中間傳輸DB
          #LET g_ryg02_t = g_ryg02        
           LET g_ryg_t.* = g_ryg[l_ac].*  #BACKUP

           OPEN i020_bcl USING g_ryg_t.ryg01
           IF STATUS THEN
              CALL cl_err("OPEN i020_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
              FETCH i020_bcl INTO g_ryg[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ryg_t.ryg01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              CALL i020_get_azw08(g_ryg[l_ac].ryg01)
                   RETURNING g_ryg[l_ac].ryg01_desc
           END IF
           CALL cl_show_fld_cont()
        END IF


     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ryg[l_ac].* TO NULL
         LET g_ryg[l_ac].rygacti = 'Y'
        #LET g_ryg00_t = g_ryg00                      #BACKUP中間傳輸DB
        #LET g_ryg02_t = g_ryg02    
         LET g_ryg_t.* = g_ryg[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD ryg01

     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i020_bcl
           CANCEL INSERT
        END IF

        BEGIN WORK
        LET l_sql ="INSERT INTO ryg_file(ryg00,ryg01,ryg02,rygacti,rygcrat,ryggrup,ryguser,rygorig,rygoriu,ryg03) ", #FUN-C80045 add ryg03
                  " VALUES(?,?,?,?,? ,?,?,?,?,?)" #FUN-C80045 add ?
        PREPARE ins_pre FROM l_sql
        EXECUTE ins_pre USING
            g_ryg00,g_ryg[l_ac].ryg01,g_ryg02,
            g_ryg[l_ac].rygacti,g_today,g_grup,g_user,g_grup,g_user,'' #FUN-C80045 add ''
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","ryg_file",g_ryg[l_ac].ryg01,"",SQLCA.sqlcode,"","",1)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT Ok'
           COMMIT WORK
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b To FORMONLY.cn2
        END IF

     AFTER FIELD ryg01
        IF NOT cl_null(g_ryg[l_ac].ryg01) THEN 
           IF g_ryg_t.ryg01 IS NULL OR g_ryg[l_ac].ryg01<>g_ryg_t.ryg01 THEN
              CALL i020_chk_azw01(g_ryg[l_ac].ryg01,p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ryg[l_ac].ryg01,g_errno,1)
                 LET g_ryg[l_ac].ryg01 = g_ryg_t.ryg01
                 DISPLAY BY NAME g_ryg[l_ac].ryg01
                 NEXT FIELD ryg01
              ELSE
                 #FUN-C80045 add sta
                 CALL i020_chk_ryz10(g_ryg[l_ac].ryg01,p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ryg[l_ac].ryg01,g_errno,1)
                    LET g_ryg[l_ac].ryg01 = g_ryg_t.ryg01
                    DISPLAY BY NAME g_ryg[l_ac].ryg01
                    NEXT FIELD ryg01
                 ELSE
                 #FUN-C80045 add end
                    CALL i020_get_azw08(g_ryg[l_ac].ryg01)
                      RETURNING g_ryg[l_ac].ryg01_desc
                    DISPLAY BY NAME g_ryg[l_ac].ryg01_desc
                 END IF #FUN-C80045 add   
              END IF
           END IF
        END IF

#    AFTER FIELD ryg02         
#       IF NOT cl_null(g_ryg[l_ac].ryg02) THEN
#          IF g_ryg_t.ryg02 IS NULL OR g_ryg[l_ac].ryg02<>g_ryg_t.ryg02 THEN
#             SELECT COUNT(*) INTO li_cnt 
#               FROM dba_db_links 
#              WHERE DB_LINK = g_ryg[l_ac].ryg02 
#             IF li_cnt = 0 OR cl_null(li_cnt) THEN 
#                CALL cl_err(g_ryg[l_ac].ryg02,'apc-091',1)
#                LET g_ryg[l_ac].ryg02 = g_ryg_t.ryg02
#                DISPLAY BY NAME g_ryg[l_ac].ryg02
#                NEXT FIELD ryg02
#             END IF
#          END IF
#       END IF

     BEFORE DELETE
           IF g_rec_b>=l_ac THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              #FUN-C80045 add sta
              SELECT ryz10 INTO l_ryz10 FROM ryz_file
              IF l_ryz10 = 'Y' THEN 
                 SELECT ryg03 INTO l_ryg03 FROM ryg_file
                  WHERE ryg01 = g_ryg_t.ryg01
                 IF NOT cl_null(l_ryg03) THEN 
                    CALL cl_err('','apc1034',0) 
                    CANCEL DELETE 
                 END IF 
              END IF    
              #FUN-C80045 add end
              LET l_sql ="DELETE FROM ryg_file",
                         " WHERE ryg00 = '",g_ryg00 CLIPPED,"'",       
                         " AND ryg01 ='", g_ryg_t.ryg01,"'"
              PREPARE del_pre FROM l_sql
              EXECUTE del_pre
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ryg_file",g_ryg_t.ryg01,"",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

     ON CHANGE ryg01
           CALL i020_chk_azw01(g_ryg[l_ac].ryg01,'c')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_ryg[l_ac].ryg01,g_errno,1)
              LET g_ryg[l_ac].* = g_ryg_t.*
              NEXT FIELD ryg01
           END IF

     ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ryg[l_ac].* = g_ryg_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ryg[l_ac].ryg01,-263,1)
              LET g_ryg[l_ac].* = g_ryg_t.*
           ELSE
            # LET l_sql ="UPDATE ryg_file SET ryg01 ='",
            #            g_ryg[l_ac].ryg01 CLIPPED,"',rygacti = '",
            #            g_ryg[l_ac].rygacti,"'",
            #            " WHERE ryg00='",g_ryg00 CLIPPED,"'",       
            #            " AND ryg01='",g_ryg_t.ryg01 CLIPPED,"'"
            # PREPARE upd_pre FROM l_sql
            # EXECUTE upd_pre
              UPDATE ryg_file SET ryg01=g_ryg[l_ac].ryg01,
                                  rygacti=g_ryg[l_ac].rygacti,
                                  rygmodu=g_user,
                                  rygdate=g_today
               WHERE ryg00=g_ryg00 AND ryg01=g_ryg_t.ryg01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ryg_file",g_ryg_t.ryg01,"",SQLCA.sqlcode,"","",1)
                 LET g_ryg[l_ac].* = g_ryg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ryg[l_ac].* = g_ryg_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_ryg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i020_bcl
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(ryg01) AND l_ac > 1 THEN
              LET g_ryg[l_ac].* = g_ryg[l_ac-1].*
              CALL i020_bp_refresh()
              NEXT FIELD ryg01
           END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(ryg01)
                 CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_azw"                          #FUN-C50017 MARK
                 LET g_qryparam.form = "q_azw01_3"                      #FUN-C50017 add
                 LET g_qryparam.default1 = g_ryg[l_ac].ryg01
                #FUN-C50017 add begin ----
                 IF p_cmd = 'a' THEN
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " azw01 NOT IN (SELECT ryg01 FROM ryg_file WHERE ryg00 = '",g_ryg00,"')"
                    CALL cl_create_qry() RETURNING g_multi_ryg01
                    IF NOT cl_null(g_multi_ryg01) THEN
                        CALL i020_ryg01_m()
                        CALL i020_b_fill( "1=1")
                        CALL i020_b()
                        EXIT INPUT
                    END IF
                 ELSE
                #FUN-C50017 add end ---
                    CALL cl_create_qry() RETURNING g_ryg[l_ac].ryg01
                    DISPLAY BY NAME g_ryg[l_ac].ryg01
                 END IF                                                      #FUN-C50017 add 
                 NEXT FIELD ryg01
              OTHERWISE
                 EXIT CASE
           END CASE

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
    END INPUT

    CLOSE i020_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i020_bp_refresh()

  DISPLAY ARRAY g_ryg TO s_ryg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION i020_get_azw08(p_ryg01)
DEFINE l_sql       LIKE type_file.chr1000
DEFINE p_ryg01    LIKE type_file.chr10,
       l_azw08     LIKE azw_file.azw08

   IF cl_null(p_ryg01) THEN
      RETURN NULL
   ELSE
      LET l_sql ="SELECT azw08 FROM azw_file",
                 " WHERE azw01 = '", p_ryg01,"'"
      PREPARE  i020_pre1 FROM l_sql
      DECLARE  i020_cs1 CURSOR FOR i020_pre1
      OPEN i020_cs1
      IF SQLCA.sqlcode THEN
         CALL cl_err(p_ryg01,SQLCA.sqlcode,1)
         RETURN
      END IF
      FETCH i020_cs1 INTO l_azw08
      RETURN l_azw08
      CLOSE i020_cs1
   END IF
END FUNCTION

FUNCTION i020_chk_azw01(p_ryg01,p_cmd)
DEFINE l_sql       LIKE type_file.chr1000
DEFINE l_cnt       LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr1                #處理狀態  
DEFINE p_ryg01    LIKE type_file.chr10
DEFINE l_azw01     LIKE azw_file.azw01
DEFINE l_rtz28     LIKE rtz_file.rtz28     #FUN-C50017 add
   LET g_errno=''
   IF NOT cl_null(p_ryg01) THEN
#FUN-C50017 MARK BEGIN ---
#      LET l_sql ="SELECT azw01 FROM azw_file",
#                  "   WHERE azw01 = '", p_ryg01,"'"
#      PREPARE  i020_pre2 FROM l_sql
#      DECLARE  i020_cs2 CURSOR FOR  i020_pre2
#      OPEN i020_cs2
#      FETCH i020_cs2 INTO l_azw01
#      IF SQLCA.sqlcode=100 THEN
#          LET g_errno='apc-003'
#      END IF
#      CLOSE i020_cs2
#FUN-C50017 MARK END -----
#FUN-C50017 ADD BEGIN ---
      SELECT azw01,rtz28 INTO l_azw01,l_rtz28
        FROM azw_file,rtz_file
       WHERE azw01 = p_ryg01 
         AND azw01 = rtz01
      CASE 
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'apc-003'
         WHEN l_rtz28 <> 'Y'      LET g_errno = 'apc-197'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) THEN
#FUN-C50017 ADD END -----
         LET l_cnt = 0
         LET l_sql ="SELECT COUNT(ryg01) FROM ryg_file",
                     "   WHERE ryg01 = '", p_ryg01,"'",
                     "   AND ryg00='",g_ryg00 CLIPPED,"'"       
         PREPARE  i020_pre3 FROM l_sql
         DECLARE  i020_cs3 CURSOR FOR  i020_pre3
         OPEN i020_cs3
         FETCH i020_cs3 INTO l_cnt
         IF l_cnt > 0 AND (p_cmd = 'a' OR p_cmd = 'c') THEN
             LET g_errno='apc-005'
         END IF
         CLOSE i020_cs3
      END IF    #FUN-C50017 add
   END IF
END FUNCTION
#FUN-A30091 ADD

#FUN-C80045 add
FUNCTION  i020_chk_ryz10(p_ryg01,p_cmd)
DEFINE l_sql         LIKE type_file.chr1000
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_ryz03       LIKE ryz_file.ryz03
DEFINE l_ryz10       LIKE ryz_file.ryz10
DEFINE l_ryg01       STRING
DEFINE p_ryg01       LIKE ryg_file.ryg01
DEFINE p_cmd         LIKE type_file.chr1

    LET g_errno = ''
    SELECT ryz03,ryz10 INTO l_ryz03,l_ryz10 FROM ryz_file 
    IF l_ryz10 = 'Y' THEN
       LET l_cnt = 0 
       LET l_ryg01 = p_ryg01[1,l_ryz03]  
       LET l_sql = "SELECT COUNT(ryg01) FROM ryg_file ",
                   " WHERE ryg01[1,",l_ryz03,"] = '",l_ryg01,"'"
       IF p_cmd = 'u' THEN
          LET l_sql = l_sql CLIPPED," AND ryg01 <> '",g_ryg_t.ryg01,"' "
       END IF
       PREPARE ryg01_p1 FROM l_sql
       EXECUTE ryg01_p1 INTO l_cnt
       IF l_cnt > 0 THEN 
          LET g_errno = 'apc1029'
       END IF
    END IF  
END FUNCTION     
#FUN-C80045 add ---          

#FUN-A30116 ADD-----------------------------
FUNCTION i020_chk_msv_dbname()   
  DEFINE ls_each  STRING
 
  LET ls_each = g_ryg00
 
  IF ls_each.getIndexOf("@",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
  IF ls_each.getIndexOf(".dbo.",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
 
END FUNCTION
 
 
FUNCTION i020_chk_ora_dbname()    # for Oracle
  DEFINE ls_each  STRING
 
  LET ls_each = g_ryg00
 
  IF ls_each.getIndexOf("@",1) THEN
     RETURN FALSE
  ELSE 
     RETURN TRUE
  END IF
 
END FUNCTION
 
FUNCTION i020_get_dbname()    
  DEFINE ls_each   STRING
  DEFINE l_dbname  LIKE azp_file.azp03
 
  LET ls_each = g_ryg00
 
  IF NOT ls_each.getIndexOf("@",1) THEN
     SELECT * FROM sysmaster:sysdatabases
      WHERE name=g_ryg00
     IF SQLCA.SQLCODE THEN
        CALL cl_err_msg(NULL,"aoo-086",g_ryg00 CLIPPED,10)
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  ELSE
     LET l_dbname = ls_each.subString(1,ls_each.getIndexOf("@",1)-1)
     SELECT * FROM sysmaster:sysdatabases
      WHERE name=l_dbname
     IF SQLCA.SQLCODE THEN
        CALL cl_err_msg(NULL,"aoo-086",g_ryg00 CLIPPED,10)
        RETURN FALSE
     ELSE
        RETURN TRUE
     END IF
  END IF
 
END FUNCTION
#FUN-A30116 ADD END--------------------------------------------------

#FUN-C50017 add begin ---
FUNCTION i020_yn(p_y)
DEFINE p_y   LIKE type_file.chr1
   BEGIN WORK
   UPDATE ryg_file SET rygacti = p_y
    WHERE ryg00 = g_ryg00
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ryg_file",g_ryg00,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF 
   CALL i020_b_fill(" 1=1")   
END FUNCTION

FUNCTION i020_ryg01_m()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_ryg       RECORD LIKE ryg_file.*
DEFINE   l_success   LIKE type_file.chr1
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ryg01,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_ryg.* TO NULL
      LET l_ryg.ryg01 = tok.nextToken()
      SELECT count(*) INTO l_n FROM ryg_file
       WHERE ryg01 = l_ryg.ryg01
         AND ryg00 = g_ryg00
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE 
        #FUN-C90039 Add Begin ---
         CALL i020_chk_ryz10(l_ryg.ryg01,'a')
         IF NOT cl_null(g_errno) THEN
            CALL s_errmsg('ryg01',l_ryg.ryg01,'Ins ryg_file',g_errno,1)
            LET l_success = 'N'
            EXIT WHILE
         END IF
        #FUN-C90039 Add End -----
         LET l_ryg.ryg00 = g_ryg00
        #LET l_ryg.ryg02 = ' '       #TQC-D20003 mark 
         LET l_ryg.ryg02 = g_ryg02   #TQC-D20003 add
         LET l_ryg.rygacti = 'Y'
         LET l_ryg.ryg03 = '' #FUN-C80045 add
         INSERT INTO ryg_file VALUES(l_ryg.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('',l_ryg.ryg01,'Ins ryg_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF
      END IF
      LET l_ac = l_ac + 1
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION
#FUN-C50017 add end -----
