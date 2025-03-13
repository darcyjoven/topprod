# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csfi012.4gl
# Descriptions...: 部門名稱
# Date & Author..: 91/06/21 By Lee
# Modify	 : 94/12/05 by Nick (Change to Multiline Task)
 # Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制 
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: NO.FUN-680010 06/08/05 By Joe SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680102 06/09/13 By zdyllq 類型轉換 
#
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/09 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B70075 11/07/20 by shiwuying 更新已传pos否的状态
# Modify.........: No.FUN-C50036 12/06/05 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No.CHI-BB0048 12/07/27 By jt_chen 刪除時增加寫入azo_file紀錄異動
# Modify.........: No.CHI-B70023 13/01/21 By Alberti gfe03 的小數位數輸入時不應超過3
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

 
DEFINE 
     g_gfe           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        tc_bab01      LIKE tc_bab_file.tc_bab01,   #
        tc_bab02      LIKE tc_bab_file.tc_bab02,   #
        tc_bab03      LIKE tc_bab_file.tc_bab03,   #
        tc_bab04      LIKE tc_bab_file.tc_bab04,   #
        tc_bab05      LIKE tc_bab_file.tc_bab05,   #
        tc_bab06      LIKE tc_bab_file.tc_bab06,   #
        tc_bab07      LIKE tc_bab_file.tc_bab07,   #
        tc_bab08      LIKE tc_bab_file.tc_bab08         #FUN-A30030 ADD
                    END RECORD,
    g_gfe_t         RECORD                 #程式變數 (舊值)
        tc_bab01      LIKE tc_bab_file.tc_bab01,   #
        tc_bab02      LIKE tc_bab_file.tc_bab02,   #
        tc_bab03      LIKE tc_bab_file.tc_bab03,   #
        tc_bab04      LIKE tc_bab_file.tc_bab04,   #
        tc_bab05      LIKE tc_bab_file.tc_bab05,   #
        tc_bab06      LIKE tc_bab_file.tc_bab06,   #
        tc_bab07      LIKE tc_bab_file.tc_bab07,   #
        tc_bab08      LIKE tc_bab_file.tc_bab08         #FUN-A30030 ADD
                    END RECORD,
#    g_wc,g_sql    LIKE type_file.chr1000, #NO.TQC-630166  #No.FUN-680102 VARCHAR(300)
    g_wc,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_str                 STRING                     #No.FUN-760083
DEFINE g_msg                 LIKE type_file.chr1000                     #CHI-BB0048

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 5 LET p_col = 29
    OPEN WINDOW i101_w AT p_row,p_col WITH FORM "csf/42f/csfi012"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  
    CALL cl_ui_init()
 
    LET g_wc = '1=1'
    CALL i101_b_fill(g_wc)
    CALL i101_menu()
    CLOSE WINDOW i101_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gfe[l_ac].tc_bab01 IS NOT NULL THEN
                  LET g_doc.column1 = "tc_bab01"
                  LET g_doc.value1 = g_gfe[l_ac].tc_bab01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION
 
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT    #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用           #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否           #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態             #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102CHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1                  #No.FUN-680102CHAR(01)               #可刪除否
DEFINE l_gfepos     LIKE gfe_file.gfepos                 #FUN-B70075
DEFINE l_azo06      LIKE azo_file.azo06                  #CHI-BB0048 add

 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT  tc_bab01,tc_bab02,tc_bab03,tc_bab04,tc_bab05,tc_bab06,tc_bab07,tc_bab08 FROM tc_bab_file",   #FUN-A30030 ADD POS
                       " WHERE tc_bab01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gfe WITHOUT DEFAULTS FROM s_gfe.*
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
#No.FUN-570110 --start                                                          
               LET g_before_input_done = FALSE                                  
              
                  CALL i101_set_entry(p_cmd)                                       
                  CALL i101_set_no_entry(p_cmd)                                    
              
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end    
               LET g_gfe_t.* = g_gfe[l_ac].*  #BACKUP
               OPEN i101_bcl USING g_gfe_t.tc_bab01
               IF STATUS THEN
                  CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i101_bcl INTO g_gfe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gfe_t.tc_bab01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i101_set_entry(p_cmd)                                          
            CALL i101_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570110 --end     
            INITIALIZE g_gfe[l_ac].* TO NULL      #900423            
            #LET g_gfe[l_ac].gfepos = 'N'       #FUN-A30030 ADD #NO.FUN-B40071            
           
            LET g_gfe[l_ac].tc_bab02   = 0         #Body default
            LET g_gfe[l_ac].tc_bab03 = 0       #Body default
            LET g_gfe[l_ac].tc_bab04 = 0       #Body default
            LET g_gfe[l_ac].tc_bab05 = 0       #Body default
            LET g_gfe[l_ac].tc_bab06 = 0       #Body default
            LET g_gfe[l_ac].tc_bab07 = 0       #Body default
            LET g_gfe[l_ac].tc_bab08 = 0       #Body default
            LET g_gfe_t.* = g_gfe[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_bab01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i101_bcl
              CANCEL INSERT
           END IF
 
           BEGIN WORK                    #FUN-680010
 
           INSERT INTO tc_bab_file(tc_bab01,tc_bab02,tc_bab03,tc_bab04,tc_bab05,tc_bab06,tc_bab07,tc_bab08)  #FUN-A30030 ADD POS
                         VALUES(g_gfe[l_ac].tc_bab01,g_gfe[l_ac].tc_bab02,g_gfe[l_ac].tc_bab03,g_gfe[l_ac].tc_bab04,
                         g_gfe[l_ac].tc_bab05,g_gfe[l_ac].tc_bab06, g_gfe[l_ac].tc_bab07, g_gfe[l_ac].tc_bab08)  #FUN-A30030 POS      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             
              CALL cl_err3("ins","tc_bab_file",g_gfe[l_ac].tc_bab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK              #FUN-680010
              CANCEL INSERT
           ELSE
              ##FUN-680010
              #MESSAGE 'INSERT O.K'
              #LET g_rec_b=g_rec_b+1
              #DISPLAY g_rec_b TO FORMONLY.cn2  
           
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)新增資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
            
              COMMIT WORK
              ##FUN-680010 
           END IF
 
        AFTER FIELD tc_bab01                        #check 編號是否重複
            IF g_gfe[l_ac].tc_bab01 != g_gfe_t.tc_bab01 OR
               (g_gfe[l_ac].tc_bab01 IS NOT NULL AND g_gfe_t.tc_bab01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM tc_bab_file
                    WHERE tc_bab01 = g_gfe[l_ac].tc_bab01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gfe[l_ac].tc_bab01 = g_gfe_t.tc_bab01
                  NEXT FIELD tc_bab01
               END IF
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_gfe_t.tc_bab01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK      #FUN-680010
                   CANCEL DELETE
                END IF
              
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "tc_bab01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_gfe[l_ac].tc_bab01     #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   ROLLBACK WORK      #FUN-680010
                   CANCEL DELETE 
                END IF 
                DELETE FROM tc_bab_file WHERE tc_bab01 = g_gfe_t.tc_bab01
                IF SQLCA.sqlcode THEN

                    CALL cl_err3("del","tc_bab_file",g_gfe_t.tc_bab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    ROLLBACK WORK      #FUN-680010
                    EXIT INPUT
                END IF

                #CHI-BB0048 -- add start--
                LET g_msg = TIME
                LET l_azo06='delete'
                INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
                  VALUES ('csfi012',g_user,g_today,g_msg,g_gfe_t.tc_bab01,l_azo06,g_plant,g_legal)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","azo_file","csfi012","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
           
 
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gfe[l_ac].* = g_gfe_t.*
              CLOSE i101_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_gfe[l_ac].tc_bab01,-263,0)
               LET g_gfe[l_ac].* = g_gfe_t.*
           ELSE
          
          
               UPDATE tc_bab_file SET tc_bab01=g_gfe[l_ac].tc_bab01,
                                   tc_bab02=g_gfe[l_ac].tc_bab02,
                                   tc_bab03=g_gfe[l_ac].tc_bab03,
                                   tc_bab04=g_gfe[l_ac].tc_bab04,
                                   tc_bab05=g_gfe[l_ac].tc_bab05,
                                   tc_bab06=g_gfe[l_ac].tc_bab06,
                                   tc_bab07=g_gfe[l_ac].tc_bab07,
                                   tc_bab08=g_gfe[l_ac].tc_bab08
                                  
                WHERE tc_bab01 = g_gfe_t.tc_bab01
               IF SQLCA.sqlcode THEN
  
                  CALL cl_err3("upd","tc_bab_file",g_gfe_t.tc_bab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK     #FUN-680010 
                  LET g_gfe[l_ac].* = g_gfe_t.*
                 
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac                # 新增   #FUN-D40030 Mark
 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_gfe[l_ac].* = g_gfe_t.*
              END IF
              CLOSE i101_bcl
              ROLLBACK WORK
            
              IF p_cmd='u' THEN
              
                 LET g_gfe[l_ac].* = g_gfe_t.*
              ELSE
                 CALL g_gfe.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
             #FUN-B70075 End-----
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                #FUN-D40030 Add
           CLOSE i101_bcl
           COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i101_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_bab01) AND l_ac > 1 THEN
                LET g_gfe[l_ac].* = g_gfe[l_ac-1].*
                NEXT FIELD tc_bab01
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
 
    CLOSE i101_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i101_b_askkey()
    CLEAR FORM
   CALL g_gfe.clear()
    CONSTRUCT g_wc ON tc_bab01,tc_bab02,tc_bab03,tc_bab04,tc_bab05,tc_bab06,tc_bab07 ,tc_bab08          
            FROM s_gfe[1].tc_bab01,s_gfe[1].tc_bab02,s_gfe[1].tc_bab03,s_gfe[1].tc_bab04,s_gfe[1].tc_bab05,s_gfe[1].tc_bab06,s_gfe[1].tc_bab07 ,s_gfe[1].tc_bab08   #FUN-A30030 ADD POS
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
   # LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gfeuser', 'gfegrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i101_b_fill(g_wc)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT tc_bab01,tc_bab02,tc_bab03,tc_bmb04,tc_bab05,tc_bab06,tc_bab07 ,tc_bab08 ",                   #FUN-A30030 ADD POS
        " FROM tc_bab_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i101_pb FROM g_sql
    DECLARE gfe_curs CURSOR FOR i101_pb
 
    CALL g_gfe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gfe_curs INTO g_gfe[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gfe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gfe TO s_gfe.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i101_out()
    DEFINE
        l_gfe           RECORD LIKE tc_bab_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
   
    IF g_wc IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    LET g_str=''                                          #No.FUN-760083
    SELECT  zz05 INTO g_zz05 FROM zz_file  WHERE zz01=g_prog   #No.FUN-760083
    CALL cl_wait()
#   LET l_name = 'csfi012.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM tc_bab_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co                         # SCROLL CURSOR
         CURSOR FOR i101_p1
 
    CALL cl_outnam('csfi012') RETURNING l_name
    #START REPORT i101_rep TO l_name                        #No.FUN-760083
 
    FOREACH i101_co INTO l_gfe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        #OUTPUT TO REPORT i101_rep(l_gfe.*)                 #No.FUN-760083
    END FOREACH
 
    #FINISH REPORT i101_rep                                 #No.FUN-760083
 
    CLOSE i101_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                      #No.FUN-760083
    IF g_zz05='Y' THEN                                      #No.FUN-760083
       CALL cl_wcchp(g_wc,'tc_bab01,tc_bab02,tc_bab03,tc_bab04,tc_bab05,tc_bab06,tc_bab07,tc_bmb08') #FUN-A30020 ADD POS     #No.FUN-760083
       RETURNING g_wc                                       #No.FUN-760083
    END IF                                                  #No.FUN-760083
    LET g_str=g_wc                                          #No.FUN-760083
    CALL cl_prt_cs1("csfi012","csfi012",g_sql,g_str)        #No.FUN-760083
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i101_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680102CHAR(1),
        sr RECORD LIKE gfe_file.*,
        l_chr           LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tc_bab01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.gfeacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
            PRINT COLUMN g_c[32],sr.tc_bab01,
                  COLUMN g_c[33],sr.gfe02,
                  COLUMN g_c[34],sr.gfe03
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
#NO.TQC-630166 start--
#                    IF g_wc[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                    IF g_wc[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
            END IF
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
#No.FUN-760083  --end--
 
#No.FUN-570110 --start                                                          
FUNCTION i101_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("tc_bab01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i101_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("tc_bab01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end                  
