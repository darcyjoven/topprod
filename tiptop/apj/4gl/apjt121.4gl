# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apjt121.4gl
# Descriptions...:WBS本階人力需求維護作業 
# Date & Author..:No.FUN-790025 07/10/29 By  zhangyajun
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/07/31 By chenmoyan 單身/修改/刪除時加上專案是否'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-960083 10/11/04 By sabrina  (1)單身_b()的BEGIN WORK應拉到外面，不應放在if判斷式裡 
#                                                     (2)修改q_pjx的where判斷式
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/09/29 By Smapmin 人事table drop
# Modify.........: No:CHI-CA0060 13/02/23 By Elise TQC-B90211mark處改抓apji010
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjha01         LIKE pjha_file.pjha01,
    g_pjha01_t       LIKE pjha_file.pjha01,
    g_pjha01_o       LIKE pjha_file.pjha01,
    g_pjha           DYNAMIC ARRAY OF RECORD    
        pjha02      LIKE pjha_file.pjha02, 
        pjha03       LIKE pjha_file.pjha03, 
        #cpi02        LIKE cpi_file.cpi02,   #TQC-B90211
       #cpi02        LIKE type_file.chr100,  #TQC-B90211 #CHI-CA0060 mark
        pka02        LIKE pka_file.pka02,    #CHI-CA0060
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,  
        pjha04       LIKE pjha_file.pjha04,      
        amt          LIKE type_file.num20_6,
        pjhaacti     LIKE pjha_file.pjhaacti
                    END RECORD,
    g_pjha_t         RECORD                 
        pjha02      LIKE pjha_file.pjha02,
        pjha03       LIKE pjha_file.pjha03,  
        #cpi02        LIKE cpi_file.cpi02,    #TQC-B90211
       #cpi02        LIKE type_file.chr100,   #TQC-B90211 #CHI-CA0060 mark
        pka02        LIKE pka_file.pka02,     #CHI-CA0060
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,  
        pjha04       LIKE pjha_file.pjha04,      
        amt          LIKE type_file.num20_6,
        pjhaacti     LIKE pjha_file.pjhaacti       
                    END RECORD,
    g_pjha_o         RECORD                 
        pjha02      LIKE pjha_file.pjha02,  
        pjha03       LIKE pjha_file.pjha03, 
        #cpi02        LIKE cpi_file.cpi02,    #TQC-B90211
       #cpi02        LIKE type_file.chr100,   #TQC-B90211 #CHI-CA0060 mark
        pka02        LIKE pka_file.pka02,     #CHI-CA0060
        pjx02        LIKE pjx_file.pjx02,
        pjx03        LIKE pjx_file.pjx03,  
        pjha04       LIKE pjha_file.pjha04,      
        amt          LIKE type_file.num20_6,
        pjhaacti     LIKE pjha_file.pjhaacti
                    END RECORD,
    g_wc,g_sql    STRING,                
    g_rec_b              LIKE type_file.num5,              
    l_ac                 LIKE type_file.num5,              
    p_row,p_col          LIKE type_file.num5                        
 
DEFINE g_forupd_sql         STRING                   #SELECT ... FOR UPDATE SQL        
DEFINE g_sql_tmp            STRING                  
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_chr                LIKE type_file.chr1 
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000    
DEFINE g_row_count          LIKE type_file.num10     
DEFINE g_curs_index         LIKE type_file.num10     
DEFINE g_jump               LIKE type_file.num10     
DEFINE mi_no_ask            LIKE type_file.num5      
DEFINE g_argv1              LIKE pjha_file.pjha01
DEFINE g_argv2              LIKE pjha_file.pjha02
DEFINE g_str                STRING 
 
MAIN
DEFINE
   p_row,p_col              LIKE type_file.num5     
 
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT  
                         
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time              
 
   LET p_row = 4 LET p_col = 6
   OPEN WINDOW t121_w AT p_row,p_col      
     WITH FORM "apj/42f/apjt121"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_pjha01 = g_argv1
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
      LET g_wc=g_wc,"pjha01 = '",g_argv1 CLIPPED,"'"
    LET g_action_choice="query"
    IF cl_chk_act_auth() THEN
       CALL t121_q()
    END IF
    IF g_rec_b<=0 THEN
       LET g_pjha01 = g_argv1
       CALL t121_show()
       LET l_ac = g_rec_b + 1
       LET g_action_choice="detail"
       IF cl_chk_act_auth() THEN
          CALL t121_b()
       END IF
    END IF
   END IF
   LET g_action_choice=""
   CALL t121_menu()
 
   CLOSE WINDOW t121_w                 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t121_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
   CLEAR FORM                             
   CALL g_pjha.clear()
     
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_pjha01 TO NULL   
    IF cl_null(g_argv1) THEN
      CONSTRUCT g_wc ON pjha01,pjha02,pjha03,pjha04,pjhaacti
                FROM pjha01,s_pjha[1].pjha02,s_pjha[1].pjha03,s_pjha[1].pjha04,s_pjha[1].pjhaacti
         
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               
         ON ACTION controlp
             CASE
                WHEN INFIELD(pjha01) 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pjb"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjha01
                   NEXT FIELD pjha01            
                WHEN INFIELD(pjha03)            
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_pjx"   #CHI-CA0060 mark
                  LET g_qryparam.form = "q_pjx2"  #CHI-CA0060
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjha03
                  NEXT FIELD pjha03  
                OTHERWISE EXIT CASE
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
		
      END CONSTRUCT
   END IF
      IF INT_FLAG THEN
         RETURN
      END IF
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                      
   #      LET g_wc = g_wc CLIPPED," AND pjbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN 
   #      LET g_wc = g_wc CLIPPED," AND pjbgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN   
   #      LET g_wc = g_wc CLIPPED," AND pjbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup')
   #End:FUN-980030
   IF cl_null(g_wc) THEN
      LET g_wc=" 1=1"
   END IF
   LET g_sql = "SELECT UNIQUE pjha01 ",
               " FROM pjha_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pjha01"
   PREPARE t121_prepare FROM g_sql
   DECLARE t121_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t121_prepare
 
  LET g_sql_tmp="SELECT UNIQUE pjha01 FROM pjha_file WHERE ",g_wc CLIPPED,  
                 " INTO TEMP x"
  
   DROP TABLE x                            
   PREPARE t121_precount_x FROM g_sql_tmp  
   EXECUTE t121_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE t121_precount FROM g_sql
   DECLARE t121_count CURSOR FOR t121_precount
 
END FUNCTION
 
FUNCTION t121_menu()
 
   WHILE TRUE
      CALL t121_bp("G")
      CASE g_action_choice
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t121_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t121_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t121_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t121_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjha),'','')
            END IF
        
         WHEN "related_document"          
          IF cl_chk_act_auth() THEN
             IF g_pjha01 IS NOT NULL THEN
                LET g_doc.column1 = "pjha01"             
                LET g_doc.value1 = g_pjha01              
                CALL cl_doc()
             END IF 
          END IF
       
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t121_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjha01 TO NULL             
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjha.clear()
 
   CALL t121_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjha01=NULL
      RETURN
   END IF
 
   OPEN t121_cs                         
      IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjha01=NULL
   ELSE    
      OPEN t121_count
      FETCH t121_count INTO g_row_count
      IF g_row_count > 0 THEN
         DISPLAY g_row_count TO FORMONLY.cnt
         CALL t121_fetch('F')   
      ELSE
        CALL cl_err('',100,0)
      END IF               
   END IF
 
END FUNCTION
 
FUNCTION t121_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     
   l_abso          LIKE type_file.num10     
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t121_cs INTO g_pjha01
      WHEN 'P' FETCH PREVIOUS t121_cs INTO g_pjha01
      WHEN 'F' FETCH FIRST    t121_cs INTO g_pjha01
      WHEN 'L' FETCH LAST     t121_cs INTO g_pjha01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t121_cs INTO g_pjha01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjha01,SQLCA.sqlcode,0)
      INITIALIZE g_pjha01 TO NULL   
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   CALL t121_show()
 
END FUNCTION
 
FUNCTION t121_show()
 
   DISPLAY g_pjha01 TO pjha01
 
   CALL t121_pjha01('d')
   CALL t121_b_fill(g_wc)   
         
   CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION t121_r()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjha01) THEN CALL cl_err("",-400,0) RETURN END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjha01
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
   
   BEGIN WORK
   
   CALL t121_show()
 
   IF cl_delh(0,0) THEN  
       INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjha01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjha01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
      DELETE FROM pjha_file WHERE pjha01=g_pjha01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjha_file",g_pjha01,"",SQLCA.sqlcode,"","BODY DELETE",1)  
      ELSE
         CLEAR FORM
         DROP TABLE x
         PREPARE t121_precount_x2 FROM g_sql_tmp  
         EXECUTE t121_precount_x2                      
         CALL g_pjha.clear()
         LET g_pjha01 = NULL
         OPEN t121_count  
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t121_cs
            CLOSE t121_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t121_count INTO g_row_count 
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t121_cs
            CLOSE t121_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t121_cs
         IF g_row_count>0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t121_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t121_fetch('/')
         END IF
         END IF
      END IF
      COMMIT WORK
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t121_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       
   l_n             LIKE type_file.num5,       
   l_cnt           LIKE type_file.num5,       
   l_flag          LIKE type_file.chr1,       
   l_lock_sw       LIKE type_file.chr1,       
   p_cmd           LIKE type_file.chr1,       
   l_allow_insert  LIKE type_file.num5,       
   l_allow_delete  LIKE type_file.num5,
   l_pjha02        LIKE pjha_file.pjha02       
  ,l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjha01) THEN RETURN END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose
     FROM pja_file,pjb_file
    WHERE pja01=pjb01
      AND pjb02=g_pjha01
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   LET g_pjha01_t=g_pjha01
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pjha02,pjha03,'','','',pjha04,'',pjhaacti",
                      " FROM pjha_file",
                      " WHERE pjha01=? AND pjha02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t121_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjha WITHOUT DEFAULTS FROM s_pjha.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK               #TQC-960083 add 

         IF g_rec_b >= l_ac THEN
           #BEGIN WORK            #TQC-960083 mark
            LET p_cmd='u'
            LET g_pjha01_t = g_pjha01 
            LET g_pjha01_o = g_pjha01  
            LET g_pjha_t.* = g_pjha[l_ac].*
            LET g_pjha_o.* = g_pjha[l_ac].*
 
            OPEN t121_bcl USING g_pjha01,g_pjha_t.pjha02
            IF STATUS THEN
               CALL cl_err("OPEN t121_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t121_bcl INTO g_pjha[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjha_t.pjha02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               #SELECT cpi02 INTO g_pjha[l_ac].cpi02 FROM cpi_file   #TQC-B90211
               #          WHERE cpi01 = g_pjha[l_ac].pjha03   #TQC-B90211
               #CHI-CA0060---add---S
                SELECT pka02 INTO g_pjha[l_ac].pka02 FROM pka_file
                 WHERE pka01 = g_pjha[l_ac].pjha03
               #CHI-CA0060---add---E
               SELECT pjx02,pjx03 INTO g_pjha[l_ac].pjx02,g_pjha[l_ac].pjx03
                      FROM pjx_file
                      WHERE pjx01=g_pjha[l_ac].pjha03
               LET g_pjha[l_ac].amt=g_pjha[l_ac].pjha04*g_pjha[l_ac].pjx03
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'  
         INITIALIZE g_pjha[l_ac].* TO NULL        
         LET g_pjha[l_ac].pjha04=0         #初始值 
         LET g_pjha[l_ac].pjhaacti ='Y' 
         LET g_pjha_t.* = g_pjha[l_ac].*      
         LET g_pjha_o.* = g_pjha[l_ac].*                    
         CALL cl_show_fld_cont()    
         NEXT FIELD pjha02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjha_file(pjha01,pjha02,pjha03,pjha04,
                              pjhaacti,pjhauser,pjhagrup,
                              pjhamodu,pjhadate,pjhaoriu,pjhaorig)
             VALUES(g_pjha01,g_pjha[l_ac].pjha02,g_pjha[l_ac].pjha03,
                    g_pjha[l_ac].pjha04,g_pjha[l_ac].pjhaacti,                 
                    g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN                  
            CALL cl_err3("ins","pjha_file",g_pjha[l_ac].pjha02,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjha02                       
         IF cl_null(g_pjha[l_ac].pjha02) THEN
            SELECT max(pjha02)+1 INTO g_pjha[l_ac].pjha02
              FROM pjha_file
             WHERE pjha01 = g_pjha01
            IF cl_null(g_pjha[l_ac].pjha02) THEN
               LET g_pjha[l_ac].pjha02 = 1
            END IF
         END IF
 
      AFTER FIELD pjha02                      
         IF NOT cl_null(g_pjha[l_ac].pjha02) THEN
            IF g_pjha[l_ac].pjha02 != g_pjha_t.pjha02 OR g_pjha_t.pjha02 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjha_file
                WHERE pjha01 = g_pjha01 
                  AND pjha02 = g_pjha[l_ac].pjha02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjha[l_ac].pjha02 = g_pjha_t.pjha02
                  NEXT FIELD pjha02
               END IF           
            END IF
            IF g_pjha[l_ac].pjha02<=0 THEN
               CALL cl_err('pjha02','aec-994',0)
               NEXT FIELD pjha02
            END IF
          ELSE
             CALL cl_err('pjha02','apm-915',0)
             NEXT FIELD pjha02
         END IF
 
      AFTER FIELD pjha03                 
         IF NOT cl_null(g_pjha[l_ac].pjha03) THEN
            IF g_pjha[l_ac].pjha03!=g_pjha_o.pjha03 OR g_pjha_o.pjha03 IS NULL THEN                    
                SELECT * FROM pjha_file 
                      WHERE pjha03=g_pjha[l_ac].pjha03 AND pjha01=g_pjha01          
                 IF  SQLCA.sqlcode=0 THEN
                     CALL cl_err('pjha03','-239',0)
                     NEXT FIELD pjha03
                 END IF                               
               CALL t121_pjha03('a') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjha[l_ac].pjha03,g_errno,0)
                  LET g_pjha[l_ac].pjha03 = g_pjha_o.pjha03              
                  DISPLAY BY NAME g_pjha[l_ac].pjha03                
                  NEXT FIELD pjha03
               END IF
            ELSE
               SELECT pjha02 INTO l_pjha02 
                  FROM pjha_file
                  WHERE pjha03=g_pjha[l_ac].pjha03 AND pjha01=g_pjha01
               IF l_pjha02!= g_pjha[l_ac].pjha02 THEN   
               CALL cl_err('pjha03','-239',0)
               NEXT FIELD pjha03
               END IF
            END IF
          END IF                        
     AFTER FIELD pjha04
       IF NOT cl_null(g_pjha[l_ac].pjha04) THEN
          IF g_pjha[l_ac].pjha04<0 THEN
             CALL cl_err('pjha04','amm-110',0)
             NEXT FIELD pjha04
          END IF  
          LET g_pjha[l_ac].amt=g_pjha[l_ac].pjha04*g_pjha[l_ac].pjx03
          DISPLAY BY NAME g_pjha[l_ac].amt
       END IF
       
      BEFORE DELETE                          
         IF g_pjha_t.pjha02 > 0 AND g_pjha_t.pjha02 IS NOT NULL THEN
            IF g_pjha[l_ac].pjhaacti='N' THEN
               CALL cl_err('',9027,0)
	        RETURN
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjha_file
             WHERE pjha01 = g_pjha01
               AND pjha02= g_pjha_t.pjha02
            IF SQLCA.sqlcode THEN                       
               CALL cl_err3("del","pjha_file",g_pjha_t.pjha02,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               IF g_rec_b = 0 THEN                                                 
                  CALL cl_err('',9044,1)                                           
                  CLEAR FORM
                  CALL g_pjha.clear()
                  SELECT COUNT(UNIQUE pjha01) INTO g_row_count FROM pjha_file
                  OPEN t121_cs
                  IF g_row_count>0 THEN
                     DISPLAY g_row_count TO cnt
                      IF g_curs_index = g_row_count + 1 THEN
                         LET g_jump = g_row_count
                         CALL t121_fetch('L')
                      ELSE
                         LET g_jump = g_curs_index
                         LET mi_no_ask = TRUE
                         CALL t121_fetch('/')
                      END IF
                  END IF         
               EXIT INPUT                                          
            END IF  
          END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pjha[l_ac].* = g_pjha_t.*
            CLOSE t121_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjha[l_ac].pjha02,-263,1)
            LET g_pjha[l_ac].* = g_pjha_t.*
         ELSE
            UPDATE pjha_file SET pjha02 = g_pjha[l_ac].pjha02,
                                pjha03 = g_pjha[l_ac].pjha03,
                                pjha04 = g_pjha[l_ac].pjha04,
                                pjhaacti=g_pjha[l_ac].pjhaacti,                     
                                pjhagrup = g_grup,
                                pjhadate = g_today
             WHERE pjha01 = g_pjha01
               AND pjha02 = g_pjha[l_ac].pjha02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjha_file",g_pjha01,g_pjha_t.pjha02,SQLCA.sqlcode,"","",1) 
               LET g_pjha[l_ac].* = g_pjha_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjha[l_ac].* = g_pjha_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjha.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t121_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t121_bcl
         COMMIT WORK
         CALL t121_show()
 
      ON ACTION CONTROLO                     
         IF INFIELD(pjha02) AND l_ac > 1 THEN
            LET g_pjha[l_ac].* = g_pjha[l_ac-1].*
            NEXT FIELD pjha02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjha03) 
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_pjx"   #CHI-CA0060 mark
               LET g_qryparam.form = "q_pjx2"  #CHI-CA0060
               LET g_qryparam.default1 = g_pjha[l_ac].pjha03
               CALL cl_create_qry() RETURNING g_pjha[l_ac].pjha03
                DISPLAY BY NAME g_pjha[l_ac].pjha03       
               CALL  t121_pjha03('d')
               NEXT FIELD pjha03
            OTHERWISE EXIT CASE
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
 
                                                                                          
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END INPUT
 
   CLOSE t121_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t121_pjha03(p_cmd)
    DEFINE #l_cpi02    LIKE cpi_file.cpi02,   #TQC-B90211
           #l_cpiacti  LIKE cpi_file.cpiacti, #TQC-B90211 
           l_pka02    LIKE pka_file.pka02,    #CHI-CA0060 add
           l_pkaacti  LIKE pka_file.pkaacti,  #CHI-CA0060 add
           p_cmd      LIKE type_file.chr1 ,  
           l_pjx02    LIKE pjx_file.pjx02,     
           l_pjx03    LIKE pjx_file.pjx03,
           l_pjxacti  LIKE pjx_file.pjxacti
           
   LET g_errno = ' '
   #-----TQC-B90211---------
   #SELECT cpi02,cpiacti
   #  INTO l_cpi02,l_cpiacti
   #  FROM cpi_file WHERE cpi01 = g_pjha[l_ac].pjha03
   #
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-034'
   #                               LET l_cpi02 = NULL
   #                               
   #     WHEN l_cpiacti='N'        LET g_errno = '9028'  
   #     OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   #END CASE
   #-----END TQC-B90211-----

   #CHI-CA0060---add---S
    SELECT pka02,pkaacti
      INTO l_pka02,l_pkaacti
      FROM pka_file WHERE pka01 = g_pjha[l_ac].pjha03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-034'
                                   LET l_pka02 = NULL

         WHEN l_pkaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   #CHI-CA0060---add---E
   
   SELECT pjx02,pjx03,pjxacti
     INTO l_pjx02,l_pjx03,l_pjxacti
     FROM pjx_file WHERE pjx01 = g_pjha[l_ac].pjha03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-034'
                                  LET l_pjx02 = NULL
                                  LET l_pjx03 = NULL
        #WHEN l_cpiacti='N'        LET g_errno = '9028'  #TQC-B90211
       #WHEN l_pjxacti='N'        LET g_errno = '9028'   #TQC-B90211 #CHI-CA0060 mark
        WHEN l_pkaacti='N'        LET g_errno = '9028'   #CHI-CA0060
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #LET g_pjha[l_ac].cpi02 = l_cpi02   #TQC-B90211
      LET g_pjha[l_ac].pka02 = l_pka02    #CHI-CA0060 add
      LET g_pjha[l_ac].pjx02 = l_pjx02
      LET g_pjha[l_ac].pjx03 = l_pjx03
      
      #DISPLAY BY NAME g_pjha[l_ac].cpi02 #TQC-B90211
      DISPLAY BY NAME g_pjha[l_ac].pka02  #CHI-CA0060 add
      DISPLAY BY NAME g_pjha[l_ac].pjx02
      DISPLAY BY NAME g_pjha[l_ac].pjx03
   END IF
 
END FUNCTION
 
FUNCTION t121_pjha01(p_cmd) 
   DEFINE l_pjb01       LIKE pjb_file.pjb01,
          l_pjb03       LIKE pjb_file.pjb03,
          l_pjb15       LIKE pjb_file.pjb15,
          l_pjb16       LIKE pjb_file.pjb16,
          l_pjbacti     LIKE pjb_file.pjbacti,
          l_pja02       LIKE pja_file.pja02,
          l_pjaacti     LIKE pja_file.pjaacti,
          p_cmd         LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT pjb01,pjb03,pjb15,pjb16,pjbacti
          INTO l_pjb01,l_pjb03,l_pjb15,l_pjb16,l_pjbacti
          FROM pjb_file
          WHERE g_pjha01=pjb02
      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-004'
                           LET l_pjb01 = NULL
                           LET l_pjb03=NULL
                           LET l_pjb15=NULL
                           LET l_pjb16=NULL                       
        WHEN l_pjbacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT pja02,pjaacti INTO l_pja02,l_pjaacti
          FROM pja_file
          WHERE pja01=l_pjb01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-005'            
                           LET l_pja02=NULL
        WHEN l_pjaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pjb01 TO pjb01
      DISPLAY l_pjb03 TO pjb03
      DISPLAY l_pjb15 TO pjb15
      DISPLAY l_pjb16 TO pjb16
      DISPLAY l_pja02 TO pja02
   END IF
   
END FUNCTION
 
FUNCTION t121_b_fill(p_wc2)              
#DEFINE p_wc2          LIKE type_file.chr1000  
DEFINE p_wc2  STRING     #NO.FUN-910082      
DEFINE l_amt          LIKE type_file.num20_6
   LET g_sql="SELECT pjha02,pjha03,'','','',pjha04,'',pjhaacti",
             " FROM pjha_file",
             " WHERE pjha01='",g_pjha01,"'"            
   IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjha02 "
   DISPLAY g_sql 
   PREPARE t121_pb FROM g_sql
   DECLARE pjha_cs CURSOR FOR t121_pb
   CALL g_pjha.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjha_cs INTO g_pjha[g_cnt].*  
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #-----TQC-B90211---------
      #SELECT cpi02 INTO g_pjha[g_cnt].cpi02 
      #             FROM cpi_file
      #             WHERE cpi01 = g_pjha[g_cnt].pjha03
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("sel","cpi_file",g_pjha[g_cnt].cpi02,"",SQLCA.sqlcode,"","",0)  
      #   LET g_pjha[g_cnt].cpi02 = NULL
      #END IF
      #-----END TQC-B90211-----

      #CHI-CA0060---add---S
       SELECT pka02 INTO g_pjha[g_cnt].pka02
         FROM pka_file
        WHERE pka01 = g_pjha[g_cnt].pjha03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","pka_file",g_pjha[g_cnt].pka02,"",SQLCA.sqlcode,"","",0)
          LET g_pjha[g_cnt].pka02 = NULL
       END IF          
      #CHI-CA0060---add---E
      SELECT pjx02,pjx03 INTO g_pjha[g_cnt].pjx02,g_pjha[g_cnt].pjx03
                      FROM pjx_file
                      WHERE pjx01=g_pjha[g_cnt].pjha03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pjx_file",g_pjha[g_cnt].pjx02,g_pjha[g_cnt].pjx03,SQLCA.sqlcode,"","",0)  
         LET g_pjha[g_cnt].pjx02 = NULL
         LET g_pjha[g_cnt].pjx03 = NULL
      END IF
      LET l_amt=g_pjha[g_cnt].pjha04*g_pjha[g_cnt].pjx03
      LET g_pjha[g_cnt].amt=l_amt
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjha.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION t121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjha TO s_pjha.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION first
         CALL t121_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
 
 
      ON ACTION previous
         CALL t121_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
 
 
      ON ACTION jump
         CALL t121_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION next
         CALL t121_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
 
      ON ACTION last
         CALL t121_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                           
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION t121_bp_refresh()
  DISPLAY ARRAY g_pjha TO s_pjha.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL t121_show()
END FUNCTION
 
FUNCTION t121_out()                                                     
  DEFINE l_wc STRING 
  IF cl_null(g_pjha01) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF                                   
   IF g_wc IS NULL THEN 
       LET g_wc ="pjha01='",g_pjha01,"'"  
   END IF    
   CALL cl_wait()                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang         
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   #-----TQC-B90211---------
   #LET g_sql="SELECT pjb01,pja02,pjha01,pjb03,pjb15,pjb16,pjha02,pjha03,cpi02,pjx02,pjx03,pjha04,pjhaacti",             
   #          " FROM pjha_file,pja_file,pjb_file,pjx_file,cpi_file",               
   #          " WHERE pjb_file.pjb01=pja_file.pja01 AND pjb_file.pjb02=pjha_file.pjha01", 
   #          " AND pjx_file.pjx01=pjha_file.pjha03 AND pjx_file.pjx01=cpi_file.cpi01 ",                        
   #          " AND ",g_wc CLIPPED 
   #CHI-CA0060---mark---S
   #LET g_sql="SELECT pjb01,pja02,pjha01,pjb03,pjb15,pjb16,pjha02,pjha03,pjx02,pjx03,pjha04,pjhaacti",             
   #          " FROM pjha_file,pja_file,pjb_file,pjx_file",               
   #          " WHERE pjb_file.pjb01=pja_file.pja01 AND pjb_file.pjb02=pjha_file.pjha01", 
   #          " AND pjx_file.pjx01=pjha_file.pjha03 ",                        
   #          " AND ",g_wc CLIPPED 
   #CHI-CA0060---mark---E
   #-----END TQC-B90211-----

   #CHI-CA0060---add---S
    LET g_sql="SELECT pjb01,pja02,pjha01,pjb03,pjb15,pjb16,pjha02,pjha03,pka02,pjx02,pjx03,pjha04,pjhaacti",
              " FROM pjha_file,pja_file,pjb_file,pjx_file,pka_file",
              " WHERE pjb_file.pjb01=pja_file.pja01 AND pjb_file.pjb02=pjha_file.pjha01",
              " AND pjx_file.pjx01=pjha_file.pjha03 AND pjx_file.pjx01=pka_file.pka01 ",
              " AND ",g_wc CLIPPED
   #CHI-CA0060---add---S

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'pjha01,pjha02,pjha03,pjha04,pjhaacti') RETURNING l_wc
   ELSE 
      LET l_wc = ' '
   END IF
   LET g_str = l_wc     
    LET g_sql = g_sql CLIPPED," ORDER BY pjha01,pjha02" 
    CALL cl_prt_cs1('apjt121','apjt121',g_sql,g_str)                                 
                
END FUNCTION                                                                             
 
FUNCTION t121_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          
      IF p_cmd='a' THEN   
      CALL cl_set_comp_entry("pjha01",TRUE)
      END IF
END FUNCTION
 
FUNCTION t121_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1                                            
         IF p_cmd='u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("pjha01",FALSE)
         END IF
END FUNCTION
#No.FUN-790025
