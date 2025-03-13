# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: afai040.4gl
# Descriptions...: 固定資產存放位置維護作業
# Date & Author..: 96/04/17 By Sophia
# Modify.........: No.MOD-470515 04/07/26 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770005 07/07/03 By hongmei 報表格式修改為Crystal Report
# Modify.........: No.MOD-840603 08/07/09 By Pengu BEGIN WORK 重複
# Modify.........: No.FUN-870128 08/07/29 By jamie CR不應call cl_outnam
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30032 13/04/03 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_faf_pafafo    LIKE type_file.num5,       #頁數                        #No.FUN-680070 SMALLINT
    g_faf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        faf01       LIKE faf_file.faf01,       #存放位置代碼
        faf02       LIKE faf_file.faf02,       #存放位置名稱
        faf03       LIKE faf_file.faf03,       #存放工廠
        fafacti     LIKE faf_file.fafacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_faf_t         RECORD                     #程式變數 (舊值)
        faf01       LIKE faf_file.faf01,       #存放位置代碼
        faf02       LIKE faf_file.faf02,       #存放位置名稱
        faf03       LIKE faf_file.faf03,       #存放工廠
        fafacti     LIKE faf_file.fafacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數                    #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT         #No.FUN-680070 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680070 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5     #No.FUN-570108        #No.FUN-680070 SMALLINT
DEFINE g_str        STRING                     #No.FUN-770005 
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
         RETURNING g_time    #No.FUN-6A0069
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW i040_w AT p_row,p_col WITH FORM "afa/42f/afai040"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
   LET g_wc2 = '1=1' CALL i040_b_fill(g_wc2)
   LET g_faf_pafafo = 0                   #現在單身頁次
   CALL i040_menu()
   CLOSE WINDOW i040_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
FUNCTION i040_menu()
 
   WHILE TRUE
      CALL i040_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i040_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
                CALL i040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i040_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN   #No.Fun-570199
               IF g_faf[l_ac].faf01 IS NOT NULL THEN
                  LET g_doc.column1 = "faf01"
                  LET g_doc.value1 = g_faf[l_ac].faf01
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_faf),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i040_q()
   CALL i040_b_askkey()
   LET g_faf_pafafo = 0
END FUNCTION
 
FUNCTION i040_b()
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
   IF g_rec_b=0 THEN CALL g_faf.clear() END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT faf01,faf02,faf03,fafacti FROM faf_file WHERE faf01= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_faf
            WITHOUT DEFAULTS
            FROM s_faf.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)        
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_faf_t.* = g_faf[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
           #IF g_faf_t.faf01 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_faf_t.* = g_faf[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
                LET g_before_input_done = FALSE                                 
                CALL i040_set_entry(p_cmd)                                      
                CALL i040_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end--            
               #BEGIN WORK               #No.MOD-840603 mark
                OPEN i040_bcl USING g_faf_t.faf01
                IF STATUS THEN
                   CALL cl_err("OPEN i040_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"  
                ELSE
                   FETCH i040_bcl INTO g_faf[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_faf_t.faf01,SQLCA.sqlcode,0)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD faf01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                 
            CALL i040_set_entry(p_cmd)                                      
            CALL i040_set_no_entry(p_cmd)                                   
            LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end--            
            INITIALIZE g_faf[l_ac].* TO NULL      #900423
            LET g_faf[l_ac].fafacti = 'Y'         #Body default
            LET g_faf_t.* = g_faf[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD faf01
 
        AFTER INSERT  
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_faf[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_faf[l_ac].* TO s_faf.*
              CALL g_faf.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF     
            INSERT INTO faf_file(faf01,faf02,faf03,
                                 fafacti,fafuser,fafdate,faforiu,faforig)
                 VALUES(g_faf[l_ac].faf01,g_faf[l_ac].faf02,
                        g_faf[l_ac].faf03,
	                g_faf[l_ac].fafacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_faf[l_ac].faf01,SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","faf_file",g_faf[l_ac].faf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
               LET g_faf[l_ac].* = g_faf_t.*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD faf02                       
            IF g_faf[l_ac].faf01 != g_faf_t.faf01 OR  #check 編號是否重複
               (g_faf[l_ac].faf01 IS NOT NULL AND g_faf_t.faf01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM faf_file
                    WHERE faf01 = g_faf[l_ac].faf01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_faf[l_ac].faf01 = g_faf_t.faf01
                    NEXT FIELD faf01
                END IF
            END IF
 
	AFTER FIELD faf03
            IF NOT cl_null(g_faf[l_ac].faf03) AND g_faa.faa24 = 'Y'
            THEN CALL i040_faf03('a')
		 IF NOT cl_null(g_errno) THEN
		    CALL cl_err('',g_errno,0) 
                    NEXT FIELD faf03
 	 	 END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_faf_t.faf01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "faf01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_faf[l_ac].faf01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM faf_file WHERE faf01 = g_faf_t.faf01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_faf_t.faf01,SQLCA.sqlcode,0)    #No.FUN-660136
                   CALL cl_err3("del","faf_file",g_faf_t.faf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"      
                CLOSE i040_bcl          
                COMMIT WORK
            END IF
 
        ON ROW CHANGE   
         IF INT_FLAG THEN                 #900423                               
            CALL cl_err('',9001,0)                                              
            LET INT_FLAG = 0                                                    
            LET g_faf[l_ac].* = g_faf_t.*                                       
            CLOSE i040_bcl                                                      
            ROLLBACK WORK                                                       
            EXIT INPUT                                                          
         END IF                                                                 
         IF l_lock_sw = 'Y' THEN                                                
             CALL cl_err(g_faf[l_ac].faf01,-263,1)                              
             LET g_faf[l_ac].* = g_faf_t.*                                      
         ELSE                                                                   
             display 'update'
             UPDATE faf_file SET 
                    faf01=g_faf[l_ac].faf01, faf02=g_faf[l_ac].faf02,
                    faf03=g_faf[l_ac].faf03, fafacti=g_faf[l_ac].fafacti,
                    fafmodu=g_user,          fafdate=g_today
             WHERE faf01=g_faf_t.faf01                     #GENERO 
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_faf[l_ac].faf01,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","faf_file",g_faf_t.faf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                LET g_faf[l_ac].* = g_faf_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i040_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR() 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_faf[l_ac].* = g_faf_t.*
           #FUN-D30032--add--str--
               ELSE
                  CALL g_faf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
           #FUN-D30032--add--end--
              END IF
              CLOSE i040_bcl                                                   
              ROLLBACK WORK                                                    
              EXIT INPUT
           END IF
          #LET g_faf_t.* = g_faf[l_ac].*  
           LET l_ac_t = l_ac                                                   
           CLOSE i040_bcl                                                      
           COMMIT WORK                  
           #CKP2
           CALL g_faf.deleteElement(g_rec_b+1)
 
       ON ACTION controlp
           CASE WHEN INFIELD(faf03)
#                   CALL q_azp(0,0,g_faf[l_ac].faf03)
#                       RETURNING g_faf[l_ac].faf03
#                   CALL FGL_DIALOG_SETBUFFER( g_faf[l_ac].faf03 )
                    CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_azp"    #FUN-990031 mark
                    LET g_qryparam.form = "q_azw"     #FUN-990031 add
                    LET g_qryparam.default1 = g_faf[l_ac].faf03
                    LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                    CALL cl_create_qry() RETURNING g_faf[l_ac].faf03
#                    CALL FGL_DIALOG_SETBUFFER( g_faf[l_ac].faf03 )
                     DISPLAY g_faf[l_ac].faf03 TO faf03         #No.MOD-490344
                    NEXT FIELD faf03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i040_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(faf01) AND l_ac > 1 THEN
                LET g_faf[l_ac].* = g_faf[l_ac-1].*
                LET g_faf[l_ac].faf01 = '    '
                LET g_faf[l_ac].fafacti = 'Y'
                NEXT FIELD faf01
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
 
    CLOSE i040_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i040_faf03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_azp02         LIKE azp_file.azp02  
 
    LET g_errno = ' '
    #FUN-990031--mod--str-- 營運中心要控制在當前法人下  
    #SELECT azp02   INTO l_azp02   FROM azp_file
    #    WHERE azp01 = g_faf[l_ac].faf03
    SELECT * FROM azw_file
     WHERE azw01 = g_faf[l_ac].faf03  AND azw02 = g_legal                                                        
    #FUN-990031--mod--end 
    CASE WHEN SQLCA.SQLCODE = 100  #LET g_errno = 'aap-025'    #FUN-990031
                                   LET g_errno = 'agl-171'     #FUN-990031
                            LET l_azp02   = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i040_b_askkey()
    CLEAR FORM
   CALL g_faf.clear()
    CONSTRUCT g_wc2 ON faf01,faf02,faf03,fafacti
            FROM s_faf[1].faf01,s_faf[1].faf02,s_faf[1].faf03,
				 s_faf[1].fafacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
           CASE WHEN INFIELD(faf03)
#                   CALL q_azp(0,0,g_faf[1].faf03)
#                       RETURNING g_faf[1].faf03
                    CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_azp"   #FUN-990031 mark
                    LET g_qryparam.form = "q_azw"    #FUN-990031 add
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "azw02 = '",g_legal,"' "  #FUN-990031 add
                    LET g_qryparam.default1 = g_faf[1].faf03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_faf[1].faf03
                    NEXT FIELD faf03
                OTHERWISE
                    EXIT CASE
            END CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('fafuser', 'fafgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    LET g_faf_pafafo = 1
    CALL i040_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i040_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT faf01,faf02,faf03,fafacti",
        " FROM faf_file",
        " WHERE ", p_wc2 CLIPPED,     #單身
        " ORDER BY 1"
    PREPARE i040_pb FROM g_sql
    DECLARE faf_curs CURSOR FOR i040_pb
 
    CALL g_faf.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH faf_curs INTO g_faf[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_faf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_faf TO s_faf.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
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
 
FUNCTION i040_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,        # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE za_file.za05,           #No.FUN-680070 VARCHAR(40)
        sr    RECORD
          faf01     LIKE faf_file.faf01,         #存放位置代碼
          faf02     LIKE faf_file.faf02,         #存放位置名稱
          faf03     LIKE faf_file.faf03,         #存放工廠
          azp02     LIKE azp_file.azp02,         #工廠名稱
          fafacti   LIKE faf_file.fafacti        #資料有效碼
          END RECORD
   
    IF g_wc2 IS NULL THEN 
#      CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
   #CALL cl_outnam('afai040') RETURNING l_name   #FUN-870128 mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT faf01,faf02,faf03,azp02,fafacti",   #組合出 SQL 指令
              " FROM faf_file,azp_file ",        
               " WHERE ",g_wc2 CLIPPED
#No.FUN-770005------Begin
#   PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i040_co                         # SCROLL CURSOR
#        CURSOR FOR i040_p1
 
#   START REPORT i040_rep TO l_name
 
#   FOREACH i040_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,0)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i040_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i040_rep
 
#   CLOSE i040_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'faf01,faf02,faf03,fafacti')                                 
       RETURNING g_wc2                                                          
    END IF
    CALL cl_prt_cs1('afai040','afai040',g_sql,g_wc2)
#No.FUN-770005------End
END FUNCTION
 
#No.FUN-770005------Begin 
{
REPORT i040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr   RECORD 
           faf01    LIKE faf_file.faf01,            #存放位置代碼
           faf02    LIKE faf_file.faf02,            #存放位置名稱
           faf03    LIKE faf_file.faf03,            #存放工廠
           azp02    LIKE azp_file.azp02,            #工廠名稱
           fafacti  LIKE faf_file.fafacti           #資料有效碼
         END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.faf01
 
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
          IF sr.fafacti = 'N' THEN PRINT COLUMN g_c[31],'*' END IF
          PRINT COLUMN g_c[31],sr.faf01,
                COLUMN g_c[32],sr.faf02,
                COLUMN g_c[33],sr.faf03,
                COLUMN g_c[34],sr.azp02
 
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
 
#No.FUN-570108 --start--                                                        
FUNCTION i040_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("faf01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i040_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("faf01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--                       
