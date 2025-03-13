# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: afai050.4gl
# Descriptions...: 固定資產存放位置維護作業
# Date & Author..: 96/04/17 By Sophia
# Modify.........: No:A099 04/06/29 By Danny 新增大陸版 E.減值準備
# Modify.........: No.MOD-470515 04/07/26 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-5B0083 05/11/30 By Sarah 增加可輸入E.減值準備(此功能是不區分地區的)
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770005 07/07/03 By hongmei 報表格式修改為Crystal Report
# Modify.........: No.TQC-770086 07/07/18 By wujie  插入數據表時，原因碼不能為空 
# Modify.........: No.MOD-7C0089 07/12/17 By Smapmin 已不需要再動態抓取combo
# Modify.........: No.FUN-870128 08/07/29 By jamie CR不應call cl_outnam
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fag_pafago    LIKE type_file.num5,       #頁數                       #No.FUN-680070 SMALLINT
    g_fag           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fag01       LIKE fag_file.fag01,       #異動原因碼  
        fag02       LIKE fag_file.fag02,       #性質        
      # a1          LIKE type_file.chr20,      #性質說明 Genero mark       #No.FUN-680070 VARCHAR(10)
        fag03       LIKE fag_file.fag03,       #原因說明
        fagacti     LIKE fag_file.fagacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_fag_t         RECORD                     #程式變數 (舊值)
        fag01       LIKE fag_file.fag01,       #異動原因碼  
        fag02       LIKE fag_file.fag02,       #性質        
      # a1          LIKE type_file.chr20,      #性質說明 Genero mark       #No.FUN-680070 VARCHAR(10)
        fag03       LIKE fag_file.fag03,       #原因說明
        fagacti     LIKE fag_file.fagacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數                   #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT        #No.FUN-680070 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose#No.FUN-680070 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5     #No.FUN-570108       #No.FUN-680070 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0069
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time                 #No.FUN-6A0069
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW i050_w AT p_row,p_col WITH FORM "afa/42f/afai050"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   #No:A099                                                                    
  #IF g_aza.aza26 = '2' THEN   #FUN-5B0083 mark
      #CALL i050_set_comb()      #MOD-7C0089
      #CALL i050_set_comments()  #MOD-7C0089
  #END IF                      #FUN-5B0083 mark
   #end No:A099  
 
   LET g_wc2 = '1=1' CALL i050_b_fill(g_wc2)
   LET g_fag_pafago = 0                   #現在單身頁次
   CALL i050_menu()
   CLOSE WINDOW i050_w                    #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time                 #No.FUN-6A0069
END MAIN
 
FUNCTION i050_menu()
 
   WHILE TRUE
      CALL i050_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i050_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i050_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i050_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_fag[l_ac].fag01 IS NOT NULL THEN
                  LET g_doc.column1 = "fag01"
                  LET g_doc.value1 = g_fag[l_ac].fag01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fag),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i050_q()
   CALL i050_b_askkey()
   LET g_fag_pafago = 0
END FUNCTION
 
FUNCTION i050_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #可新增否          #No.FUN-680070 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                  #可刪除否          #No.FUN-680070 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')     
    LET l_allow_delete = cl_detail_input_auth('delete')     
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fag.clear() END IF
 
 
    CALL cl_opmsg('b')
 
    #Genero mark
    #LET g_forupd_sql = "SELECT fag01,fag02,'',fag03,fagacti FROM fag_file WHERE fag01= ? FOR UPDATE"
    LET g_forupd_sql = "SELECT fag01,fag02,fag03,fagacti FROM fag_file WHERE fag01= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i050_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_fag WITHOUT DEFAULTS FROM s_fag.* 
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,    
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
             
        BEFORE ROW
           LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fag_t.* = g_fag[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fag_t.* = g_fag[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
                LET g_before_input_done = FALSE                                         
                CALL i050_set_entry(p_cmd)                                              
                CALL i050_set_no_entry(p_cmd)                                           
                LET g_before_input_done = TRUE                                          
#No.FUN-570108 --end--                    
 
                BEGIN WORK
                OPEN i050_bcl USING g_fag_t.fag01
                IF STATUS THEN
                   CALL cl_err("OPEN i050_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"  
                ELSE
                   FETCH i050_bcl INTO g_fag[l_ac].* 
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_fag_t.fag01,SQLCA.sqlcode,0)
                        LET l_lock_sw = "Y"
                     END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           # Genero mark
           # CALL i050_fag02(g_fag[l_ac].fag02,l_ac)
           # DISPLAY g_fag[l_ac].a1 TO a1 
#           NEXT FIELD fag01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                         
            CALL i050_set_entry(p_cmd)                                              
            CALL i050_set_no_entry(p_cmd)                                           
            LET g_before_input_done = TRUE                                          
#No.FUN-570108 --end--          
            INITIALIZE g_fag[l_ac].* TO NULL      #900423
            LET g_fag[l_ac].fagacti = 'Y'         #Body default
            LET g_fag_t.* = g_fag[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fag01
 
        AFTER INSERT  
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fag[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fag[l_ac].* TO s_fag.*
              CALL g_fag.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO fag_file(fag01,fag02,fag03,
                                 fagacti,faguser,fagdate,fagoriu,fagorig)
            VALUES(g_fag[l_ac].fag01,g_fag[l_ac].fag02,g_fag[l_ac].fag03,
	           g_fag[l_ac].fagacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fag[l_ac].fag01,SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fag_file",g_fag[l_ac].fag01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
             # LET g_fag[l_ac].* = g_fag_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD fag02                       
            IF g_fag[l_ac].fag01 != g_fag_t.fag01 OR  #check 編號是否重複
               (g_fag[l_ac].fag01 IS NOT NULL AND g_fag_t.fag01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM fag_file
                    WHERE fag01 = g_fag[l_ac].fag01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fag[l_ac].fag01 = g_fag_t.fag01
                    NEXT FIELD fag01
                END IF
            END IF
 
	AFTER FIELD fag02
          #IF cl_null(g_fag[l_ac].fag02) OR
          #   g_fag[l_ac].fag02 NOT MATCHES '[1-9ABCD]' THEN
          #   NEXT FIELD fag02
          #END IF
           #Genero mark
           #CALL i050_fag02(g_fag[l_ac].fag02,l_ac)
           #No:A099
           IF g_aza.aza26 = '2' THEN
              IF g_fag[l_ac].fag02 NOT MATCHES '[1-9ABCDE]' THEN
                 NEXT FIELD fag02
              END IF
           END IF
           #end No:A099
           LET g_fag_t.fag02 = g_fag[l_ac].fag02
 
        BEFORE DELETE                            #是否取消單身
            IF g_fag_t.fag01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "fag01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_fag[l_ac].fag01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM fag_file WHERE fag01 = g_fag_t.fag01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fag_t.fag01,SQLCA.sqlcode,0)   #No.FUN-660136
                   CALL cl_err3("del","fag_file",g_fag_t.fag01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"      
                CLOSE i050_bcl          
                COMMIT WORK
            END IF
 
        ON ROW CHANGE   
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_fag[l_ac].* = g_fag_t.*
            CLOSE i050_bcl      
            ROLLBACK WORK      
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN                                                
             CALL cl_err(g_fag[l_ac].fag01,-263,1)                              
             LET g_fag[l_ac].* = g_fag_t.*                                      
         ELSE                                                                   
              UPDATE fag_file SET 
                     fag01=g_fag[l_ac].fag01,fag02=g_fag[l_ac].fag02,
                     fag03=g_fag[l_ac].fag03,fagacti=g_fag[l_ac].fagacti,
                     fagmodu=g_user,fagdate=g_today
              WHERE fag01=g_fag_t.fag01
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fag[l_ac].fag01,SQLCA.sqlcode,0)   #No.FUN-660136
                 CALL cl_err3("upd","fag_file",g_fag_t.fag01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                 LET g_fag[l_ac].* = g_fag_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i050_bcl
                 COMMIT WORK
              END IF
         END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR() 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_fag[l_ac].* = g_fag_t.*
              #FUN-D30032--add--begin--
              ELSE
                 CALL g_fag.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end----
              END IF
              CLOSE i050_bcl                                                   
              ROLLBACK WORK                                                    
              EXIT INPUT
           END IF
         # LET g_fag_t.* = g_fag[l_ac].*  
           LET l_ac_t = l_ac                                                   
           CLOSE i050_bcl                                                      
           COMMIT WORK                  
           #CKP2
          #CALL g_fag.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLN
            CALL i050_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fag01) AND l_ac > 1 THEN
                LET g_fag[l_ac].* = g_fag[l_ac-1].*
#               LET g_fag[l_ac].fag01 = '    '       #No.TQC-770086  
                LET g_fag[l_ac].fagacti = 'Y'            
                NEXT FIELD fag01
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
 
    CLOSE i050_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i050_b_askkey()
    CLEAR FORM
   CALL g_fag.clear()
    CONSTRUCT g_wc2 ON fag01,fag02,fag03,fagacti
            FROM s_fag[1].fag01,s_fag[1].fag02,s_fag[1].fag03,
				 s_fag[1].fagacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('faguser', 'faggrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    LET g_fag_pafago = 1
    CALL i050_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i050_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
       # "SELECT fag01,fag02,'',fag03,fagacti", #Genero mark
        "SELECT fag01,fag02,fag03,fagacti",
        " FROM fag_file",
        " WHERE ", p_wc2 CLIPPED,     #單身
        " ORDER BY 1"
    PREPARE i050_pb FROM g_sql
    DECLARE fag_curs CURSOR FOR i050_pb
  
    CALL g_fag.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fag_curs INTO g_fag[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      #Genero mark
      #CALL i050_fag02(g_fag[g_cnt].fag02,g_cnt) 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_fag.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
{--Genero mark
FUNCTION i050_fag02(l_fag02,l_cnt)
DEFINE
     l_fag02  LIKE fag_file.fag02,
     l_cnt    LIKE type_file.num5         #No.FUN-680070 SMALLINT
   CASE l_fag02
       WHEN '1'
         CALL cl_getmsg('afa-014',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '2'
         CALL cl_getmsg('afa-015',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '3'
         CALL cl_getmsg('afa-016',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '4'
         CALL cl_getmsg('afa-017',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '5'
         CALL cl_getmsg('afa-018',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '6'
         CALL cl_getmsg('afa-019',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '7'
         CALL cl_getmsg('afa-020',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '8'
         CALL cl_getmsg('afa-021',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN '9'
         CALL cl_getmsg('afa-022',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN 'A'
         CALL cl_getmsg('afa-023',g_lang) RETURNING g_fag[l_cnt].a1
       WHEN 'B'
         CALL cl_getmsg('afa-024',g_lang) RETURNING g_fag[l_cnt].a1
     #No.+317 010629 by plum
       WHEN 'C'
         CALL cl_getmsg('afa-026',g_lang) RETURNING g_fag[l_cnt].a1
     #No.+327..end
       OTHERWISE EXIT CASE
   END CASE
      LET g_fag[l_cnt].a1 = g_fag[l_cnt].a1
END FUNCTION
--}
 
FUNCTION i050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fag TO s_fag.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
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
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #No:A099                                                                    
        #IF g_aza.aza26 = '2' THEN   #FUN-5B0083 mark
            #CALL i050_set_comb()      #MOD-7C0089
            #CALL i050_set_comments()  #MOD-7C0089
        #END IF                      #FUN-5B0083 mark
         #end No:A099  
 
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
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i050_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,               #       #No.FUN-680070 VARCHAR(40)
        sr    RECORD
          fag01     LIKE fag_file.fag01,         #異動原因碼  
          fag02     LIKE fag_file.fag02,         #性質碼      
          a1        LIKE type_file.chr20,                     #性質說明       #No.FUN-680070 VARCHAR(10)
          fag03     LIKE fag_file.fag03,         #原因說明
          fagacti   LIKE fag_file.fagacti        #資料有效碼
          END RECORD
   
    IF g_wc2 IS NULL THEN 
 #     CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
   #CALL cl_outnam('afai050') RETURNING l_name   #FUN-870128 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT fag01,fag02,'',fag03,fagacti",   #組合出 SQL 指令
              "  FROM fag_file ",        
              " WHERE ",g_wc2 CLIPPED
 
#No.FUN-770005------Begin 
#   PREPARE i050_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i050_co                         # SCROLL CURSOR
#        CURSOR FOR i050_p1
 
#   START REPORT i050_rep TO l_name
 
#   FOREACH i050_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,0)  
#           EXIT FOREACH
#           END IF
#    CASE sr.fag02
#       WHEN '1' CALL cl_getmsg('afa-014',g_lang) RETURNING sr.a1 
#       WHEN '2' CALL cl_getmsg('afa-015',g_lang) RETURNING sr.a1
#       WHEN '3' CALL cl_getmsg('afa-016',g_lang) RETURNING sr.a1
#       WHEN '4' CALL cl_getmsg('afa-017',g_lang) RETURNING sr.a1
#       WHEN '5' CALL cl_getmsg('afa-018',g_lang) RETURNING sr.a1
#       WHEN '6' CALL cl_getmsg('afa-019',g_lang) RETURNING sr.a1
#       WHEN '7' CALL cl_getmsg('afa-020',g_lang) RETURNING sr.a1
#       WHEN '8' CALL cl_getmsg('afa-021',g_lang) RETURNING sr.a1
#       WHEN '9' CALL cl_getmsg('afa-022',g_lang) RETURNING sr.a1
#       WHEN 'A' CALL cl_getmsg('afa-023',g_lang) RETURNING sr.a1
#       WHEN 'B' CALL cl_getmsg('afa-024',g_lang) RETURNING sr.a1
#       #No:A099
#       WHEN 'C' CALL cl_getmsg('afa-026',g_lang) RETURNING sr.a1               
#       WHEN 'E' CALL cl_getmsg('afa-052',g_lang) RETURNING sr.a1               
#       #end No:A099
#       OTHERWISE EXIT CASE
#   END CASE
#       OUTPUT TO REPORT i050_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i050_rep
 
#   CLOSE i050_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'fag01,fag02,fag03,fagacti')                                 
       RETURNING g_wc2                                                          
    END IF
    CALL cl_prt_cs1('afai050','afai050',g_sql,g_wc2)
#No.FUN-770005------End
END FUNCTION
 
#No.FUN-770005------Begin
{
REPORT i050_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr   RECORD 
           fag01    LIKE fag_file.fag01,            #異動原因碼  
           fag02    LIKE fag_file.fag02,            #性質        
           a1       LIKE type_file.chr20,                        #性質說明       #No.FUN-680070 VARCHAR(10)
           fag03    LIKE fag_file.fag03,            #原因說明
           fagacti  LIKE fag_file.fagacti           #資料有效碼
         END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fag02,sr.fag01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.fagacti = 'N' THEN PRINT COLUMN g_c[31],'*' END IF
            PRINT COLUMN g_c[31],sr.fag01,
                  COLUMN g_c[32],sr.fag03,
                  COLUMN g_c[33],sr.fag02,
                  COLUMN g_c[34],sr.a1
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-770005------End
 
#-----MOD-7C0089---------
{
#No:A099
FUNCTION i050_set_comb()                                                        
  DEFINE comb_value STRING                                                      
  DEFINE comb_item  STRING                                                      
                                                                                
    LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,D,E'
    CALL cl_getmsg('afa-399',g_lang) RETURNING comb_item
    CALL cl_set_combo_items('fag02',comb_value,comb_item)     
END FUNCTION
 
FUNCTION i050_set_comments()                                                        
  DEFINE comm_value STRING                                                      
                                                                                
    CALL cl_getmsg('afa-398',g_lang) RETURNING comm_value
    CALL cl_set_comments('fag02',comm_value)
END FUNCTION
#end No:A099
}
#-----END MOD-7C0089-----
 
#No.FUN-570108 --start--                                                        
FUNCTION i050_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("fag01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i050_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("fag01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--                      
