# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli100.4gl
# Descriptions...: 會計科目 FM
# Date & Author..: 94/11/21 By Roger
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0110 04/12/20 By Nicola 統制科目寫入錯誤
# Modify.........: No.FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: No.MOD-510053 05/01/24 By Kitty  有效碼控制有誤
# Modify.........: No.MOD-4C0171 05/02/15 By Smapmin 接收參數時,第一個必為帳別,若第一個不是帳別,則加入Null
# Modify.........: No.MOD-530627 05/04/18 By Nicola 若為統制科目或獨立科目,修改時,所屬統制科目會不見
#                                                   新增科目層級(aag24)欄位
#                                                   為統制或獨立科目時，aag08預設為aag01，不可修改
# Modify.........: No.FUN-560066 05/06/27 By ching insert default aag20='N'
# Modify.........: No.MOD-560150 05/06/29 By Nicola 「輸入科目明細資料」或「維護科目額外說明」等功能無效
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改
#
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-590124 05/10/05 By Dido 表尾寬度修改
# Modify.........: No.TQC-5B0097 05/11/14 By day  報表依選項打印，打印結構表時調用gglr001
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730020 07/03/13 By Carrier 會計科目加帳套
# Modify.........: No.FUN-760085 07/07/26 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.TQC-7A0083 07/10/23 By chenl   1.區域功能為大陸時，所屬統制帳戶科目可以輸入。
# Modify.........:                                   2.修改新增時，退出卡死的bug
# Modify.........:                                   3.若統制科目下已經明細科目，則該統制科目不可刪除！
# Modify.........: No.MOD-7A0139 07/10/24 By chenl 若所屬科目為其本身，且為統制科目時，可以錄入。
# Modify.........: No.TQC-7B0102 07/11/16 By Rayven 打印科目結構表報錯：無資料
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串  
# Modify.........: No.MOD-910009 09/01/04 By sherry 獨立科目不能設為無效
# Modify.........: No.TQC-950029 09/05/07 By xiaofeizhu 科目編號(aag01)欄位可錄入任意字符，未有相應管控
# Modify.........: No.TQC-950205 09/05/31 By xiaofeizhu 將對科目編號的管控去除
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0232 09/12/19 By sherry 查詢出來的資料請依 帳別+科目編號 排序 顯示.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30077 10/03/23 By Carrier 增加aag42 按余额类型产生分录
# Modify.........: No.FUN-A40020 10/04/07 By Carrier 独立科目层及设置为1
# Modify.........: No:CHI-A40054 10/05/06 By Summer 1.刪除卡關是卡abb_file
#                                                   2.刪除時,刪除相關的會計科目的基本設定
# Modify.........: No:MOD-AB0136 10/11/15 By Dido 統制科目若有層級概念時,不可帶自身的科目為統制科目 
# Modify.........: No.MOD-B80030 11/08/03 By Dido 刪除時應與 agli102 相同檢核
# Modify.........: No.TQC-B80159 11/08/19 By Dido 有效碼異動時需檢核 
# Modify.........: No.MOD-B80325 11/08/30 By Polly 修正call i100_b()並無變數接收，將reture 1改為 NEXT FIELD aag01
# Modify.........: No.MOD-C30718 12/03/16 By zhangweib 新增AFTER FIELD aag24 條件控卡
# Modify.........: No.MOD-C90140 12/09/20 By Polly 新增時給予aag38預設值為'N'
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.TQC-D70091 13/07/25 By yinhy 獨立科目應遵循agls103中aaz107設定的碼長
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aag        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                       aag00       LIKE aag_file.aag00,       #帳號  #No.FUN-730020
                       aag01       LIKE aag_file.aag01,       #科目編號
                       aag02       LIKE aag_file.aag02,       #簡稱
                       aag03       LIKE aag_file.aag03,       #
                       aag04       LIKE aag_file.aag04,       #
                       aag05       LIKE aag_file.aag05,       #
                       aag07       LIKE aag_file.aag07,       #
                       aag08       LIKE aag_file.aag08,       #
                       aag24       LIKE aag_file.aag24,       #No.MOD-530627
                       aagacti     LIKE aag_file.aagacti      #No.FUN-680098   VARCHAR(1)
                    END RECORD,
       g_aag_t      RECORD                     #程式變數 (舊值)
                       aag00       LIKE aag_file.aag00,       #帳號  #No.FUN-730020
                       aag01       LIKE aag_file.aag01,       #科目編號
                       aag02       LIKE aag_file.aag02,       #簡稱
                       aag03       LIKE aag_file.aag03,       #
                       aag04       LIKE aag_file.aag04,       #
                       aag05       LIKE aag_file.aag05,       #
                       aag07       LIKE aag_file.aag07,       #
                       aag08       LIKE aag_file.aag08,       #
                       aag24       LIKE aag_file.aag24,       #No.MOD-530627
                       aagacti     LIKE aag_file.aagacti       #No.FUN-680098 VARCHAR(1)  
                    END RECORD,
       g_wc,g_sql   STRING,#TQC-630166 
       g_rec_b      LIKE type_file.num5,                #單身筆數                   #No.FUN-680098 SMALLINT
       l_ac         LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680098  SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5                 #No.FUN-680098 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done    STRING
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE g_str        STRING                       #No.FUN-760085
DEFINE g_bookno     LIKE aaa_file.aaa01          #No.TQC-7B0102
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0073
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW i100_w AT p_row,p_col
     WITH FORM "agl/42f/agli100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc = '1=1'
 
   CALL i100_b_fill(g_wc)
 
   CALL i100_menu()
 
   CLOSE WINDOW i100_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL i100_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN  # FUN-570200
               IF g_aag[l_ac].aag01 IS NOT NULL THEN
                  #No.FUN-730020  --Begin
                  LET g_doc.column1 = "aag00"
                  LET g_doc.value1 = g_aag[l_ac].aag00
                  LET g_doc.column2 = "aag01"
                  LET g_doc.value2 = g_aag[l_ac].aag01
                  #No.FUN-730020  --End  
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aag),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i100_q()
 
   CALL i100_b_askkey()
 
END FUNCTION
 
FUNCTION i100_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680098 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680098 SMALLINT
          p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680098 VARCHAR(1)
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680098 VARCHAR(1)
          aag08_t         LIKE aag_file.aag08,              #                     #No.FUN-680098 VARCHAR(24)  
          l_aaaacti       LIKE aaa_file.aaaacti,              #No.FUN-730020
          l_allow_insert  LIKE type_file.chr1,                #可新增否           #No.FUN-680098 VARCHAR(1)  
          l_allow_delete  LIKE type_file.chr1                 #可刪除否           #No.FUN-680098 VARCHAR(1)
   DEFINE g_flag2         LIKE type_file.chr1                 #No.TQC-950205 
   DEFINE l_t1            STRING                              #No.TQC-950205
   DEFINE l_t2            LIKE type_file.num5                 #No.TQC-950205
   DEFINE l_t3            LIKE type_file.num5                 #No.TQC-950205
   DEFINE l_aag24         LIKE aag_file.aag24                 #No.TQC-950205            
   DEFINE l_ret           LIKE type_file.chr1                 #No.FUN-A40020    
   DEFINE l_length        LIKE type_file.num5                 #No.FUN-A40020
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT aag00,aag01,aag02,aag03,aag04,aag05,aag07,aag08,aag24,aagacti ",   #No.MOD-530627  #No.FUN-730020
                      "  FROM aag_file WHERE aag00=? AND aag01= ?  FOR UPDATE "  #No.FUN-730020
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_aag WITHOUT DEFAULTS FROM s_aag.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_aag_t.* = g_aag[l_ac].*  #BACKUP
            OPEN i100_bcl USING g_aag_t.aag00,g_aag_t.aag01  #No.FUN-730020
            IF STATUS THEN
               CALL cl_err("OPEN i100_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i100_bcl INTO g_aag[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aag_t.aag01,STATUS,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            #-----No.MOD-530627 Mark-----
           #IF g_aag[l_ac].aag07 MATCHES'[13]' THEN
           #   LET g_aag[l_ac].aag08 = NULL
           #END IF
            #-----No.MOD-530627 Mark END-----
 
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
#No.FUN-570108 --start--
         LET  g_before_input_done = FALSE
         CALL i100_set_entry(p_cmd)
         CALL i100_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
         INITIALIZE g_aag[l_ac].* TO NULL
         LET g_aag[l_ac].aagacti = 'Y'         #Body default
         LET g_aag[l_ac].aag03 = '2'           #Body default
         LET g_aag[l_ac].aag04 = '1'           #Body default
         LET g_aag[l_ac].aag05 = 'N'           #No.FUN-A40020
         LET g_aag[l_ac].aag24 = 1             #MOD-AB0136
         LET g_aag_t.* = g_aag[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD aag00  #No.FUN-730020
 
      AFTER INSERT
         IF INT_FLAG THEN                      #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
     #      CLOSE i100_bcl    #No.TQC-7A0083 mark
         END IF
 
          #-----No.MOD-4C0110-----
        #-MOD-AB0136-mark-
        #IF g_aag[l_ac].aag07 MATCHES'[13]' THEN
        #   LET aag08_t = g_aag[l_ac].aag01
        #ELSE
        #   LET aag08_t = g_aag[l_ac].aag08
        #END IF
        #-MOD-AB0136-end-
          #-----No.MOD-4C0110 END-----
 
         INSERT INTO aag_file
              (aag00,aag01,aag02,aag03,aag04,aag05,aag07,aag08,aag24,#No.MOD-530627                   #No.FUN-730020
               aag06,aag09,aag19,aag20,aag21,aag23,aagacti,aaguser,aagdate,aagoriu,aagorig,aag42,     #FUN-560066  #No.FUN-A30077
               aag38)                                                                                 #MOD-C90140 add aag38
              VALUES(g_aag[l_ac].aag00,g_aag[l_ac].aag01,g_aag[l_ac].aag02,g_aag[l_ac].aag03,         #No.FUN-730020
                     g_aag[l_ac].aag04,g_aag[l_ac].aag05,g_aag[l_ac].aag07,                           
                    #aag08_t,g_aag[l_ac].aag24, #No:MOD-530627                                        #MOD-AB0136 mark
                     g_aag[l_ac].aag08,g_aag[l_ac].aag24,                                             #No:MOD-530627 #MOD-AB0136
                     '1','Y','30','N','N','N', #FUN-560066
                     g_aag[l_ac].aagacti,g_user,g_today, g_user, g_grup,'N',                          #No.FUN-980030 10/01/04  insert columns oriu, orig  #No.FUN-A30077
                     'N')                                                                             #MOD-C90140 add
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aag[l_ac].aag01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","aag_file",g_aag[l_ac].aag00,g_aag[l_ac].aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      #No.FUN-730020  --Begin
      AFTER FIELD aag01,aag00  #No.FUN-730020  #check 編號是否重複
         IF NOT cl_null(g_aag[l_ac].aag00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_aag[l_ac].aag00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",g_aag[l_ac].aag00,"",100,"","",1)            
               NEXT FIELD aag00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_aag[l_ac].aag00,"9028",1)                                    
               NEXT FIELD aag00                                                 
            END IF                                                               
         END IF
         
         #TQC-950205--Mark--Begin--#
         #TQC-950029--Begin--#
#        IF NOT cl_null(g_aag[l_ac].aag01) THEN
#           IF p_cmd = 'a' OR p_cmd = 'u' AND (
#                             g_aag[l_ac].aag01 != g_aag_t.aag01) THEN
#              LET l_n = 0                
#              SELECT COUNT(*) INTO l_n FROM aag_file
#               WHERE aag01 = g_aag[l_ac].aag01 
#              IF l_n = 0 THEN
#                 CALL cl_err('','aap-021',0)
#                 NEXT FIELD aag01
#              END IF
#           END IF
#        END IF
         #TQC-950029--End--#         
         #TQC-950205--Mark--End--#         
 
         IF NOT cl_null(g_aag[l_ac].aag01) AND NOT cl_null(g_aag[l_ac].aag00) THEN
            IF p_cmd = 'a' OR p_cmd = 'u' AND (
                              g_aag[l_ac].aag01 != g_aag_t.aag01 OR
                              g_aag[l_ac].aag00 != g_aag_t.aag00 ) THEN
               SELECT COUNT(*) INTO l_n FROM aag_file
                WHERE aag01 = g_aag[l_ac].aag01
                  AND aag00 = g_aag[l_ac].aag00  
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_aag[l_ac].aag01 = g_aag_t.aag01
                  LET g_aag[l_ac].aag00 = g_aag_t.aag00
                  NEXT FIELD aag00
               END IF
            END IF
         END IF
      #No.FUN-730020  --End
      
         #TQC-950205--Begin--#
         IF NOT cl_null(g_aag[l_ac].aag01) THEN
            IF p_cmd = 'a' OR p_cmd = 'u' AND (
                              g_aag[l_ac].aag01 != g_aag_t.aag01 ) THEN                                                      
               CALL s_field_chk(g_aag[l_ac].aag01,'6',g_plant,'aag01') RETURNING g_flag2
               IF g_flag2 = '0' THEN                                            
                  CALL cl_err(g_aag[l_ac].aag01,'aoo-043',1)                          
                  LET g_aag[l_ac].aag01 = g_aag_t.aag01                                 
                  NEXT FIELD aag01                                              
               END IF   
               IF i100_chk_aag01(g_aag[l_ac].aag01) THEN 
                  NEXT FIELD aag01
               END IF
               CALL LENGTH(g_aag[l_ac].aag01) RETURNING l_length      #TQC-D70091
              #-MOD-AB0136-add-
               #若編碼符合規範，則調用預設函數i100_def()
                CALL i100_def(g_aag[l_ac].aag01,g_aaz.aaz107,g_aaz.aaz108,l_length,'1')
                    RETURNING l_ret
                IF l_ret <> 'Y' THEN 
                 #RETURN 1                         #No.MOD-B80325 mark
                  NEXT FIELD aag01                 #No.MOD-B80325 add 
                END IF 
                DISPLAY BY NAME g_aag[l_ac].aag08   
              #-MOD-AB0136-end-
            END IF  
         END IF         
         #TQC-950205--End--#        
 
      AFTER FIELD aag03
         IF NOT cl_null(g_aag[l_ac].aag03) THEN
            IF g_aag[l_ac].aag03 NOT MATCHES'[24]' THEN
               NEXT FIELD aag03
            END IF
         END IF
 
      AFTER FIELD aag04
         IF NOT cl_null(g_aag[l_ac].aag04) THEN
            IF g_aag[l_ac].aag04 NOT MATCHES'[12]' THEN
               NEXT FIELD aag04
            END IF
         END IF
 
      AFTER FIELD aag05
         IF cl_null(g_aag[l_ac].aag05) OR g_aag[l_ac].aag05 NOT MATCHES'[YN]' THEN
            NEXT FIELD aag05
         END IF
 
      BEFORE FIELD aag07
         CALL i100_set_entry(p_cmd)
 
      AFTER FIELD aag07
         IF NOT cl_null(g_aag[l_ac].aag07) THEN
            IF g_aag[l_ac].aag07 NOT MATCHES'[123]' THEN
               NEXT FIELD aag07
            END IF
         END IF
        #IF g_aag[l_ac].aag07 MATCHES'[13]' THEN                  #MOD-AB0136 mark
         IF g_aag[l_ac].aag07 MATCHES'[13]' AND p_cmd='a' THEN    #MOD-AB0136
             LET g_aag[l_ac].aag08 = g_aag[l_ac].aag01   #No.MOD-530627
         END IF
         #No.FUN-A40020  --Begin                                                
         IF p_cmd = 'a' OR p_cmd = 'u' AND g_aag[l_ac].aag07 <> g_aag_t.aag07 THEN                                                                              
            LET l_length=LENGTH(g_aag[l_ac].aag01)                              
            CALL i100_def(g_aag[l_ac].aag01,g_aaz.aaz107,g_aaz.aaz108,l_length,'2')                                                                             
                 RETURNING l_ret                                                
            IF l_ret <> 'Y' THEN                                                
               NEXT FIELD aag07                                                 
            END IF                                                              
         END IF                                                                 
         LET g_aag_t.aag07 = g_aag[l_ac].aag07                                  
         #No.FUN-A40020  --End
         #------MOD-5A0095 START----------
         DISPLAY BY NAME g_aag[l_ac].aag08
         #------MOD-5A0095 END------------
         CALL i100_set_no_entry(p_cmd)

     #No.MOD-C30718   ---start---   Add
      AFTER FIELD aag24
         IF g_aag[l_ac].aag24 <=0 THEN
            CALL cl_err('','ggl-816',0)
            NEXT FIELD aag24
         END IF
         IF g_aag[l_ac].aag07 = '1' AND g_aag[l_ac].aag24 = 1 THEN
            LET g_aag[l_ac].aag08 = g_aag[l_ac].aag01
         END IF
         IF g_aag[l_ac].aag07 = '1' AND g_aag[l_ac].aag24 > 1 THEN
            SELECT * FROM aag_file
             WHERE aag01=g_aag[l_ac].aag08 AND aag07='1'
               AND aag00=g_aag[l_ac].aag00
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aag_file",g_aag[l_ac].aag08,"","agl-001","","",1)
               NEXT FIELD aag08
            END IF
         END IF
         IF g_aag[l_ac].aag07 = '2' AND NOT cl_null(g_aag[l_ac].aag24) THEN
            IF g_aag[l_ac].aag24 <> '99' THEN
               LET g_aag[l_ac].aag24 = '99'
               DISPLAY BY NAME g_aag[l_ac].aag24
               NEXT FIELD aag24
            END IF
         END IF
         IF (g_aag[l_ac].aag07 = '3' AND NOT cl_null(g_aag[l_ac].aag24)) 
            OR (g_aag[l_ac].aag07 = '1' AND g_aag[l_ac].aag08 = g_aag[l_ac].aag01) THEN 
            IF g_aag[l_ac].aag24 <> '1' THEN
               LET g_aag[l_ac].aag24 = '1'
               DISPLAY BY NAME g_aag[l_ac].aag24
               NEXT FIELD aag24
            END IF
         END IF
         CALL s_field_chk(g_aag[l_ac].aag24,'6',g_plant,'aag24') RETURNING g_flag2
         IF g_flag2 = '0' THEN
            CALL cl_err(g_aag[l_ac].aag24,'aoo-043',1)
            LET g_aag[l_ac].aag24 = g_aag_t.aag24
            DISPLAY BY NAME g_aag[l_ac].aag24
            NEXT FIELD aag24
         END IF
     #No.MOD-C30718   ---end---     Add
 
      AFTER FIELD aag08
         IF NOT cl_null(g_aag[l_ac].aag08)  THEN
           #-MOD-AB0136-add-
            SELECT COUNT(*) INTO l_n FROM aaz_file   
             WHERE aaz00 ='0' AND (aaz107 IS NOT NULL AND aaz108 IS NOT NULL) 
            IF l_n > 0 THEN    
               #IF i100_chk_aag01(g_aag[l_ac].aag01) THEN              #TQC-D70091
               IF i100_chk(g_aag[l_ac].aag01,g_aag[l_ac].aag08) THEN   #TQC-D70091
                  NEXT FIELD aag08   
               END IF        
            END IF   
           #-MOD-AB0136-end-
         END IF               #MOD-AB0136
        #IF NOT (g_aag[l_ac].aag07 = '1' AND g_aag[l_ac].aag08 = g_aag[l_ac].aag01) THEN  #No.MOD-7A0139  #MOD-910009
        #IF NOT (g_aag[l_ac].aag07 MATCHES '[13]' AND g_aag[l_ac].aag08 = g_aag[l_ac].aag01) THEN  #No.MOD-7A0139   #MOD-910009 #MOD-AB0136 mark
         IF g_aag[l_ac].aag07='2' AND NOT cl_null(g_aag[l_ac].aag08) OR (g_aag[l_ac].aag07='1' AND g_aag[l_ac].aag24 > 1) THEN  #MOD-AB0136 
            SELECT COUNT(*) INTO l_n FROM aag_file
             WHERE aag01 = g_aag[l_ac].aag08
               AND aag07 = '1'
               AND aag00 = g_aag[l_ac].aag00
            IF l_n = 0 THEN
              #CALL cl_err(g_aag[l_ac].aag08,'agl-202',0)  #TQC-7A0083 mark
               CALL cl_err(g_aag[l_ac].aag08,'abg-010',0)  #TQC-7A0083
               NEXT FIELD aag08
            END IF
         END IF    #No.MOD-7A0139
        #-MOD-AB0136-add-
         IF g_aag[l_ac].aag07 MATCHES '[3]' THEN  
            LET g_aag[l_ac].aag24 = 1       
         END IF                            
         IF g_aag[l_ac].aag07 MATCHES '[1]' THEN 
            SELECT aag24 INTO g_aag[l_ac].aag24 FROM aag_file
             WHERE aag01 = g_aag[l_ac].aag08
               AND aag00 = g_aag[l_ac].aag00   
            IF cl_null(g_aag[l_ac].aag24) THEN
               LET g_aag[l_ac].aag24 = 0
            END IF
            IF (g_aag[l_ac].aag08 != g_aag[l_ac].aag01)  THEN  
               LET g_aag[l_ac].aag24 = g_aag[l_ac].aag24 + 1
            ELSE                               
               LET g_aag[l_ac].aag24 = 1            
            END IF
         END IF
         IF g_aag[l_ac].aag07 = '2' THEN
            LET g_aag[l_ac].aag24 = 99
         END IF
         DISPLAY BY NAME g_aag[l_ac].aag24
        #-MOD-AB0136-end-
        #END IF         #MOD-AB0136 mark
 
       #No.MOD-510053
      #BEFORE FIELD aagacti
      #   LET g_aag[l_ac].aagacti='Y'
 
      AFTER FIELD aagacti
         IF NOT cl_null(g_aag[l_ac].aagacti) THEN
            IF g_aag[l_ac].aagacti NOT MATCHES '[YN]' THEN
               LET g_aag[l_ac].aagacti = g_aag_t.aagacti
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_aag[l_ac].aagacti
               #------MOD-5A0095 END------------
               NEXT FIELD aagacti
            END IF
           #-TQC-B80159-add- 
            IF g_aag[l_ac].aagacti = 'N' THEN
               CALL i100_chk_x()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aag_t.aag01,g_errno,1)
                  NEXT FIELD aagacti
               END IF
            END IF
           #-TQC-B80159-end- 
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_aag_t.aag01 IS NOT NULL THEN
            #CHI-A40054 mark --start--
            #SELECT COUNT(*) INTO l_n FROM aah_file
            # WHERE aah01 = g_aag_t.aag01
            #   AND aah00 = g_aag_t.aag00   #No.FUN-730020
            #IF l_n>0 THEN
            #   CALL cl_err(g_aag_t.aag01,'agl-190',1)
            #   CANCEL DELETE
            #END IF
            #CHI-A40054 mark --end--

           #-MOD-B80030-add- 
            CALL i100_chk_x()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_aag_t.aag01,g_errno,1)
               CANCEL DELETE
            END IF
           #-MOD-B80030-end- 

            #CHI-A40054 add --start--
            SELECT COUNT(*) INTO l_n FROM abb_file
             WHERE abb03 = g_aag_t.aag01
               AND abb00 = g_aag_t.aag00 
            IF l_n > 0 THEN 
               CALL cl_err(g_aag_t.aag01,'agl-220',1) 
               CANCEL DELETE
            END IF
            #CHI-A40054 add --end--
 
           #No.TQC-7A0083--begin--
            SELECT COUNT(*) INTO l_n FROM aag_file
             WHERE aag01 <> g_aag_t.aag01 
               AND aag08 = g_aag_t.aag01 
               AND aag00 = g_aag_t.aag00
            IF l_n > 0  THEN
               CALL cl_err(g_aag_t.aag01,'agl-302',0)
               CANCEL DELETE
            END IF
           #No.TQC-7A0083---end---
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "aag00"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_aag[l_ac].aag00      #No.FUN-9B0098 10/02/24
            LET g_doc.column2 = "aag01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value2 = g_aag[l_ac].aag01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
 
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM aag_file WHERE aag01 = g_aag_t.aag01
                                   AND aag00 = g_aag_t.aag00  #No.FUN-730020
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aag_t.aag01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aag_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
               ROLLBACK WORK
               CANCEL DELETE
            END IF

           #CHI-A40054 add --start--
            DELETE FROM aak_file WHERE aak01 = g_aag_t.aag01
                                   AND aak00 = g_aag_t.aag00  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aak_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            DELETE FROM aee_file WHERE aee01 = g_aag_t.aag01
                                   AND aee00 = g_aag_t.aag00
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","aee_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            DELETE FROM maj_file WHERE maj21 = g_aag_t.aag01
                                   AND maj22 = g_aag_t.aag01 
                                   AND maj01 IN (                      
                 SELECT mai01 FROM mai_file WHERE mai00= g_aag_t.aag00) 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","maj_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE
            END IF
           #CHI-A40054 add --end--

            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aag[l_ac].* = g_aag_t.*
            CLOSE i100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
        #-MOD-AB0136-mark-
        #IF g_aag[l_ac].aag07 MATCHES'[13]' THEN
        #   LET aag08_t = g_aag[l_ac].aag01
        #ELSE
        #   LET aag08_t = g_aag[l_ac].aag08
        #END IF
        #-MOD-AB0136-end-
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_aag[l_ac].aag01,SQLCA.sqlcode,0)
            LET g_aag[l_ac].* = g_aag_t.*
            ROLLBACK WORK
         ELSE
            UPDATE aag_file SET aag01 = g_aag[l_ac].aag01,
                                aag00 = g_aag[l_ac].aag00,   #No.FUN-730020
                                aag02 = g_aag[l_ac].aag02,
                                aag03 = g_aag[l_ac].aag03,
                                aag04 = g_aag[l_ac].aag04,
                                aag05 = g_aag[l_ac].aag05,
                                aag07 = g_aag[l_ac].aag07,
                               #aag08 = aag08_t,               #MOD-AB0136 mark
                                aag08 = g_aag[l_ac].aag08,     #MOD-AB0136
                                aag24 = g_aag[l_ac].aag24,     #No.MOD-530627
                                aagacti = g_aag[l_ac].aagacti,
                                aagmodu = g_user,
                                aagdate = g_today
             WHERE aag01 = g_aag_t.aag01
               AND aag00 = g_aag_t.aag00  #No.FUN-730020
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aag[l_ac].aag01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","aag_file",g_aag_t.aag00,g_aag_t.aag01,SQLCA.sqlcode,"","",1)  #No.FUN-660123  #No.FUN-730020
               LET g_aag[l_ac].* = g_aag_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
        #LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aag[l_ac].* = g_aag_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_aag.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i100_bcl            # 新增
            ROLLBACK WORK             # 新增
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i100_bcl #FUN-D30032 add 
         COMMIT WORK
 
      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aag00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_aag[l_ac].aag00
               CALL cl_create_qry() RETURNING g_aag[l_ac].aag00
               DISPLAY BY NAME g_aag[l_ac].aag00
               NEXT FIELD aag00  
            OTHERWISE
               EXIT CASE
         END CASE
      #No.FUN-730020  --End  
 
      ON ACTION enter_account_detail
         CLOSE i100_bcl
          LET g_msg = "agli102 '",g_aag[l_ac].aag00,"' '",g_aag[l_ac].aag01,"'"   #NO.MOD-560150  #No.FUN-730020
          CALL cl_cmdrun(g_msg) #MOD-4C0171
 
      ON ACTION account_extra_description
          LET g_msg = "agli103 '",g_aag[l_ac].aag00,"' '",g_aag[l_ac].aag01,"'"   #NO.MOD-560150  #No.FUN-730020
          CALL cl_cmdrun(g_msg) #MOD-4C0171
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aag01) AND l_ac > 1 THEN
            LET g_aag[l_ac].* = g_aag[l_ac-1].*
            NEXT FIELD aag01
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
 
   CLOSE i100_bcl
   COMMIT WORK
 
END FUNCTION
 
#-MOD-B80030-add- 
FUNCTION i100_chk_x()
    DEFINE g_bookno1    LIKE aza_file.aza81    
    DEFINE g_bookno2    LIKE aza_file.aza82   
    DEFINE g_flag       LIKE type_file.chr1 
    
    LET g_errno = ' '
    CALL s_get_bookno1(NULL,g_plant) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '0' THEN       
       IF g_aag_t.aag00 = g_bookno1 THEN
          LET g_cnt = 0
          SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
            WHERE npp00 = npq00
              AND npp01 = npq01
              AND npp011 = npq011
              AND nppsys = npqsys
              AND npptype = npqtype
              AND npq03 = g_aag_t.aag01
              AND nppglno IS NULL
              AND npqtype = '0'   
          IF g_cnt > 0 THEN
             LET g_errno="agl-973"
             RETURN 
          END IF
          SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
            WHERE aba01 = abb01
              AND aba00 = g_aag_t.aag00
              AND abb03 = g_aag_t.aag01
              AND aba20 = '0'
              AND aba00=g_bookno1     
              AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
              AND abaacti = 'Y'        
          IF g_cnt > 0 THEN
             LET g_errno="agl-973"
             RETURN 
          END IF      
       ELSE 
          IF g_aag_t.aag00 = g_bookno2 THEN
      	     LET g_cnt = 0
             SELECT COUNT(npp01) INTO g_cnt FROM npp_file,npq_file
               WHERE npp00 = npq00
                 AND npp01 = npq01
                 AND npp011 = npq011
                 AND nppsys = npqsys
                 AND npptype = npqtype
                 AND npq03 = g_aag_t.aag01
                 AND nppglno IS NULL
                 AND npqtype = '1'
             IF g_cnt > 0 THEN
                LET g_errno="agl-973"
                RETURN 
             END IF
             SELECT COUNT(aba01) INTO g_cnt FROM aba_file,abb_file
               WHERE aba01 = abb01
                 AND aba00 = g_aag_t.aag00
                 AND abb03 = g_aag_t.aag01
                 AND aba20 = '0'
                 AND aba00=g_bookno2       
                 AND (aba19 ='N' OR (aba19 = 'Y' AND abapost = 'N'))   
                 AND abaacti = 'Y'      
             IF g_cnt > 0 THEN
                LET g_errno="agl-973"
                RETURN 
             END IF  
          END IF             
       END IF     
    ELSE  
      CALL cl_err(g_plant,'aoo-081',1) #抓不到帳別
      LET g_errno="aoo-081"
    END IF	  
END FUNCTION
#-MOD-B80030-end- 

FUNCTION i100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
    IF INFIELD(aag07) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aag08",TRUE)
    END IF
#No.FUN-570108 --start--
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aag00,aag01",TRUE)  #No.FUN-730020
   END IF
#No.FUN-570108 --end--
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF INFIELD(aag07) OR ( NOT g_before_input_done ) THEN
     #IF g_aag[l_ac].aag07 MATCHES'[13]'AND g_aza.aza26<>'2' THEN #No.TQC-7A0083 add aza26 #MOD-AB0136 mark
      IF g_aag[l_ac].aag07 = "3" THEN                                                      #MOD-AB0136
         CALL cl_set_comp_entry("aag08",FALSE)
      END IF
   END IF
#No.FUN-570108 --start--
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("aag01",FALSE)
   END IF
#No.FUN-570108 --end--
END FUNCTION
 
FUNCTION i100_b_askkey()
 
   CLEAR FORM
   CALL g_aag.clear()
   CALL cl_opmsg('q')
 
    CONSTRUCT g_wc ON aag00,aag01,aag02,aag03,aag04,aag05,aag07,aag08,aag24,aagacti   #No.MOD-530627  #No.FUN-730020
        FROM s_aag[1].aag00,s_aag[1].aag01,s_aag[1].aag02,s_aag[1].aag03,s_aag[1].aag04,  #No.FUN-730020
              s_aag[1].aag05,s_aag[1].aag07,s_aag[1].aag08,s_aag[1].aag24,   #No.MOD-530627
             s_aag[1].aagacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(aag00)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aaa"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aag00
              NEXT FIELD aag00  
           OTHERWISE EXIT CASE
        END CASE
      #No.FUN-730020  --End  
 
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
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND aaggrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
 
   CALL cl_opmsg('b')
   CALL i100_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2      LIKE type_file.chr1000 #No.FUN-680098  VARCHAR(300)
 
    LET g_sql = "SELECT aag00,aag01,aag02,aag03,aag04,aag05,aag07,aag08,aag24,aagacti",   #No.MOD-530627  #No.FUN-730020
               " FROM aag_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               #" ORDER BY 1"         #MOD-9C0232
               " ORDER BY aag00,aag01"  #MOD-9C0232
   PREPARE i100_pb FROM g_sql
   DECLARE aag_curs CURSOR FOR i100_pb
 
   CALL g_aag.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH aag_curs INTO g_aag[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_aag.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aag TO s_aag.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i100_out()
   DEFINE l_i             LIKE type_file.num5,         #No.FUN-680098 SMALLINT
          l_name          LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680098 VARCHAR(20)
          l_aag   RECORD  LIKE aag_file.*,
          l_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
#No.TQC-5B0097-begin
   DEFINE l_cmd         LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          l_prog        LIKE zz_file.zz01,            #No.FUN-680098 VARCHAR(10)  
          l_wc,l_wc2    LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200)
          l_prtway      LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)  
#No.TQC-5B0097-end
 
   IF cl_null(g_wc) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
#No.TQC-5B0097-begin
 
   MENU ""
        ON ACTION rep1
                 LET l_prog='agli100'
                 EXIT MENU
        ON ACTION rep2
                 LET l_prog='gglr001'
                 EXIT MENU
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU
 
   END MENU
#No.TQC-5B0097-end
 
IF l_prog='agli100' THEN  #No.TQC-5B0097
   CALL cl_wait()
#  CALL cl_outnam('agli100') RETURNING l_name         #No.FUN-760085
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
   LET g_sql="SELECT * FROM aag_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED
#No.FUN-760085---Begin
#  PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i100_co CURSOR FOR i100_p1
 
#  START REPORT i100_rep TO l_name
 
#  FOREACH i100_co INTO l_aag.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
#     OUTPUT TO REPORT i100_rep(l_aag.*)
#  END FOREACH
 
#  FINISH REPORT i100_rep
 
#  CLOSE i100_co
#  CALL cl_prt(l_name,' ','1',g_len)
#  MESSAGE ""
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'aag00,aag01,aag02,aag03,aag04,aag05,aag07,aag08')
           RETURNING g_str                                                     
   END IF                                                                      
   CALL cl_prt_cs1('agli100','agli100',g_sql,g_str)   
#No.FUN-760085---End
#No.TQC-5B0097-begin
ELSE
   #No.TQC-7B0102 --start--
   CALL cl_getmsg('agl-955',g_lang) RETURNING g_msg
   PROMPT g_msg FOR g_bookno
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
 
      ON ACTION about
        CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END PROMPT
   IF cl_null(g_bookno) THEN
      LET g_bookno = g_aza.aza81
   END IF
   #No.TQC-7B0102 --end--
   LET l_prog = 'gglr001'
   LET l_wc=g_wc CLIPPED
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
    WHERE zz01 = l_prog
   IF SQLCA.sqlcode OR cl_null(l_wc2) THEN
      LET l_wc2 = ' "N" '
   END IF
   LET l_cmd = l_prog CLIPPED,
#          ' " "  "',g_today CLIPPED,'" ""',   #TQC-610056 #No.TQC-7B0102 mark
           ' "',g_bookno CLIPPED,'"  "',g_today CLIPPED,'" ""', #No.TQC-7B0102
           ' "',g_lang CLIPPED,'" "Y" "',l_prtway,'" "1"',
           ' "',l_wc CLIPPED,'"',
           ' ',l_wc2 CLIPPED,''
   CALL cl_cmdrun(l_cmd)
END IF
#No.TQC-5B0097-end
 
END FUNCTION
 
#No.TQC-950205--begin--
#函數說明:
#若采用科目編碼規範，則判斷用戶輸入的科目編碼是否符合科目規範
#判斷函數，有返回值，0-正確，1-錯誤
FUNCTION i100_chk_aag01(p_aag01)
DEFINE   p_aag01           LIKE aag_file.aag01
DEFINE   l_aaz107          LIKE aaz_file.aaz107
DEFINE   l_aaz108          LIKE aaz_file.aaz108 
DEFINE   l_aag01_length    LIKE type_file.num5   #編碼長度
DEFINE   l_length          LIKE type_file.num5   #其他段編碼長度
DEFINE   l_ret             LIKE type_file.chr1   #接收預設函數返回值
 
    #初始化各變量
     LET l_aaz107 = NULL
     LET l_aaz108 = NULL 
     LET l_aag01_length = 0
     LET l_length = 0    
     LET l_ret    = NULL 
       
     IF cl_null(p_aag01) THEN RETURN 0 END IF   #科目編號為空則返回0
 
    #找出科目編碼規範
     SELECT aaz107,aaz108 INTO l_aaz107,l_aaz108 FROM aaz_file WHERE aaz00 = '0'
     IF cl_null(l_aaz107) OR cl_null(l_aaz108) THEN  #沒有值，表示不采用編碼規範
        CALL cl_err('system message:','agl-241',0)
        RETURN 0       
     END IF 
     
     CALL LENGTH(p_aag01) RETURNING l_aag01_length
 
    #編碼長度小于首段長度
     IF l_aag01_length < l_aaz107 THEN 
        CALL cl_err(p_aag01,'agl-240',1) 
        RETURN 1
     END IF 
    
    #編碼長度大于首段長度
     IF l_aag01_length > l_aaz107 THEN 
        LET l_length = l_aag01_length - l_aaz107
        IF (l_length mod l_aaz108) <> 0 THEN 
           CALL cl_err(p_aag01,'agl-240',1)
           RETURN 1
        END IF 
     END IF 
 
    #-MOD-AB0136-mark-
    #若編碼符合規範，則調用預設函數i100_def()
    #CALL i100_def(p_aag01,l_aaz107,l_aaz108,l_aag01_length,'1') RETURNING l_ret #No.FUN-A40020
    #IF l_ret <> 'Y' THEN 
    #  RETURN 1 
    #END IF 
    #-MOD-AB0136-end-
     
     RETURN 0
 
END FUNCTION 
 
#No.TQC-D70091  --Begin 
#函數說明：判斷編碼規範原則下，對上級統制科目設置是否正確。 
#判斷函數，有返回值，0-正確，1-錯誤
FUNCTION i100_chk(p_aag01,p_aag08)
DEFINE   p_aag01          LIKE aag_file.aag01
DEFINE   p_aag08          LIKE aag_file.aag08
DEFINE   l_aaz107         LIKE aaz_file.aaz107
DEFINE   l_aaz108         LIKE aaz_file.aaz108
DEFINE   l_buff1          STRING       
DEFINE   l_buff2          STRING     
DEFINE   l_length1        LIKE type_file.num5
DEFINE   l_length2        LIKE type_file.num5
DEFINE   l_length         STRING   #MOD-9C0350 add

    #例：科目        科目層級 
    #例：9999           1    -->科目編碼長度需等於aaz107
    #    999901         2    -->科目編碼長度需等於上層統制科目長度+aaz108
    #    99990101       3    -->同上
    #    9999010101     4    -->同上
    #    999901010101   5    -->同上
    #    ....

   #初始化各變量
    LET l_aaz107 = NULL
    LET l_aaz108 = NULL 
    LET l_buff1  = NULL
    LET l_buff2  = NULL 
 
    #aaz107:科目編號首段碼長 , aaz108:科目編號其它段碼長
    SELECT aaz107,aaz108 INTO l_aaz107,l_aaz108 FROM aaz_file
     WHERE aaz00 = '0'
 
    CALL LENGTH(p_aag01) RETURNING l_length1
    CALL LENGTH(p_aag08) RETURNING l_length2

   #上級統制科目的編碼長度是否正確
    IF g_aag[l_ac].aag07 = '3' OR (g_aag[l_ac].aag07 = '1' AND g_aag[l_ac].aag24 = 1) THEN 
       LET l_buff1 = p_aag01 CLIPPED
       LET l_buff2 = p_aag08 CLIPPED
       #No.TQC-D70091  --Begin
       IF l_buff1 <> l_buff2 THEN
          CALL cl_err(p_aag01,'agl-241',1)             
          RETURN 1
       END IF
       IF LENGTH(p_aag01) <> l_aaz107 THEN
          CALL cl_err(p_aag01,'agl-241',1)             
          RETURN 1
       END IF
       #No.TQC-D70091  --End
    ELSE
       IF (l_length1 - l_aaz108 <> l_length2) THEN
          IF l_length2 > l_aaz107 THEN   #統制科目長度>科目編號首段碼長 
             LET l_length = (l_length1-l_aaz108) USING '###&'
             CALL cl_err_msg(NULL,"agl-254",l_length CLIPPED,1)
             RETURN 1
          ELSE
             CALL cl_err(p_aag01,'agl-244',1)   #MOD-9C0350 mod p_aag08->p_aag01
             RETURN 1
          END IF 
         #end MOD-9C0350 mod
       END IF 
       
       LET l_buff1 = p_aag01 CLIPPED
       LET l_buff1 = l_buff1.substring(1,l_length1-l_aaz108)
       LET l_buff2 = p_aag08 CLIPPED
    END IF
 
    IF NOT (l_buff1.equals(l_buff2)) THEN 
       CALL cl_err(p_aag08,'agl-245',1)
       RETURN 1
    END IF 
  
    RETURN 0  
END FUNCTION 
#No.TQC-D70091  --End
#函數說明：
#根據科目編碼，預設統制明細別aag07，所屬統制科目aag08 和科目層級aag24
#功能函數，無返回值
FUNCTION i100_def(p_aag01,p_aaz107,p_aaz108,p_length,p_flag)  #No.FUN-A40020
DEFINE   p_aag01          LIKE aag_file.aag01
DEFINE   p_aaz107         LIKE aaz_file.aaz107      #首段編碼長度定義值
DEFINE   p_aaz108         LIKE aaz_file.aaz108      #其他段編碼長度定義值
DEFINE   p_length         LIKE type_file.num5       #當前科目編碼總長度
DEFINE   l_length         LIKE type_file.num5       
DEFINE   l_success        LIKE type_file.chr1    
DEFINE   l_i              LIKE type_file.num5    
DEFINE   l_buff           STRING 
DEFINE   l_aag01          LIKE aag_file.aag01
DEFINE   l_count          LIKE type_file.num5
DEFINE   p_flag           LIKE type_file.chr1       #No.FUN-A40020
 
    #初始化各變量
     LET l_success = 'Y'
     LET l_aag01 = NULL 
     LET l_count = 0
     
   #若科目編碼字段長度等于首段編碼定義長度，則預設為統制科目
    IF p_length = p_aaz107 THEN 
       IF p_flag = '1' THEN           #No.FUN-A40020
          LET g_aag[l_ac].aag07 = '1'   
          LET g_aag[l_ac].aag08 = p_aag01
          LET g_aag[l_ac].aag24 = 1
       #No.FUN-A40020  --Begin                                                  
       ELSE                                                                     
          LET g_aag[l_ac].aag08 = p_aag01                                       
          LET g_aag[l_ac].aag24 = 1                                             
          RETURN l_success                                                      
       END IF                                                                   
       #No.FUN-A40020  --End
       
       RETURN l_success
    END IF 
   
   #若科目編碼字段長度大于首段編碼定義長度
    IF p_length > p_aaz107 THEN 
       LET l_length = p_length - p_aaz107    
       LET l_i = l_length / p_aaz108  
       LET l_buff  = p_aag01 
       LET l_aag01 = l_buff.substring(1,p_length-p_aaz108)
 
      #先確定帳套是否已經存在
      IF cl_null(g_aag[l_ac].aag00) THEN 
         CALL cl_err('','anm-062',0)
         LET l_success = 'N' 
         RETURN l_success 
      END IF 
 
      #確定是否存在該科目上級統制科目
       SELECT COUNT(aag01) INTO l_count FROM aag_file 
        WHERE aag01 = l_aag01 AND aag24 = l_i
          AND aag00 = g_aag[l_ac].aag00
       IF SQLCA.sqlcode THEN 
          CALL cl_err(p_aag01,SQLCA.sqlcode,1)
          LET l_success = 'N'
          RETURN l_success
       END IF 
       
       IF l_count = 0 THEN 
       	  #No.TQC-D70091  --Begin
          IF p_length <> p_aaz107 THEN     
             CALL cl_err(p_aag01,'agl-242',1)  
             LET l_success = 'N'
             RETURN l_success
          #IF cl_confirm('agl-243') THEN          
          #   LET g_aag[l_ac].aag07 = '3'
          #   LET g_aag[l_ac].aag08 = p_aag01
          ##  LET g_aag[l_ac].aag24 = 99      #No.FUN-A40020                     
          #   LET g_aag[l_ac].aag24 = 1       #No.FUN-A40020
          #   
          #   RETURN l_success 
          #ELSE
          #   CALL cl_err(p_aag01,'agl-242',1)
          #   LET l_success = 'N'
          #   RETURN l_success
          #END IF  
          END IF   
          #No.TQC-D70091  --End 
       ELSE
          #No.FUN-A40020  --Begin                                               
          IF p_flag = '2' AND g_aag[l_ac].aag07 = '1' THEN                      
             LET g_aag[l_ac].aag08 = l_aag01                                    
             LET g_aag[l_ac].aag24 = l_i + 1                                    
          ELSE                                                                  
          #No.FUN-A40020  --End
             LET g_aag[l_ac].aag07 = '2'
             LET g_aag[l_ac].aag08 = l_aag01
             LET g_aag[l_ac].aag24 = 99
          END IF                        #No.FUN-A40020 
          RETURN l_success
       END IF 
    END IF 
     
    RETURN l_success 
 
END FUNCTION
#No.TQC-950205---end--- 
 
#No.FUN-760085---Begin
{
REPORT i100_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680098   VARCHAR(1)
          sr              RECORD LIKE aag_file.*,
          l_chr           LIKE type_file.chr1          #No.FUN-680098   VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.aag00,sr.aag01  #No.FUN-730020
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[41],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],  #No.FUN-730020
               g_x[39],g_x[40]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         IF sr.aagacti = 'N' THEN
#           LET sr.aag01 = "*",sr.aag01  #No.FUN-730020
            LET sr.aag00 = "*",sr.aag00  #No.FUN-730020
         END IF
         PRINT COLUMN g_c[41],sr.aag00;  #No.FUN-730020
         PRINT COLUMN g_c[31],sr.aag01,
               COLUMN g_c[32],sr.aag02;
 
         CASE sr.aag03
            WHEN '1' PRINT COLUMN g_c[33],g_x[9] CLIPPED;
            WHEN '2' PRINT COLUMN g_c[33],g_x[10] CLIPPED;
            WHEN '3' PRINT COLUMN g_c[33],g_x[11] CLIPPED;
            WHEN '5' PRINT COLUMN g_c[33],g_x[12] CLIPPED;
         END CASE
 
         CASE sr.aag04
            WHEN '1' PRINT COLUMN g_c[34],g_x[13] CLIPPED;
            WHEN '2' PRINT COLUMN g_c[34],g_x[14] CLIPPED;
         END CASE
 
         CASE sr.aag06
              WHEN '1' PRINT COLUMN g_c[35],g_x[15] CLIPPED;
              WHEN '2' PRINT COLUMN g_c[35],g_x[16] CLIPPED;
         END CASE
 
         PRINT COLUMN g_c[36],sr.aag05;
         PRINT COLUMN g_c[37],sr.aag09;
 
         CASE sr.aag07
            WHEN '1'  PRINT COLUMN g_c[38],g_x[17] CLIPPED;
            WHEN '2'  PRINT COLUMN g_c[38],g_x[18] CLIPPED;
            WHEN '3'  PRINT COLUMN g_c[38],g_x[19] CLIPPED;
         END CASE
 
         IF sr.aag07 = '2' THEN
            PRINT COLUMN g_c[39],sr.aag08 CLIPPED;
         END IF
         PRINT COLUMN g_c[40],sr.aag12
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc,'aag01,aag02,aag03,aag04,aag05,aag07,aag08') RETURNING g_sql
            PRINT g_dash[1,g_len]
 
          #TQC-630166
          
          # IF g_sql[001,080] > ' ' THEN
          #    PRINT COLUMN g_c[31],g_x[8] CLIPPED,
          #          COLUMN g_c[32],g_sql[001,070] CLIPPED
          # END IF
          # IF g_sql[071,140] > ' ' THEN
          #    PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED
          # END IF
          # IF g_sql[141,210] > ' ' THEN
          #    PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
          # END IF
          
            CALL cl_prt_pos_wc(g_sql)
          #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
#FUN-590124
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#FUN-590124 End
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
#FUN-590124
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#FUN-590124 End
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-760085---End
#Patch....NO.MOD-5A0095 <001,002> #
