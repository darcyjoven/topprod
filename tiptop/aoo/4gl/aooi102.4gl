# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Descriptions...: 單位換算資料維護作業(aooi102)
# Input parameter: 
# Return code....: 
#
# Date & Author..: 91/08/12 By TED
# Modify.........: 91/09/26 May 反向單位換算
#                  92/05/06 David (Add ^P & ^Y)
#                  04/09/21 MOD-490344 Kitty Controlp 未加display
#                  04/10/06 MOD-470515 Nicola 加入"相關文件"功能
#                  04/11/03 FUN-4B0020 Nicola 加入"轉EXCEL"功能
#                  05/01/13 FUN-510027 pengu 報表轉XML
#                  05/03/25 MOD-530343 alex 修正smaacti以標準方式修改
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.MOD-5A0158 05/10/19 By pengu 取消單身刪除功能
# Modify.........: No.TQC-5B0065 05/11/08 By kim 移除 ring menu 中的"報表列印"
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0165 06/12/27 By Ray 增加刪除功能
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為 p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No.TQC-B30004 11/03/10 By suncx 刪除已傳POS相關邏輯
# Modify.........: No.TQC-BC0080 11/12/12 By zhangll 單身插入異常修正
# Modify.........: No:FUN-BB0086 11/11/30 By tanxc 增加數量欄位小數取位  
# Modify.........: No.CHI-BB0048 12/02/07 By jt_chen 刪除時增加寫入azo_file紀錄異動
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     g_smc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        smc01       LIKE smc_file.smc01,     #權限類別
        smc03       LIKE smc_file.smc03,     #權限名稱
        smc02       LIKE smc_file.smc02,     #權限類別
        smc04       LIKE smc_file.smc04,     #權限名稱
        smc05       LIKE smc_file.smc05,     #權限名稱
        smcacti     LIKE smc_file.smcacti    #資料有效碼
        #smcpos      LIKE smc_file.smcpos     #已傳POS否 #FUN-A30030 ADD #No.TQC-B30004 mark
                    END RECORD,
    g_smc_t         RECORD                   #程式變數 (舊值)
        smc01       LIKE smc_file.smc01,     #權限類別
        smc03       LIKE smc_file.smc03,     #權限名稱
        smc02       LIKE smc_file.smc02,     #權限類別
        smc04       LIKE smc_file.smc04,     #權限名稱
        smc05       LIKE smc_file.smc05,     #權限名稱
        smcacti     LIKE smc_file.smcacti   #資料有效碼
        #smcpos      LIKE smc_file.smcpos     #已傳POS否 #FUN-A30030 ADD  #No.TQC-B30004 mark
                    END RECORD,
    g_smc_tm        RECORD                   #程式變數 (舊值)
        smc01       LIKE smc_file.smc01,     #權限類別
        smc03       LIKE smc_file.smc03,     #權限名稱
        smc02       LIKE smc_file.smc02,     #權限類別
        smc04       LIKE smc_file.smc04,     #權限名稱
        smc05       LIKE smc_file.smc05,     #權限名稱
        smcacti     LIKE smc_file.smcacti   #資料有效碼
        #smcpos      LIKE smc_file.smcpos     #已傳POS否 #FUN-A30030 ADD  #No.TQC-B30004 mark
                    END RECORD,
    g_smc_tml       RECORD                   #程式變數 (舊值)
        smc01       LIKE smc_file.smc01,     #權限類別
        smc03       LIKE smc_file.smc03,     #權限名稱
        smc02       LIKE smc_file.smc02,     #權限類別
        smc04       LIKE smc_file.smc04,     #權限名稱
        smc05       LIKE smc_file.smc05,     #權限名稱
        smcacti     LIKE smc_file.smcacti   #資料有效碼
        #smcpos      LIKE smc_file.smcpos     #已傳POS否 #FUN-A30030 ADD  #No.TQC-B30004 mark
                    END RECORD,
     g_wc,g_sql          STRING,  #No.FUN-580092 HCN        #No.FUN-680102
    g_rec_b             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    l_ac                LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680102
DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110        #No.FUN-680102 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680102
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8                #No.FUN-6A0081
    DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
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
    LET p_row = 4 LET p_col = 18
    OPEN WINDOW i102_w AT p_row,p_col           #顯示畫面
         WITH FORM "aoo/42f/aooi102"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  #No.TQC-B30004 mark begin#################################
  ##FUN-A30030 ADD-------------------------
  # IF g_aza.aza88='Y' THEN
  #    CALL cl_set_comp_visible('smcpos',TRUE)
  # ELSE
  #    CALL cl_set_comp_visible('smcpos',FALSE)
  # END IF
  ##FUN-A30030 END------------------------
  #No.TQC-B30004 mark end  #################################

    CALL cl_ui_init()
 
    LET g_wc = '1=1' 
    CALL i102_b_fill(g_wc)
    CALL i102_menu()
    CLOSE WINDOW i102_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i102_q()
   CALL i102_b_askkey()
END FUNCTION
 
FUNCTION i102_b_askkey()
 
    CLEAR FORM
   CALL g_smc.clear()
 
    CONSTRUCT g_wc ON smc01,smc03,smc02,smc04,smc05,smcacti #,smcpos     #FUN-A30030 ADD pos  #螢幕上取條件 #No.TQC-B30004 mark smcpos
         FROM s_smc[1].smc01,s_smc[1].smc03,s_smc[1].smc02,
              s_smc[1].smc04,s_smc[1].smc05,s_smc[1].smcacti #,s_smc[1].smcpos     #FUN-A30030 ADD pos #No.TQC-B30004 mark smcpos
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
    ON ACTION controlp
         CASE
              WHEN INFIELD(smc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_smc[1].smc01
                 NEXT FIELD smc01
              WHEN INFIELD(smc02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_smc[1].smc02
                 NEXT FIELD smc02
              OTHERWISE EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN  RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i102_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i102_menu()
 DEFINE l_cmd      LIKE type_file.chr1000                                #No.FUN-780056   
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i102_out()                                          #No.FUN-780056
               IF cl_null(g_wc)  THEN LET g_wc='1=1' END IF              #No.FUN-780056
               LET l_cmd='p_query "aooi102" "',g_wc CLIPPED,'"'          #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                     #No.FUN-780056   
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_smc[l_ac].smc01 IS NOT NULL THEN
                  LET g_doc.column1 = "smc01"
                  LET g_doc.value1 = g_smc[l_ac].smc01
                  LET g_doc.column2 = "smc02"
                  LET g_doc.value2 = g_smc[l_ac].smc02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_smc),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
#單身
FUNCTION i102_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
   i               LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
   l_success       LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)  #可更改否 (含取消)
   acti_tm         LIKE smc_file.smcacti,         #No.FUN-680102CHAR(1)
   l_acti_t        LIKE smc_file.smcacti,         #No.FUN-680102CHAR(1)
   l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102CHAR(1)              #可新增否
   l_allow_delete  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)             #可刪除否
   l_azo06         LIKE azo_file.azo06,           #No.CHI-BB0048
   l_azo05         LIKE azo_file.azo05            #No.CHI-BB0048
 
   IF s_shut(0) THEN RETURN END IF
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')   #No.MOD-5A0158 mark     #No.TQC-6C0165
#  LET l_allow_delete = FALSE    #No.MOD-5A0158 add     #No.TQC-6C0165
 
 
   CALL cl_opmsg('b')
   DISPLAY g_msg CLIPPED AT 2,38       #該操作方法為^U
 
   #LET g_forupd_sql = "SELECT smc01,smc03,smc02,smc04,smc05,smcacti,smcpos",    #FUN-A30030 ADD pos  #No.TQC-B30004 mark
   LET g_forupd_sql = "SELECT smc01,smc03,smc02,smc04,smc05,smcacti", #No.TQC-B30004 
                      "  FROM smc_file WHERE smc01 =? AND smc02 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
   INPUT ARRAY g_smc WITHOUT DEFAULTS FROM s_smc.* 
#    ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#    ATTRIBUTE (COUNT=g_smc.getLength(),MAXCOUNT=g_max_rec,UNBUFFERED,
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,  #TQC-BC0080 mod
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
            LET g_success='Y'  #no.6645
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
#No.FUN-570110 --start                                                          
               LET g_before_input_done = FALSE                                  
               CALL i102_set_entry(p_cmd)                                       
               CALL i102_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570110 --end   
               LET g_smc_t.* = g_smc[l_ac].*  #BACKUP
 
               OPEN i102_bcl USING g_smc_t.smc01,g_smc_t.smc02
               IF STATUS THEN
                  CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i102_bcl INTO g_smc[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_smc_t.smc01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            BEGIN WORK
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i102_set_entry(p_cmd)                                          
            CALL i102_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570110 --end    
            INITIALIZE g_smc[l_ac].* TO NULL      #900423
            LET g_smc[l_ac].smc03  = '1'
            LET g_smc[l_ac].smc04  = '1'
            LET g_smc[l_ac].smcacti = 'Y'
            #LET g_smc[l_ac].smcpos  ='N'     #FUN-A30030 ADD  #No.TQC-B30004
            LET g_smc_t.* = g_smc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD smc01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i102_bcl
              CANCEL INSERT
           END IF
           LET g_success = 'Y'
           #INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti,smcpos)     #FUN-A30030 ADD pos  #No.TQC-B30004 mark
           INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti)     #No.TQC-B30004
                         VALUES(g_smc[l_ac].smc01,g_smc[l_ac].smc03,
                               g_smc[l_ac].smc02,g_smc[l_ac].smc04,
                               #g_smc[l_ac].smc05,g_smc[l_ac].smcacti,g_smc[l_ac].smcpos)   #FUN-A30030 ADD pos  #No.TQC-B30004 mark
                               g_smc[l_ac].smc05,g_smc[l_ac].smcacti)    #No.TQC-B30004
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_smc[l_ac].smc01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("ins","smc_file",g_smc[l_ac].smc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
              LET g_success='N' #no.6645
           ELSE
              MESSAGE 'INSERT O.K'
              SLEEP 2
              LET g_rec_b = g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
           LET l_success ='Y'
           UPDATE smc_file SET smc03=g_smc[l_ac].smc04,
                               smc04=g_smc[l_ac].smc03,
                               smcacti=g_smc[l_ac].smcacti
                               #smcpos =g_smc[l_ac].smcpos       #FUN-A30030 ADD #No.TQC-B30004 mark
            WHERE smc02 = g_smc[l_ac].smc01
              AND smc01 = g_smc[l_ac].smc02
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              LET l_success ='Y'
           ELSE 
              LET l_success ='N'  #update成功
#             #若update成功且反向資料處於同一螢幕時的DISPLAY
              FOR i = 1 TO g_smc.getLength()
                 IF g_smc[i].smc02 = g_smc[l_ac].smc01 AND 
                    g_smc[i].smc01 = g_smc[l_ac].smc02 THEN
                    LET g_smc[i].smcacti=acti_tm
                    LET g_smc[i].smc02=g_smc[l_ac].smc01
                    LET g_smc[i].smc01=g_smc[l_ac].smc02
                    LET g_smc[i].smc03=g_smc[l_ac].smc04
                    LET g_smc[i].smc04=g_smc[l_ac].smc03
                    #LET g_smc[i].smcpos=g_smc[l_ac].smcpos         #FUN-A30030 ADD #No.TQC-B30004 mark
                    LET g_smc[i].smcacti=g_smc[l_ac].smcacti
                    EXIT FOR 
                 END IF
              END FOR  
           END IF
           IF l_success  ='Y' THEN
              LET l_ac = ARR_CURR()
              #INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti,smcpos)    #FUN-A30030 ADD  #No.TQC-B30004 mark
              INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti)   #No.TQC-B30004
                            VALUES(g_smc[l_ac].smc02,g_smc[l_ac].smc04,
                                   g_smc[l_ac].smc01,g_smc[l_ac].smc03,
                                   #g_smc[l_ac].smc05,g_smc[l_ac].smcacti,g_smc[l_ac].smcpos)    #FUN-A30030 ADD #No.TQC-B30004 mark
                                   g_smc[l_ac].smc05,g_smc[l_ac].smcacti)   #No.TQC-B30004
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_smc[l_ac].smc01,SQLCA.sqlcode,0)   #No.FUN-660131
                 CALL cl_err3("ins","smc_file",g_smc[l_ac].smc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET g_smc[l_ac].* = g_smc_t.*
                 LET g_success='N' #no.6645
              ELSE
                 MESSAGE 'INSERT O.K'
                 LET g_rec_b = g_rec_b+1
                 LET g_smc[g_rec_b].smc02=g_smc[l_ac].smc01
                 LET g_smc[g_rec_b].smc01=g_smc[l_ac].smc02
                 LET g_smc[g_rec_b].smc03=g_smc[l_ac].smc04
                 LET g_smc[g_rec_b].smc04=g_smc[l_ac].smc03
                 LET g_smc[g_rec_b].smcacti=g_smc[l_ac].smcacti
                 #LET g_smc[g_rec_b].smcpos=g_smc[l_ac].smcpos     #FUN-A30030 ADD  #No.TQC-B30004 mark
                 DISPLAY g_rec_b TO FORMONLY.cn2  
                 # 2003/10/01 by Hiko : 增加此FUNCTION是為了解決同時更新畫面的資料.
                 CALL quick_show_array()
              END IF
           END IF
           IF g_success = 'Y' THEN 
              COMMIT WORK
           ELSE
              ROLLBACK WORK
           END IF 
 
         AFTER FIELD smc01                        #check 序號是否重複
            IF NOT cl_null(g_smc[l_ac].smc01) THEN 
               IF g_smc_t.smc01 != g_smc[l_ac].smc01
                  OR g_smc_t.smc01 IS NULL THEN 
                  SELECT gfe01 FROM gfe_file
                   WHERE g_smc[l_ac].smc01 = gfe01
                  IF SQLCA.sqlcode  THEN 
#                    CALL cl_err(g_smc[l_ac].smc01,'mfg2605',0)   #No.FUN-660131
                     CALL cl_err3("sel","gfe_file",g_smc[l_ac].smc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                     NEXT FIELD smc01
                  END IF
               END IF 
               #No.FUN-BB0086--add--begin--
               LET g_smc[l_ac].smc03 = s_digqty(g_smc[l_ac].smc03,g_smc[l_ac].smc01)
               DISPLAY BY NAME g_smc[l_ac].smc03
               #No.FUN-BB0086--add--end--
            END IF 
          
 #       #MOD-530343
#       BEFORE FIELD smc02 
#            IF g_smc[l_ac].smcacti = 'N' OR g_smc[l_ac].smcacti = 'n' THEN
#               CALL cl_err('','mfg1000',0)
#               LET g_smc[l_ac].smc01 = g_smc_t.smc01
#               NEXT FIELD smc01
#            END IF
 
        AFTER FIELD smc02			 #判斷此FIELD不能為NULL
            IF NOT cl_null(g_smc[l_ac].smc02) THEN 
               SELECT gfe01 FROM gfe_file 
                WHERE g_smc[l_ac].smc02 = gfe01
               IF SQLCA.sqlcode THEN 
#                 CALL cl_err(g_smc[l_ac].smc02,'mfg2605',0)   #No.FUN-660131
                  CALL cl_err3("sel","gfe_file",g_smc[l_ac].smc02,"","mfg2605","","",1)  #No.FUN-660131
                  NEXT FIELD smc02
               END IF
               IF g_smc[l_ac].smc02 != g_smc_t.smc02 OR
                  g_smc_t.smc02 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM smc_file
                    WHERE smc01 = g_smc[l_ac].smc01 AND 
                          smc02 = g_smc[l_ac].smc02 
                  IF l_n > 0 THEN	      		#重覆
                     CALL cl_err('',-239,0)
                     LET g_smc[l_ac].smc01 = g_smc_t.smc01
                     LET g_smc[l_ac].smc03 = g_smc_t.smc03
                     LET g_smc[l_ac].smc02 = g_smc_t.smc02
                     NEXT FIELD smc01
                  END IF
               END IF
               #No.FUN-BB0086--add--begin--
               LET g_smc[l_ac].smc04 = s_digqty(g_smc[l_ac].smc04,g_smc[l_ac].smc02)
               DISPLAY BY NAME g_smc[l_ac].smc04
               #No.FUN-BB0086--add--end--
            END IF

         #No.FUN-BB0086--add--begin--
         AFTER FIELD smc03
            LET g_smc[l_ac].smc03 = s_digqty(g_smc[l_ac].smc03,g_smc[l_ac].smc01)
            DISPLAY BY NAME g_smc[l_ac].smc03
            
         AFTER FIELD smc04
            LET g_smc[l_ac].smc04 = s_digqty(g_smc[l_ac].smc04,g_smc[l_ac].smc02)
            DISPLAY BY NAME g_smc[l_ac].smc04
         #No.FUN-BB0086--add--end--
 
#No.TQC-6C0165 --begin
     BEFORE DELETE                            #是否取消單身
         IF g_smc_t.smc01 IS NOT NULL AND g_smc_t.smc02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK  
               CANCEL DELETE
            END IF
           #No.TQC-B30004 mark begin-----------------------------
           ##FUN-A30030 ADD--------------------
           # IF g_aza.aza88 = 'Y' THEN
           #    IF g_smc[l_ac].smcacti='Y' OR g_smc[l_ac].smcpos='N' THEN
           #       CALL cl_err('','art-648',0)
           #       ROLLBACK WORK
           #       CANCEL DELETE
           #    END IF
           # END IF
           ##FUN-A30030 END--------------------
           #No.TQC-B30004 mark end-----------------------------

            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "smc01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_smc[l_ac].smc01      #No.FUN-9B0098 10/02/24
            LET g_doc.column2 = "smc02"               #No.FUN-9B0098 10/02/24
            LET g_doc.value2 = g_smc[l_ac].smc02      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF 
            SELECT COUNT(*) INTO l_n FROM ima_file 
             WHERE ima25 = g_smc_t.smc01 
                OR ima31 = g_smc_t.smc01 
                OR ima44 = g_smc_t.smc01 
                OR ima55 = g_smc_t.smc01 
                OR ima63 = g_smc_t.smc01 
                OR ima86 = g_smc_t.smc01 
                OR ima908= g_smc_t.smc01 
                OR ima907= g_smc_t.smc01 
            IF l_n <> 0 THEN
               CALL cl_err(g_smc_t.smc01,'aoo-991',1)
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF
            SELECT COUNT(*) INTO l_n FROM ima_file 
             WHERE ima25 = g_smc_t.smc02 
                OR ima31 = g_smc_t.smc02
                OR ima44 = g_smc_t.smc02
                OR ima55 = g_smc_t.smc02
                OR ima63 = g_smc_t.smc02
                OR ima86 = g_smc_t.smc02
                OR ima908= g_smc_t.smc02
                OR ima907= g_smc_t.smc02
            IF l_n <> 0 THEN
               CALL cl_err(g_smc_t.smc02,'aoo-991',1)
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF
            
            DELETE FROM smc_file WHERE smc01 = g_smc_t.smc01
                                   AND smc02 = g_smc_t.smc02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","smc_file",g_smc_t.smc01,g_smc_t.smc02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK 
                CANCEL DELETE
                EXIT INPUT
            END IF
            #CHI-BB0048 -- add start --
            LET g_msg = TIME
            LET l_azo05 = 'smc01:',g_smc_t.smc01,' smc02:',g_smc_t.smc02
            LET l_azo06 = 'delete'
            INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
              VALUES ('aooi102',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","aooi102","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #CHI-BB0048 -- add end --
            #Add TQC-BC0080
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            #Add TQC-BC0080--end
            
         END IF
#No.TQC-6C0165 --end
 #        #MOD-530343
#        BEFORE DELETE                                   #是否取消單身
#            IF g_smc_t.smc01 IS NOT NULL THEN
#               LET l_acti_t=g_smc[l_ac].smcacti
#               IF cl_exp(0,0,g_smc[l_ac].smcacti) THEN
#                  IF g_smc[l_ac].smcacti = 'Y' THEN	#改變有效碼為Y或N
#                     LET g_smc[l_ac].smcacti = 'N'
#                  ELSE
#                     LET g_smc[l_ac].smcacti = 'Y'
#                  END IF
#                  LET acti_tm = g_smc[l_ac].smcacti
#                  UPDATE smc_file SET smcacti = g_smc[l_ac].smcacti
#                   WHERE smc01 =g_smc[l_ac].smc01 AND smc02=g_smc[l_ac].smc02 
#                  IF SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err(g_smc_t.smc01,SQLCA.sqlcode,0)
#                  END IF
#                  LET l_success = 'Y'
#                  UPDATE smc_file SET smcacti = g_smc[l_ac].smcacti
#                   WHERE smc02 = g_smc[l_ac].smc01 AND smc01=g_smc[l_ac].smc02 
#                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                     LET l_success='N'
#                  END IF
#               END IF 
#               IF l_success ='Y'  THEN 
#                  FOR i=1 TO g_rec_b   
#                     IF g_smc[i].smc01=g_smc_t.smc02  AND
#                        g_smc[i].smc02=g_smc_t.smc01 THEN
#                        LET g_smc[i].smcacti=acti_tm
##                       DISPLAY g_smc[i].smcacti TO s_smc[i].smcacti
#                        EXIT FOR
#                     END IF
#                  END FOR
#               END IF  
#               EXIT INPUT
#            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_smc[l_ac].* = g_smc_t.*
              CLOSE i102_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_smc[l_ac].smc01,-263,0)
               LET g_smc[l_ac].* = g_smc_t.*
           ELSE
               #No.TQC-B30004 mark begin---------------------- 
               ##FUN-A30030 ADD----------------------
               #IF g_aza.aza88='Y' THEN
               #   LET g_smc[l_ac].smcpos='N'
               #   DISPLAY BY NAME g_smc[l_ac].smcpos
               #END IF 
               ##FUN-A30030 END---------------------
               #No.TQC-B30004 mark end------------------------
               UPDATE smc_file SET smc01=g_smc[l_ac].smc01,
                                   smc03=g_smc[l_ac].smc03,
                                   smc02=g_smc[l_ac].smc02,
                                   smc04=g_smc[l_ac].smc04,
                                   smc05=g_smc[l_ac].smc05,
                                   smcacti=g_smc[l_ac].smcacti
                                   #smcpos=g_smc[l_ac].smcpos        #FUN-A30030 ADD #No.TQC-B30004 mark
                WHERE smc01 = g_smc_t.smc01
                  AND smc02 = g_smc_t.smc02 
               #UPDATE資料成功
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] != 0 THEN
                  #UPDATE反向資料
                  UPDATE smc_file SET smc01=g_smc[l_ac].smc02,
                                      smc03=g_smc[l_ac].smc04,
                                      smc02=g_smc[l_ac].smc01,
                                      smc04=g_smc[l_ac].smc03,
                                      smc05=g_smc[l_ac].smc05,
                                      smcacti=g_smc[l_ac].smcacti
                                      #smcpos=g_smc[l_ac].smcpos      #FUN-A30030 ADD  #No.TQC-B30004 mark
                   WHERE smc02 = g_smc_t.smc01 AND smc01 = g_smc_t.smc02 
                  #若反向資料不存在,則INSERT
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                     LET l_ac = ARR_CURR()
                     #INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti,smcpos)   #FUN-A30030 ADD pos  #No.TQC-B30004 mark
                     INSERT INTO smc_file(smc01,smc03,smc02,smc04,smc05,smcacti)  #No.TQC-B30004 
                                   VALUES(g_smc[l_ac].smc02,g_smc[l_ac].smc04,
                                          g_smc[l_ac].smc01,g_smc[l_ac].smc03,
                                          #g_smc[l_ac].smc05,g_smc[l_ac].smcacti,g_smc[l_ac].smcpos)  #FUN-A30030 ADD pos  #No.TQC-B30004 mark
                                          g_smc[l_ac].smc05,g_smc[l_ac].smcacti)  #No.TQC-B30004 
                     IF SQLCA.sqlcode THEN
#                        CALL cl_err(g_smc[l_ac].smc01,SQLCA.sqlcode,0)   #No.FUN-660131
                         CALL cl_err3("ins","smc_file",g_smc[l_ac].smc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                         LET g_smc[l_ac].* = g_smc_t.*
                         ROLLBACK WORK
                     ELSE
                        MESSAGE 'INSERT O.K'
                        LET g_rec_b = g_rec_b+1
                        LET g_smc[g_rec_b].smc02=g_smc[l_ac].smc01
                        LET g_smc[g_rec_b].smc01=g_smc[l_ac].smc02
                        LET g_smc[g_rec_b].smc03=g_smc[l_ac].smc04
                        LET g_smc[g_rec_b].smc04=g_smc[l_ac].smc03
                        LET g_smc[g_rec_b].smcacti=g_smc[l_ac].smcacti
                        #LET g_smc[g_rec_b].smcpos=g_smc[l_ac].smcpos      #FUN-A30030 ADD  #No.TQC-B30004 mark
                        DISPLAY g_rec_b TO FORMONLY.cn2  
                        # 2003/10/01 by Hiko : 增加此FUNCTION是為了解決同時更新畫面的資料.
                        CALL quick_show_array()
                     END IF
                  ELSE
                     FOR i = 1 TO g_smc.getLength()   
                        IF g_smc[i].smc02 = g_smc[l_ac].smc01 AND 
                           g_smc[i].smc01 = g_smc[l_ac].smc02 THEN
                           LET g_smc[i].smcacti=acti_tm
                           LET g_smc[i].smc02=g_smc[l_ac].smc01
                           LET g_smc[i].smc01=g_smc[l_ac].smc02
                           LET g_smc[i].smc03=g_smc[l_ac].smc04
                           LET g_smc[i].smc04=g_smc[l_ac].smc03
                           LET g_smc[i].smcacti=g_smc[l_ac].smcacti
                           #LET g_smc[i].smcpos=g_smc[l_ac].smcpos     #FUN-A30030 ADD   #No.TQC-B30004 mark
                           EXIT FOR 
                        END IF
                     END FOR
                  END IF 
               ELSE 
                  MESSAGE 'UPDATE O.K'
                  CALL quick_show_array()
               END IF
           END IF
           IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
          #LET l_ac_t = l_ac                # 新增  #FUN-D40030 Mark
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_smc[l_ac].* = g_smc_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_smc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i102_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
        #  LET g_smc_t.* = g_smc[l_ac].*          # 900423  #TQC-BC0080 mark
           LET l_ac_t = l_ac                #FUN-D40030 Add
           CLOSE i102_bcl
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i102_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(smc01) AND l_ac > 1 THEN
                LET g_smc[l_ac].* = g_smc[l_ac-1].*
                DISPLAY g_smc[l_ac].* TO s_smc[l_ac].*
                NEXT FIELD smc01
            END IF
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       #TQC-5B0065 mark
        #^U對查詢結果作報表列印
       #ON ACTION i102_out
       #    IF cl_chk_act_auth() THEN
       #       CALL i102_out()
       #    END IF
 
        ON ACTION create_unit                
            CASE
               WHEN  INFIELD(smc01)
                    CALL cl_cmdrun("aooi101 ")
               WHEN  INFIELD(smc02)
                    CALL cl_cmdrun("aooi101 ")
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(smc01) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_smc[l_ac].smc01
                 CALL cl_create_qry() RETURNING g_smc[l_ac].smc01
#                 CALL FGL_DIALOG_SETBUFFER( g_smc[l_ac].smc01 )
                  DISPLAY BY NAME g_smc[l_ac].smc01               #No.MOD-490344
                 NEXT FIELD smc01
              WHEN INFIELD(smc02) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_smc[l_ac].smc02
                 CALL cl_create_qry() RETURNING g_smc[l_ac].smc02
#                 CALL FGL_DIALOG_SETBUFFER( g_smc[l_ac].smc02 )
                  DISPLAY BY NAME g_smc[l_ac].smc02               #No.MOD-490344
                 NEXT FIELD smc02
              OTHERWISE EXIT CASE
           END CASE
 
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
 
    CLOSE i102_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION quick_show_array()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_smc TO s_smc.* ATTRIBUTE(COUNT=g_smc.getLength())
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i102_b_fill(p_wc)             #BODY FILL UP
 DEFINE p_wc    STRING        #No.FUN-680102
 
    #LET g_sql= "SELECT smc01,smc03,smc02,smc04,smc05,smcacti,smcpos",    #FUN-A30030 ADD pos  #No.TQC-B30004 mark
    LET g_sql= "SELECT smc01,smc03,smc02,smc04,smc05,smcacti",  #No.TQC-B30004
               " FROM smc_file ",
               " WHERE ",p_wc CLIPPED,
               " ORDER BY smc01,smc02"
    PREPARE i102_prepare FROM g_sql    #預備一下
    DECLARE i102_cs CURSOR FOR i102_prepare
 
    CALL g_smc.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH i102_cs INTO g_smc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt= g_cnt + 1 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_smc.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
    END IF
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO cn2  
    LET g_cnt = 1
 
END FUNCTION
 
#No.FUN-780056  --str
{
FUNCTION i102_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    sr              RECORD
        smc01       LIKE smc_file.smc01,   #來源單位
        smc03       LIKE smc_file.smc03,   #來源數量
        smc02       LIKE smc_file.smc02,   #目的單位
        smc04       LIKE smc_file.smc04,   #目的數量
        smc05       LIKE smc_file.smc05,   #說明
        smcacti     LIKE smc_file.smcacti  #有效碼
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680102 VARCHAR(20)
    l_za05          LIKE za_file.za05                   #No.FUN-680102 VARCHAR(40)
 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aooi102.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT smc01,smc03,smc02,smc04,smc05,smcacti",
              " FROM smc_file ",                 # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i102_co                         # SCROLL CURSOR
         CURSOR WITH HOLD FOR i102_p1
 
    CALL cl_outnam('aooi102') RETURNING l_name
    START REPORT i102_rep TO l_name
 
    FOREACH i102_co INTO sr.*		 #輸出報表資料
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i102_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i102_rep
 
    CLOSE i102_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
}
#No.FUN-780056 -end
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_smc TO s_smc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
#No.FUN-780056 -str
{
REPORT i102_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
    sr              RECORD
        smc01       LIKE smc_file.smc01,   #來源單位
        smc03       LIKE smc_file.smc03,   #來源數量
        smc02       LIKE smc_file.smc02,   #目的單位
        smc04       LIKE smc_file.smc04,   #目的數量
        smc05       LIKE smc_file.smc05,   #說明
        smcacti     LIKE smc_file.smcacti  #有效碼
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.smc01,sr.smc01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.smc01,
                  COLUMN g_c[32],sr.smc03,
                  COLUMN g_c[33],':',
                  COLUMN g_c[34],sr.smc02,
                  COLUMN g_c[35],sr.smc04,
                  COLUMN g_c[36],sr.smc05,
                  COLUMN g_c[37],sr.smcacti
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
#No.FUN-780056 -end
 
#No.FUN-570110 --start                                                          
FUNCTION i102_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("smc01,smc02",TRUE)                                 
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i102_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("smc01,smc02",FALSE)                                
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end    
