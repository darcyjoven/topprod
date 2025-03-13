# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apjt112.4gl
# Descriptions...: WBS明細資料維護作業
# Date & Author..: No.FUN-790025 07/11/06 by ChenMoyan 項目管理
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830139 08/03/28 By ChenMoyan 項目管理BUG處理
# Modify.........: No.TQC-840009 08/04/03 By ChenMoyan 項目管理BUG處理
# Modify.........: No.TQC-840018 08/04/11 By ChenMoyan 項目管理BUG處理
# Modify.........: No.MOD-840428 08/04/20 By rainy 單身WBS負責人第一次開窗帶出0008員工,欄位跳至負責事項,後又回到WBS負責人欄位,又第二次帶出0009員工,會出現(apj-055)訊息
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950125 09/06/05 By chenmoyan 1 .651行 不用加pji_file  
#                                                      2. 499行 改成DISPLAY g_rec_b TO FORMONLY.cnt
#                                                      3. before delete 段加上 let g_rec_b = g_rec_b -1 and display g_rec_b TO FORMONLY.cnt
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B90211 11/09/29 By Smapmin 人事table drop
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjb15         LIKE pjb_file.pjb15,
    g_pjb16         LIKE pjb_file.pjb16, 
    g_pji01         LIKE pji_file.pji01,   
    g_pji02         LIKE pji_file.pji02,    
    g_pji03         LIKE pji_file.pji03,    
    g_pji01_t       LIKE pji_file.pji01,      
    l_cnt           LIKE type_file.num5,      
    l_cnt1          LIKE type_file.num5,      
    l_cmd           LIKE type_file.chr1000,  
    l_msg           LIKE type_file.chr1000, 
    g_pji           DYNAMIC ARRAY OF RECORD   #(Program Variables)
                    pji02   LIKE pji_file.pji02,
                    gen02_2   LIKE gen_file.gen02,
                    #cpk02   LIKE cpk_file.cpk02,   #TQC-B90211
                    #cpf15   LIKE cpf_file.cpf15,   #TQC-B90211
                    #cpf11   LIKE cpf_file.cpf11,   #TQC-B90211
                    cpk02   LIKE type_file.chr100,   #TQC-B90211
                    cpf15   LIKE type_file.chr100,   #TQC-B90211
                    cpf11   LIKE type_file.chr100,   #TQC-B90211
                    pji03   LIKE pji_file.pji03
                    END RECORD,
    g_pji_t         RECORD                    
                    pji02   LIKE pji_file.pji02,
                    gen02_2   LIKE gen_file.gen02,
                    #cpk02   LIKE cpk_file.cpk02,   #TQC-B90211
                    #cpf15   LIKE cpf_file.cpf15,   #TQC-B90211
                    #cpf11   LIKE cpf_file.cpf11,   #TQC-B90211
                    cpk02   LIKE type_file.chr100,   #TQC-B90211
                    cpf15   LIKE type_file.chr100,   #TQC-B90211
                    cpf11   LIKE type_file.chr100,   #TQC-B90211
                    pji03   LIKE pji_file.pji03
                    END RECORD,
 
    g_wc,g_wc2,g_sql,l_sql      string,  
    g_delete        LIKE type_file.chr1,   
    g_rec_b         LIKE type_file.num5,   
    l_za05          LIKE type_file.chr1000,
    l_ac            LIKE type_file.num5,   #ARRAY CNT  
    l_sl            LIKE type_file.num5,    #ARRAY CNT
    amount          LIKE type_file.num5,
    g_index         LIKE type_file.num5,
    g_str           STRING,
    g_pjp01         LIKE pjb_file.pjb01,
    g_argv1         LIKE pjb_file.pjb01,
    g_argv2         LIKE pji_file.pji01
   ,g_pjaclose      LIKE pja_file.pjaclose     #No.FUN-960038
    
DEFINE p_row,p_col  LIKE type_file.num5    
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_sql_tmp    STRING   
DEFINE g_before_input_done  LIKE type_file.num5         
DEFINE   g_cnt            LIKE type_file.num10         
DEFINE   g_i              LIKE type_file.num5          #count/index for any purpose   
DEFINE   g_msg            LIKE ze_file.ze03           
DEFINE   g_row_count      LIKE type_file.num10        
DEFINE   g_curs_index     LIKE type_file.num10         
DEFINE   g_jump           LIKE type_file.num10        
DEFINE   mi_no_ask        LIKE type_file.num5         
DEFINE   l_table          STRING
 
MAIN
   OPTIONS                                
      INPUT NO WRAP
   DEFER INTERRUPT                        
 
   LET g_argv1 = ARG_VAL(1)                                                                                                         
   LET g_argv2 = ARG_VAL(2)                                                                                                         

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql="pji01.pji_file.pji01,",
             "pjb03.pjb_file.pjb03,",
             "pjb01.pjb_file.pjb01,",
             "pja02.pja_file.pja02,",
             "pjb07.pjb_file.pjb07,",
             "pjr02.pjr_file.pjr02,",
             "pjb08.pjb_file.pjb08,",
             "pjb24.pjb_file.pjb24,",
             "pjb09.pjb_file.pjb09,",
             "pjb10.pjb_file.pjb10,",
             "pjb11.pjb_file.pjb11,",
             "pjb22.pjb_file.pjb22,",
             "gen02.gen_file.gen02,",
             "pjb23.pjb_file.pjb23,",
             "pjb15.pjb_file.pjb15,",
             "pjb16.pjb_file.pjb16,",
             "pjb17.pjb_file.pjb17,",
             "pjb18.pjb_file.pjb18,",
             "pjb19.pjb_file.pjb19,",
             "pjb20.pjb_file.pjb20,",
             "pji02.pji_file.pji02,",
             "gen02_2.gen_file.gen02,",
             #"cpk02.cpk_file.cpk02,",   #TQC-B90211
             #"cpf15.cpf_file.cpf15,",   #TQC-B90211
             #"cpf11.cpf_file.cpf11,",   #TQC-B90211
             "cpk02.type_file.chr100,",   #TQC-B90211
             "cpf15.type_file.chr100,",   #TQC-B90211
             "cpf11.type_file.chr100,",   #TQC-B90211
             "pji03.pji_file.pji03"
 
   LET l_table=cl_prt_temptable('apjt112',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   CALL cl_del_data(l_table)
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
  
   LET g_pji01   = NULL                   
   LET g_pji01_t = NULL
   LET g_pji01 = g_argv2

   OPEN WINDOW t112_w WITH FORM "apj/42f/apjt112"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   LET g_delete='N'
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN       
      SELECT count(*) INTO g_cnt FROM pji_file,pjb_file WHERE pji01=g_argv2 AND pjb01 = g_argv1 AND pji01 = pjb02                                                               
      IF g_cnt > 0 THEN
         CALL t112_q()                                                                                                              
      ELSE
         DISPLAY g_argv2 TO pji01
         DISPLAY g_argv1 TO pjb01
         CALL t112_fill()  
         CALL t112_b()                                                                                                              
      END IF                                                                                                                        
   END IF            
   CALL t112_menu()
   CLOSE WINDOW t112_w                   

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t112_cs()
   CLEAR FORM                             
   CALL g_pji.clear()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN                                                                            
      LET g_wc=" pji01 = '",g_argv2,"' "                                                                                           
   ELSE             
      CALL cl_set_head_visible("","YES")         
      CONSTRUCT g_wc ON pji01
           FROM pji01
                
      BEFORE CONSTRUCT
           CALL cl_qbe_init()
            
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    CONSTRUCT g_wc2 ON pji02,pji03
           FROM tb2[1].pji02,tb2[1].pji03
               
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            
              ON ACTION CONTROLP
                   #-----TQC-B90211---------
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.state= "c"
                   #LET g_qryparam.form = "q_cpf5"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   #DISPLAY g_qryparam.multiret TO pji02
                   #NEXT FIELD pji02
                   #-----END TQC-B90211-----
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		
   END CONSTRUCT
 END IF
   IF INT_FLAG THEN
          RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc="1=1"
   END IF
   IF cl_null(g_wc2) THEN
      LET g_wc2="1=1"
   END IF
   LET g_sql="SELECT UNIQUE pji01",
              " FROM pji_file ", 
              " WHERE ", g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              "ORDER BY pji01"
   PREPARE t112_prepare FROM g_sql      
   DECLARE t112_bcs                  
       SCROLL CURSOR WITH HOLD FOR t112_prepare
   LET g_sql_tmp="SELECT COUNT(DISTINCT pji01)",  
             "  FROM pji_file WHERE ", g_wc CLIPPED,
             " AND ",g_wc2 CLIPPED
 
   PREPARE t112_precount FROM g_sql_tmp
   DECLARE t112_count CURSOR FOR t112_precount
    OPEN t112_count                                                                                                               
      FETCH t112_count INTO g_row_count
END FUNCTION
 
FUNCTION t112_menu()
   WHILE TRUE
      CALL t112_bp("G")
      CASE g_action_choice
           WHEN "query" 
            IF cl_chk_act_auth() THEN
                CALL t112_q()
            END IF
 
           WHEN "detail" 
            IF cl_chk_act_auth() THEN 
                CALL t112_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
           WHEN "next" 
            CALL t112_fetch('N')
 
 
           WHEN "previous" 
            CALL t112_fetch('P')
 
           WHEN "help" 
            CALL cl_show_help()
 
           WHEN "exit"
            EXIT WHILE
     
           WHEN "jump"
            CALL t112_fetch('/')
 
           WHEN "controlg"     
            CALL cl_cmdask()
 
           WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pji),'','') 
            END IF
 
          WHEN "output"
            IF cl_chk_act_auth() THEN
              CALL t112_out()
            END IF
 
          WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t112_r()
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t112_q()
 
  DEFINE 
         l_curr   LIKE pji_file.pji02,
         l_cnt    LIKE type_file.num10           
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pji01 TO NULL                           
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL t112_cs() 
   IF INT_FLAG THEN                           
      LET INT_FLAG = 0
      INITIALIZE g_pji01 TO NULL
      RETURN
   END IF
   OPEN t112_bcs                    
   IF SQLCA.sqlcode THEN                         
      CALL cl_err('',SQLCA.sqlcode,1)
      INITIALIZE g_pji01 TO NULL
   ELSE
      OPEN t112_count
      FETCH t112_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.amount
      CALL t112_fetch('F')            
   END IF
END FUNCTION
 
FUNCTION t112_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t112_bcs INTO g_pji01
        WHEN 'P' FETCH PREVIOUS t112_bcs INTO g_pji01
        WHEN 'F' FETCH FIRST    t112_bcs INTO g_pji01
        WHEN 'L' FETCH LAST     t112_bcs INTO g_pji01
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t112_bcs INTO g_pji01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         
       CALL cl_err(g_pji01,SQLCA.sqlcode,1)
       INITIALIZE g_pji01 TO NULL 
    ELSE
        CALL t112_show()
       CASE p_flag
          WHEN 'F'
              LET g_curs_index = 1
              LET g_index=1
          WHEN 'P'
              LET g_curs_index = g_curs_index - 1
              LET g_index=g_index-1
          WHEN 'N'
              LET g_curs_index = g_curs_index + 1
              LET g_index=g_index+1
          WHEN 'L'
              LET g_curs_index = g_row_count
              LET g_index=amount
          WHEN '/'
              LET g_curs_index = g_jump
              LET g_index=g_jump
       END CASE
       
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_row_count,g_rec_b TO FORMONLY.amount,FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION t112_show()
 
    DISPLAY g_pji01 TO pji01  
    CALL t112_fill()
    CALL t112_b_fill(g_wc,g_wc2)                 
END FUNCTION
 
 
FUNCTION t112_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #ARRAY CNT 
    l_n             LIKE type_file.num5,                
    l_str           LIKE type_file.chr20,               
    l_lock_sw       LIKE type_file.chr1,                
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.num5,                
    l_allow_delete  LIKE type_file.num5                 
    LET g_action_choice = ""
    IF s_shut(0) THEN 
       RETURN 
    END IF                
    IF g_pji01 IS NULL THEN
       RETURN
    END IF
   IF g_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pji02,'','','','',pji03",
                       "  FROM pji_file",
                       "  WHERE pji01=?  AND pji02=? ", 
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t112_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pji WITHOUT DEFAULTS FROM tb2.* 
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
           LET g_pji02 = g_user
           BEGIN WORK
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pji_t.* = g_pji[l_ac].*      #BACKUP
              OPEN t112_bcl USING g_pji01,g_pji[l_ac].pji02
              FETCH t112_bcl INTO g_pji[l_ac].* 
              IF SQLCA.sqlcode THEN
                 LET l_lock_sw = "Y"
              ELSE
                 SELECT gen02 INTO g_pji[l_ac].gen02_2
                   FROM gen_file
                  WHERE gen01 = g_pji[l_ac].pji02
                 #-----TQC-B90211---------
                 #SELECT cpk02 INTO g_pji[l_ac].cpk02
                 #  FROM cpf_file,OUTER cpk_file
                 # WHERE cpf01=g_pji[l_ac].pji02 AND cpf_file.cpf31=cpk_file.cpk01
                 #SELECT cpf15,cpf11 INTO g_pji[l_ac].cpf15,g_pji[l_ac].cpf11
                 #  FROM cpf_file
                 # WHERE cpf01=g_pji[l_ac].pji02
                 #-----END TQC-B90211-----
              END IF
              LET g_pji_t.* = g_pji[l_ac].*      #BACKUP
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pji[l_ac].* TO NULL      
           LET g_pji_t.* = g_pji[l_ac].*    
           LET g_pji[l_ac].pji02 = g_pji02     
           NEXT FIELD pji02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO pji_file(pji01,pji02,pji03)
           VALUES(g_pji01,g_pji[l_ac].pji02,
                    g_pji[l_ac].pji03)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pji_file",g_pji01,g_pji[l_ac].pji02,
                            SQLCA.sqlcode,"","",1) 
              LET g_pji[l_ac].* = g_pji_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cnt #No.TQC-950125
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pji[l_ac].* = g_pji_t.*
              CLOSE t112_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err('',-263,1)
              LET g_pji[l_ac].* = g_pji_t.*
           ELSE
              UPDATE pji_file SET pji02=g_pji[l_ac].pji02,pji03=g_pji[l_ac].pji03
               WHERE pji01=g_pji01
                 AND pji02=g_pji_t.pji02  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pji_file",g_pji[l_ac].pji03,"",
                               SQLCA.sqlcode,"","",1)
                 LET g_pji[l_ac].* = g_pji_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
           
                 #-----TQC-B90211---------
                 #SELECT cpk02 INTO g_pji[l_ac].cpk02
                 #  FROM cpk_file,cpf_file
                 # WHERE cpf01=g_pji[l_ac].pji02 AND cpf31=cpk01
                 #SELECT cpf15,cpf11 INTO g_pji[l_ac].cpf15,g_pji[l_ac].cpf11
                 #  FROM cpf_file
                 # WHERE cpf01=g_pji[l_ac].pji02
                 #-----END TQC-B90211-----
     
              END IF
           END IF
         
        BEFORE DELETE
           IF g_pji_t.pji02 IS NOT NULL THEN
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
           IF l_lock_sw="Y" THEN
                 CALL cl_err("",-263,1)
                 CANCEL DELETE
           END IF
           DELETE FROM pji_file
             WHERE pji01=g_pji01
             AND pji02=g_pji_t.pji02
           IF SQLCA.sqlcode THEN
           CALL cl_err3("del","pji_file",g_pji01,g_pji_t.pji02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK 
                 CANCEL DELETE
           END IF
           LET g_rec_b=g_rec_b-1           #TQC-950125                          
           DISPLAY g_rec_b TO FORMONLY.cnt #TQC-950125
        END IF    
  
        AFTER FIELD pji02
           IF NOT cl_null(g_pji[l_ac].pji02) THEN
               IF g_pji[l_ac].pji02 != g_pji_t.pji02
                  OR g_pji_t.pji02 IS NULL THEN
                  #-----TQC-B90211---------
                  #SELECT count(*) INTO l_n FROM cpf_file
                  #    WHERE cpf01=g_pji[l_ac].pji02
                  #IF l_n = 0 THEN 
                  #     LET l_msg = g_pji[l_ac].pji02 clipped using '###&'
                  #   CALL cl_err(l_msg,'apj-055',0)
                  #      LET g_pji[l_ac].pji02 = g_pji_t.pji02  
                  #     NEXT FIELD pji02    
                  #END IF 
                  #-----END TQC-B90211-----
                  SELECT count(*) INTO l_n FROM pji_file
                     WHERE pji01=g_pji01 AND pji02=g_pji[l_ac].pji02
                  IF l_n>0 THEN
                  CALL cl_err('',-239,1)
                  LET g_pji[l_ac].pji02 = g_pji_t.pji02
                  NEXT FIELD pji02
                  END IF
              END IF
               SELECT gen02 INTO g_pji[l_ac].gen02_2                                                                              
                       FROM gen_file                                                                                                
                   WHERE gen01 = g_pji[l_ac].pji02                                                                                  
                                                                                                                                    
                   #-----TQC-B90211---------
                   #SELECT cpk02 INTO g_pji[l_ac].cpk02                                                                              
                   #    FROM cpf_file,OUTER cpk_file                                                                                 
                   #WHERE cpf01=g_pji[l_ac].pji02 AND cpf_file.cpf31=cpk_file.cpk01                                                           
                                                                                                                                    
                   #SELECT cpf15,cpf11 INTO g_pji[l_ac].cpf15,g_pji[l_ac].cpf11                                                      
                   #    FROM cpf_file            #No.TQC-950125                                                                                    
                   #WHERE cpf01=g_pji[l_ac].pji02                                                                                    
                   #-----END TQC-B90211-----
                                                                                                                                    
                   DISPLAY BY NAME g_pji[l_ac].*                                                                                    
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_pji[l_ac].* = g_pji_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_pji.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF 
              CLOSE t112_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE t112_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        
           IF INFIELD(pji02) AND l_ac > 1 THEN
              LET g_pji[l_ac].* = g_pji[l_ac-1].*
              NEXT FIELD pji02
           END IF
           
         ON ACTION CONTROLP                  
           CASE
              WHEN INFIELD(pji02)   
                   #-----TQC-B90211---------
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.state= "i"
                   #LET g_qryparam.form = "q_cpf5"
                   #CALL cl_create_qry() RETURNING g_pji[l_ac].pji02
                   #-----END TQC-B90211-----
  
               IF g_pji[l_ac].pji02 != g_pji_t.pji02                                                                                
                  OR g_pji_t.pji02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM pji_file                                                                            
                     WHERE pji01=g_pji01 AND pji02=g_pji[l_ac].pji02                                                                
                  IF l_n>0 THEN                                                                                                     
                  CALL cl_err('',-239,1)                                                                                            
                  LET g_pji[l_ac].pji02 = g_pji_t.pji02                                                                             
                  NEXT FIELD pji02                                                                                                  
                  END IF                                                                                                            
              END IF                      
                     
                   SELECT gen02 INTO g_pji[l_ac].gen02_2
                       FROM gen_file
                   WHERE gen01 = g_pji[l_ac].pji02
                   
                   #-----TQC-B90211---------
                   #SELECT cpk02 INTO g_pji[l_ac].cpk02
                   #    FROM cpf_file,OUTER cpk_file
                   #WHERE cpf01=g_pji[l_ac].pji02 AND cpf_file.cpf31=cpk_file.cpk01
 
                   #SELECT cpf15,cpf11 INTO g_pji[l_ac].cpf15,g_pji[l_ac].cpf11
                   #    FROM cpf_file              #No.TQC-950125
                   #WHERE cpf01=g_pji[l_ac].pji02
                   #-----END TQC-B90211-----
                   
                   DISPLAY BY NAME g_pji[l_ac].*
                   NEXT FIELD pji03
              OTHERWISE         
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
 
    CLOSE t112_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION t112_b_fill(p_wc,p_wc2)              #BODY FILL UP
DEFINE
    p_wc,p_wc2             STRING      #NO.FUN-910082      
    IF cl_null(p_wc) THEN 
       LET p_wc = " 1=1"
    END IF 
    LET g_sql = "SELECT pji02,'','','','',pji03",
                "  FROM pji_file ",
                " WHERE pji01 = '",g_pji01,"'", 
                "   AND ",p_wc CLIPPED,
                "   AND ",p_wc2 CLIPPED 
              
    PREPARE t112_prepare2 FROM g_sql      
    DECLARE pji_cs CURSOR FOR t112_prepare2
 
    CALL g_pji.clear()  
    LET g_cnt = 1
    LET g_rec_b=0
 
    FOREACH pji_cs INTO g_pji[g_cnt].*   
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gen02 INTO g_pji[g_cnt].gen02_2
         FROM gen_file
        WHERE gen01 = g_pji[g_cnt].pji02
       #-----TQC-B90211---------
       #SELECT cpk02 INTO g_pji[g_cnt].cpk02
       #  FROM cpf_file,OUTER cpk_file
       #WHERE cpf01=g_pji[g_cnt].pji02 AND cpf_file.cpf31=cpk_file.cpk01
       #SELECT cpf15,cpf11 INTO g_pji[g_cnt].cpf15,g_pji[g_cnt].cpf11
       #  FROM cpf_file
       #WHERE cpf01=g_pji[g_cnt].pji02
       #-----END TQC-B90211----- 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pji.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1               
    LET g_cnt = 0
   
END FUNCTION
 
FUNCTION t112_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
  
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pji TO tb2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
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
         CALL t112_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
                              
      ON ACTION previous
         CALL t112_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION jump 
         CALL t112_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
                              
      ON ACTION next
         CALL t112_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
                              
      ON ACTION last 
         CALL t112_fetch('L')
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
 
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
    
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   
    END DISPLAY
    
    CALL cl_set_act_visible("accept,cancel", TRUE)
 END FUNCTION 
 
 FUNCTION t112_fill()
 DEFINE   l_pjb01        LIKE pjb_file.pjb01,
          l_pjb03        LIKE pjb_file.pjb03,
          l_pjb07        LIKE pjb_file.pjb07,
          l_pjb08        LIKE pjb_file.pjb08,
          l_pjb09        LIKE pjb_file.pjb09,
          l_pjb10        LIKE pjb_file.pjb10,
          l_pjb11        LIKE pjb_file.pjb11,
          l_pjb15        LIKE pjb_file.pjb15,
          l_pjb16        LIKE pjb_file.pjb16,
          l_pjb17        LIKE pjb_file.pjb17,
          l_pjb18        LIKE pjb_file.pjb18,
          l_pjb19        LIKE pjb_file.pjb19,
          l_pjb20        LIKE pjb_file.pjb20,
          l_pjb22        LIKE pjb_file.pjb22,
          l_pjb24        LIKE pjb_file.pjb24,
          l_gen02        LIKE gen_file.gen02,
          l_pjb23        LIKE pjb_file.pjb23
DEFINE    l_pja02        LIKE pja_file.pja02
DEFINE    l_pjr02        LIKE pjr_file.pjr02  
 
  IF g_argv1 IS NOT NULL AND g_argv2 IS NOT NULL THEN 
     SELECT pjb01,pjb03,pjb07,pjb08,pjb09,pjb10,pjb11,pjb17,pjb18,pjb19,                                                    
          pjb20,pjb24,pjb22,gen02,pjb23                                                                                               
     INTO l_pjb01,l_pjb03,l_pjb07,l_pjb08,l_pjb09,l_pjb10,l_pjb11,                                                    
                l_pjb17,l_pjb18,l_pjb19,l_pjb20,l_pjb24,l_pjb22,l_gen02,l_pjb23                                             
     FROM pjb_file,OUTER gen_file                                                                                                    
     WHERE pjb_file.pjb22 = gen_file.gen01 AND pjb01 = g_argv1 
           AND pjb02 = g_argv2                      #No.FUN-830139       
     SELECT pja02,pja10,pja11,pjaclose              #No.FUN-960038 ADD pjaclose
       INTO l_pja02,l_pjb15,l_pjb16,g_pjaclose      #No.FUN-960038 ADD g_pjaclose 
       FROM pja_file WHERE pja01 = g_argv1
                                                                                                                                    
     SELECT pjr02 INTO l_pjr02                                                                                                      
     FROM pjb_file,OUTER pjr_file                                                                                                   
     WHERE pjb02=g_argv2 AND pjb_file.pjb07=pjr_file.pjr01 
  ELSE  
     SELECT pjb01,pjb03,pjb07,pjb08,pjb09,pjb10,pjb11,pjb15,pjb16,pjb17,pjb18,pjb19,
          pjb20,pjb24,pjb22,gen02,pjb23 
     INTO l_pjb01,l_pjb03,l_pjb07,l_pjb08,l_pjb09,l_pjb10,l_pjb11,l_pjb15,
          l_pjb16,l_pjb17,l_pjb18,l_pjb19,l_pjb20,l_pjb24,l_pjb22,l_gen02,l_pjb23
     FROM pjb_file,OUTER gen_file
     WHERE pjb02 = g_pji01 AND pjb_file.pjb22 = gen_file.gen01
  
     SELECT pja02,pjaclose INTO l_pja02,g_pjaclose  #No.FUN-960038 ADD pjaclose
     FROM pjb_file,OUTER pja_file
     WHERE pjb02=g_pji01 AND pjb01=pja_file.pja01
 
     SELECT pjr02 INTO l_pjr02
     FROM pjb_file,OUTER pjr_file
     WHERE pjb02=g_pji01 AND pjb_file.pjb07=pjr_file.pjr01
  END IF
    
     DISPLAY l_pjb01,l_pjb03,l_pjb07,l_pjb08,l_pjb09,l_pjb10,l_pjb11,l_pjb15,
            l_pjb16,l_pjb17,l_pjb18,l_pjb19,l_pjb20,l_pja02,l_pjr02,l_pjb24,l_pjb22,l_gen02,l_pjb23 
      TO pjb01,pjb03,pjb07,pjb08,pjb09,pjb10,pjb11,pjb15,pjb16,pjb17,pjb18,pjb19,pjb20,pja02,pjr02,
       pjb24,pjb22,gen02,pjb23
END FUNCTION
 
FUNCTION t112_r()

   IF g_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF

   LET g_sql="SELECT pji01 FROM pji_file WHERE pji01=?  FOR UPDATE "
   LET g_sql=cl_forupd_sql(g_sql)
                                                                                                
   DECLARE t112_bcs2 CURSOR  FROM g_sql  
 
    IF s_shut(0) THEN 
          RETURN 
    END IF
 
    IF g_pji01 IS NULL THEN
          CALL cl_err("",-400,0)
          RETURN
   END IF
  
   BEGIN WORK
   OPEN t112_bcs2 USING g_pji01 
   IF STATUS THEN
       CALL cl_err("OPEN t112_bcs2:",STATUS,1)
       CLOSE t112_bcs2
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t112_bcs2 INTO g_pji01
   IF SQLCA.sqlcode THEN
          CALL cl_err(g_pji01,SQLCA.sqlcode,1)
          CLOSE t112_bcs2
          ROLLBACK WORK
          RETURN
   END IF
 
   IF cl_delh(0,0) THEN
          DELETE FROM pji_file WHERE pji01=g_pji01
          CLEAR FORM
          LET g_pji01=''
          CALL g_pji.clear()
          OPEN t112_count
          #FUN-B50063-add-start--
          IF STATUS THEN
             CLOSE t112_bcs
             CLOSE t112_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end-- 
          FETCH t112_count INTO g_row_count
          IF g_row_count <> 0 THEN
             OPEN t112_bcs 
             IF g_curs_index=g_row_count+1 THEN
                  LET g_jump=g_row_count
                  CALL t112_fetch('L')
             ELSE
                  LET g_jump=g_curs_index
                  LET mi_no_ask=TRUE
                  CALL t112_fetch('/')
             END IF
          END IF
   END IF
          
          
    CALL cl_flow_notify(g_pji01,'D')
    CLOSE t112_bcs2 
    COMMIT WORK
 END FUNCTION
 
FUNCTION t112_fill_num()
    LET g_sql_tmp="SELECT pji01,pji02",                                                                                              
             "  FROM pji_file WHERE ", g_wc CLIPPED,                                                                                
             " AND ",g_wc2 CLIPPED,                                                                                                 
             " INTO TEMP x"                                                                                                         
   DROP TABLE x                                                                                                                     
   PREPARE t112_prenum_x FROM g_sql_tmp                                                                                           
   EXECUTE t112_prenum_x                                                                                                          
                                                                                                                                    
   LET g_sql="SELECT COUNT(DISTINCT pji01) FROM x "                                                                                              
   PREPARE t112_prenum FROM g_sql                                                                                                 
   DECLARE t112_num CURSOR FOR t112_prenum     
   OPEN t112_num                                                                                                               
      FETCH t112_num INTO amount   
    IF amount <> 0 THEN
      DISPLAY amount TO FORMONLY.cnt
    END IF
    IF g_index <> 0 THEN
      DISPLAY g_row_count TO FORMONLY.amount
    END IF
   LET g_argv1 = NULL
   LET g_argv2 = NULL
END FUNCTION
 
FUNCTION t112_out()
DEFINE l_gen02 LIKE gen_file.gen02
DEFINE sr RECORD
    pji01 LIKE pji_file.pji01,
    pjb03 LIKE pjb_file.pjb03,
    pjb01 LIKE pjb_file.pjb01,
    pja02 LIKE pja_file.pja02,
    pjb07 LIKE pjb_file.pjb07,
    pjr02 LIKE pjr_file.pjr02,
    pjb08 LIKE pjb_file.pjb08,
    pjb24 LIKE pjb_file.pjb24,
    pjb09 LIKE pjb_file.pjb09,
    pjb10 LIKE pjb_file.pjb10,
    pjb11 LIKE pjb_file.pjb11,
    pjb22 LIKE pjb_file.pjb22,
    pjb23 LIKE pjb_file.pjb23,
    pjb15 LIKE pjb_file.pjb15,
    pjb16 LIKE pjb_file.pjb16,
    pjb17 LIKE pjb_file.pjb17,
    pjb18 LIKE pjb_file.pjb18,
    pjb19 LIKE pjb_file.pjb19,    
    pjb20 LIKE pjb_file.pjb20,
    pji02 LIKE pji_file.pji02,
    gen02_2 LIKE gen_file.gen02,
    #cpk02 LIKE cpk_file.cpk02,   #TQC-B90211
    #cpf15 LIKE cpf_file.cpf15,   #TQC-B90211
    #cpf11 LIKE cpf_file.cpf11,   #TQC-B90211
    cpk02 LIKE type_file.chr100,   #TQC-B90211
    cpf15 LIKE type_file.chr100,   #TQC-B90211
    cpf11 LIKE type_file.chr100,   #TQC-B90211
    pji03 LIKE pji_file.pji03
    END RECORD
   CALL cl_del_data(l_table)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   IF cl_null(g_wc) THEN 
       LET g_wc = "pji01 = '",g_pji01,"'"
   ELSE 
       LET g_wc = g_wc CLIPPED," AND " ,g_wc2 CLIPPED 
   END IF
   LET l_sql="SELECT pji01,pjb03,pjb01,pja02,pjb07,pjr02,pjb08,pjb24,pjb09,pjb10,pjb11,pjb22,pjb23,",
             #"pjb15,pjb16,pjb17,pjb18,pjb19,pjb20,pji02,gen02,cpk02,cpf15,cpf11,pji03",   #TQC-B90211
             "pjb15,pjb16,pjb17,pjb18,pjb19,pjb20,pji02,gen02,'','','',pji03",   #TQC-B90211
#" FROM pji_file LEFT OUTER JOIN pjb_file LEFT OUTER JOIN pjr_file ON pjb07 = pjr01 LEFT OUTER JOIN pja_file ON pjb01 = pja01 ON pji01=pjb02 LEFT OUTER JOIN gen_file ON pji02 = gen01 LEFT OUTER JOIN cpf_file LEFT OUTER JOIN cpk_file ON cpf31 = cpk01 ON pji02 = cpf01 ",   #TQC-B90211
" FROM pji_file LEFT OUTER JOIN pjb_file LEFT OUTER JOIN pjr_file ON pjb07 = pjr01 LEFT OUTER JOIN pja_file ON pjb01 = pja01 ON pji01=pjb02 LEFT OUTER JOIN gen_file ON pji02 = gen01 ",   #TQC-B90211
             " AND ", g_wc CLIPPED
   PREPARE t112_prep FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
   END IF
   DECLARE t112_curs1 CURSOR FOR t112_prep
 
   FOREACH t112_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.pjb22
   
   EXECUTE insert_prep USING 
       sr.pji01,sr.pjb03,sr.pjb01,sr.pja02,sr.pjb07,                                                            
              sr.pjr02,sr.pjb08,sr.pjb24,sr.pjb09,sr.pjb10,sr.pjb11,sr.pjb22,l_gen02,sr.pjb23,                                               
              sr.pjb15,sr.pjb16,sr.pjb17,sr.pjb18,sr.pjb19,sr.pjb20,sr.pji02,sr.gen02_2,                                              
              #sr.cpk02,sr.cpf15,sr.cpf11,sr.pji03         #TQC-B90211   
              '','','',sr.pji03         #TQC-B90211   
   INITIALIZE l_gen02 TO NULL 
   INITIALIZE sr.* TO NULL                  #No.TQC-840018
  END FOREACH
  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
  LET g_str = g_wc
  CALL cl_prt_cs3('apjt112','apjt112',g_sql,g_str)
END FUNCTION  
#No:FUN-9C0071--------精簡程式-----
