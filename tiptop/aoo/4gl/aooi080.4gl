# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi080.4gl
# Descriptions...: 
# Date & Author..: 91/06/21 By Lee
# Modify 		 : 94/12/05 by Nick (Convert to Multiline Task)
#                  azf02 類別可為'A' 'B' 'C'
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.MOD-580199 05/08/18 By Claire key值錯誤修正
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.MOD-6A0074 06/10/17 By Smapmin azf02類別分為2,6,8,A,D,E,F,G
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印無效資料，該報表無需“*”字樣
# Modify.........: No.FUN-740007 07/05/22 By Rayven azf02新增'S','R'選項
# Modify.........: No.FUN-760083 07/07/06 By mike 報表格式修改為ctystal reports
# Modify.........: No.FUN-810016 08/01/10 By ve007 類型增加一種：Z-制單說明類型
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960134 09/09/09 By hellen azf02新增'3'-品牌編號,'4'-理由編號,'5'-扣減項編號
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70063 10/07/12 By chenying azf02刪除'3'-品牌編號
# Modify.........: No.MOD-AC0026 10/12/06 by sabrina 新增時，azf10給預設值'N'
# Modify.........: No.FUN-B30213 11/05/18 By lixia azf02新增'T'-網銀交易類型
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_azf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        azf01       LIKE azf_file.azf01,        #部門編號
        azf02       LIKE azf_file.azf02,        #簡稱
        azf03       LIKE azf_file.azf03,        #全名
        azfacti     LIKE azf_file.azfacti       #No.FUN-680102CHAR(1), 
                    END RECORD,
    g_azf_t         RECORD                 #程式變數 (舊值)
        azf01       LIKE azf_file.azf01,   #部門編號
        azf02       LIKE azf_file.azf02,   #簡稱
        azf03       LIKE azf_file.azf03,   #全名
        azfacti     LIKE azf_file.azfacti         #No.FUN-680102CHAR(1), 
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN       
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    cb              ui.ComboBox,              #FUN-810016
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110          #No.FUN-680102 SMALLINT
DEFINE   g_str               STRING                     #No.FUN-760083
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680102 SMALLINT
     
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 25
    OPEN WINDOW i080_w AT p_row,p_col WITH FORM "aoo/42f/aooi080"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    LET cb = ui.ComboBox.forName("azf02")   #No.FUN-810016
    
    IF NOT s_industry('slk')  THEN          #No.FUN-810016
      CALL cb.removeItem('Z')               #No.FUN-810016
    END IF                                  #No.FUN-810016
    
    LET g_wc2 = '1=1' CALL i080_b_fill(g_wc2)
    CALL i080_menu()
    CLOSE WINDOW i080_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i080_menu()
 
   WHILE TRUE
      CALL i080_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i080_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i080_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i080_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_azf[l_ac].azf01 IS NOT NULL THEN
                  LET g_doc.column1 = "azf01"
                  LET g_doc.value1 = g_azf[l_ac].azf01
                  LET g_doc.column2 = "azf02"
                  LET g_doc.value2 = g_azf[l_ac].azf02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i080_q()
   CALL i080_b_askkey()
END FUNCTION
 
FUNCTION i080_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT azf01,azf02,azf03,azfacti FROM azf_file",
                       " WHERE azf01=? AND azf02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i080_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_azf WITHOUT DEFAULTS FROM s_azf.*
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
               CALL i080_set_entry(p_cmd)                                       
               CALL i080_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end      
               LET g_azf_t.* = g_azf[l_ac].*  #BACKUP
               OPEN i080_bcl USING g_azf_t.azf01,g_azf_t.azf02
               IF STATUS THEN
                  CALL cl_err("OPEN i080_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i080_bcl INTO g_azf[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_azf_t.azf01,SQLCA.sqlcode,1)
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
           CALL i080_set_entry(p_cmd)                                           
           CALL i080_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end            
           INITIALIZE g_azf[l_ac].* TO NULL      #900423
           LET g_azf[l_ac].azfacti = 'Y'         #Body default
           LET g_azf_t.* = g_azf[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD azf01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i080_bcl
              CANCEL INSERT
           END IF
           INSERT INTO azf_file(azf01,azf02,azf03,azfacti,azfuser,azfdate,azf10,azforiu,azforig)      #MOD-AC0026 add azf10
                         VALUES(g_azf[l_ac].azf01,g_azf[l_ac].azf02,
                                g_azf[l_ac].azf03,g_azf[l_ac].azfacti,g_user,g_today, 'N', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig  #MOD-AC0026 add 'N'
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_azf[l_ac].azf01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("ins","azf_file",g_azf[l_ac].azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
     
      #No.FUN-810016 --begin--
      AFTER FIELD azf01
      IF(g_azf[l_ac].azf02 MATCHES 'Z') THEN
        IF(g_azf[l_ac].azf01 MATCHES '1' OR g_azf[l_ac].azf01 MATCHES '2' 
          OR g_azf[l_ac].azf01 MATCHES '3' OR g_azf[l_ac].azf01 MATCHES '4'
          OR LENGTH(g_azf[l_ac].azf01)>1) THEN
             CALL cl_err('','aoo-252',0)
             LET g_azf[l_ac].azf01=g_azf_t.azf01
             NEXT FIELD azf01 
         END IF
       END IF
      #No.FUN-810016 --end--
    
     	AFTER FIELD azf02
           IF NOT cl_null(g_azf[l_ac].azf02) THEN
              #IF g_azf[l_ac].azf02 NOT MATCHES '[ABCDEFG23568]' THEN  #MOD-6A0074
#             IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFG268]' THEN       #MOD-6A0074  #No.FUN-740007 mark
            IF NOT s_industry('slk') THEN                              #No.FUN-810016
#             IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFGSR268]' THEN     #No.FUN-740007 #No.FUN-960134 mark
#              IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFGSR234568]' THEN  #No.FUN-960134 add '345' #No.FUN-A70063 mark 
              #IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFGSR24568]' THEN  #No.FUN-A70063 del '3' 
              IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFGSRT24568]' THEN   #FUN-B30213 
                 CALL cl_err(g_azf[l_ac].azf02,'aoo-109',1)
                 NEXT FIELD azf02
              END IF    
            ELSE                                             #No.FUN-810016              
              IF g_azf[l_ac].azf02 NOT MATCHES '[ADEFGSR268Z]' THEN   #No.FUN-810016
                 CALL cl_err(g_azf[l_ac].azf02,'aoo-109',1)
                 NEXT FIELD azf02
               END IF   
            END IF                                          #No.FUN-810016             
                 
             
              #No.FUN--810016 --begin--
              IF(g_azf[l_ac].azf02 MATCHES 'Z') THEN
                IF(g_azf[l_ac].azf01 MATCHES '1' OR g_azf[l_ac].azf01 MATCHES '2' 
                   OR g_azf[l_ac].azf01 MATCHES '3' OR g_azf[l_ac].azf01 MATCHES '4'
                   OR LENGTH(g_azf[l_ac].azf01)>1) THEN
                     LET g_azf[l_ac].azf01=g_azf_t.azf01
                     CALL cl_err('','aoo-252',0)
                     NEXT FIELD azf01 
                END IF
              END IF 
              #No.FUN-810016  --end--
            
              IF (g_azf[l_ac].azf01 != g_azf_t.azf01 OR g_azf_t.azf01 IS NULL) 
                 OR (g_azf[l_ac].azf02 != g_azf_t.azf02 OR g_azf_t.azf02 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM azf_file
                   WHERE azf01 = g_azf[l_ac].azf01
                     AND azf02 = g_azf[l_ac].azf02
                  IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_azf[l_ac].azf02 = g_azf_t.azf02
                      NEXT FIELD azf02
                  END IF
              END IF
           END IF
 
        AFTER FIELD azfacti
           IF NOT cl_null(g_azf[l_ac].azfacti) THEN
              IF g_azf[l_ac].azfacti NOT MATCHES '[YN]' OR
                 cl_null(g_azf[l_ac].azfacti) THEN
                 LET g_azf[l_ac].azfacti = g_azf_t.azfacti
                 NEXT FIELD azfacti
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_azf_t.azf01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
               LET g_doc.column1 = "azf01"               #No.FUN-9B0098 10/02/24
               LET g_doc.value1 = g_azf[l_ac].azf01      #No.FUN-9B0098 10/02/24
               LET g_doc.column2 = "azf02"               #No.FUN-9B0098 10/02/24
               LET g_doc.value2 = g_azf[l_ac].azf02      #No.FUN-9B0098 10/02/24
               CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM azf_file WHERE azf01 = g_azf_t.azf01
                                      AND azf02 = g_azf_t.azf02 #MOD-580199
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_azf_t.azf01,SQLCA.sqlcode,0)   #No.FUN-660131
                  CALL cl_err3("del","azf_file",g_azf_t.azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_azf[l_ac].* = g_azf_t.*
              CLOSE i080_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_azf[l_ac].azf01,-263,0)
               LET g_azf[l_ac].* = g_azf_t.*
           ELSE
               UPDATE azf_file 
                  SET azf01=g_azf[l_ac].azf01,azf02=g_azf[l_ac].azf02,
                      azf03=g_azf[l_ac].azf03,azfacti=g_azf[l_ac].azfacti,
                      azfmodu=g_user,azfdate=g_today
                WHERE azf01=g_azf_t.azf01
                  AND azf02=g_azf_t.azf02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_azf[l_ac].azf01,SQLCA.sqlcode,0)   #No.FUN-660131
                   CALL cl_err3("upd","azf_file",g_azf_t.azf01,g_azf_t.azf02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   LET g_azf[l_ac].* = g_azf_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac             # 新增   #FUN-D40030 Mark
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_azf[l_ac].* = g_azf_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_azf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--   
              END IF
              CLOSE i080_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac                    #FUN-D40030 Add 
           CLOSE i080_bcl            # 新增
           COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i080_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(azf01) AND l_ac > 1 THEN
                LET g_azf[l_ac].* = g_azf[l_ac-1].*
                NEXT FIELD azf01
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
 
 
    CLOSE i080_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i080_b_askkey()
    CLEAR FORM
   CALL g_azf.clear()
    CONSTRUCT g_wc2 ON azf01,azf02,azf03,azfacti
         FROM s_azf[1].azf01,s_azf[1].azf02,s_azf[1].azf03,s_azf[1].azfacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('azfuser', 'azfgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i080_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i080_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT azf01,azf02,azf03,azfacti",
        " FROM azf_file",
        " WHERE ", p_wc2 CLIPPED                     #單身
        
    #No.FUN-810016  --begin--   
    IF NOT s_industry('slk') THEN
       LET g_sql = g_sql, " AND azf02!= 'Z' ORDER BY azf02,azf01"
    ELSE       
       LET g_sql = g_sql, "  ORDER BY azf02,azf01"
    END IF     
    #No.FUN-810016  --end--   
     
    PREPARE i080_pb FROM g_sql
    DECLARE azf_curs CURSOR FOR i080_pb
 
    CALL g_azf.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH azf_curs INTO g_azf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_azf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i080_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azf TO s_azf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i080_out()
    DEFINE
        l_azf           RECORD LIKE azf_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05             #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0)
       CALL cl_err('','9057',0)
     RETURN 
    END IF
    #CALL cl_wait()                                #No.FUN-760083
#   LET l_name = 'aooi080.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM azf_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#No.FUN-760083  --begin--
{
    PREPARE i080_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i080_co                         # SCROLL CURSOR
         CURSOR FOR i080_p1
 
    CALL cl_outnam('aooi080') RETURNING l_name
    START REPORT i080_rep TO l_name         
 
    FOREACH i080_co INTO l_azf.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i080_rep(l_azf.*)
    END FOREACH
 
    FINISH REPORT i080_rep
 
    CLOSE i080_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 ='Y' THEN
       CALL cl_wcchp(g_wc2,'azf01,azf02,azf03,azfacti')
        RETURNING g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs1("aooi080","aooi080",g_sql,g_str)  
#No.FUN-760083  --end--
END FUNCTION
 
#No.FUN-760083  --begin--
{
REPORT i080_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE azf_file.*,
        l_cate          LIKE zaa_file.zaa08          #No.FUN-680102 VARCHAR(16)    #紀錄類別字串
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.azf02,sr.azf01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,     # No.TQC-750041
            PRINT g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,                     # No.TQC-750041
                  g_x[35] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            CASE WHEN sr.azf02='2'
                  LET l_cate=sr.azf02,g_x[9] CLIPPED 
                 #-----MOD-6A0074---------
                 #WHEN sr.azf02='3'
                 # LET l_cate=sr.azf02,g_x[10] CLIPPED 
                 #WHEN sr.azf02='5'
                 # LET l_cate=sr.azf02,g_x[11] CLIPPED 
                 #-----END MOD-6A0074-----
                 WHEN sr.azf02='6'
                  LET l_cate=sr.azf02,g_x[12] CLIPPED 
                 WHEN sr.azf02='8'
                  LET l_cate=sr.azf02,g_x[13] CLIPPED 
                 WHEN sr.azf02='A'
                  LET l_cate=sr.azf02,g_x[14] CLIPPED 
                 #-----MOD-6A0074---------
                 #WHEN sr.azf02='B'
                 # LET l_cate=sr.azf02,g_x[15] CLIPPED 
                 #WHEN sr.azf02='C'
                 # LET l_cate=sr.azf02,g_x[16] CLIPPED 
                 #-----END MOD-6A0074-----
                 WHEN sr.azf02='D'
                  LET l_cate=sr.azf02,g_x[17] CLIPPED 
                 WHEN sr.azf02='E'
                  LET l_cate=sr.azf02,g_x[18] CLIPPED 
                 WHEN sr.azf02='F'
                  LET l_cate=sr.azf02,g_x[19] CLIPPED 
                 WHEN sr.azf02='G'
                  LET l_cate=sr.azf02,g_x[20] CLIPPED 
                 #No.FUN-740007 --start--
                 WHEN sr.azf02='S'
                  LET l_cate=sr.azf02,g_x[21] CLIPPED
                 WHEN sr.azf02='R'
                  LET l_cate=sr.azf02,g_x[22] CLIPPED
                 #No.FUN-740007 --end--
 
            END CASE
# No.TQC-750041-- begin
#           IF sr.azfacti = 'N' 
#               THEN PRINT COLUMN g_c[31],'* ';
#           END IF
# No.TQC-750041-- end
            PRINT COLUMN g_c[32],sr.azf01,
                  COLUMN g_c[33],l_cate,
                  COLUMN g_c[34],sr.azf03,
                  COLUMN g_c[35],sr.azfacti
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
#No.FUN-760083 --begin--
 
#No.FUN-570110 --start                                                          
FUNCTION i080_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azf01,azf02",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i080_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("azf01,azf02",FALSE)                                
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end            
 
