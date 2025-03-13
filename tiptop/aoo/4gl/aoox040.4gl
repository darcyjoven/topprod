# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: aoox040.4gl
# Descriptions...: 員工資料
# Date & Author..: 91/06/21 By Lee
# Modify.........: MOD-470515 04/10/05 Nicola 加入"相關文件"功能
#                  FUN-4B0020 04/11/03 Nicola 加入"轉EXCEL"功能
#                  FUN-510027 05/01/13 pengu  報表轉XML
#                  FUN-560004 05/06/03 alex 加多語系顯示更新等功能記為550077
# Modify.........: FUN-570110 05/07/13 vivien KEY值更改控制 
# Modify.........: FUN-570199 05/08/03 Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: MOD-580154 05/08/19 CoCo PAGE LENGTH改為 g_page_line
#                  FUN-580036 05/10/28 alex 修正錯誤訊息,多語編輯方法
# Modify.........: FUN-580031 06/01/06 By saki QBE查詢條件紀錄
# Modify.........: TQC-5C0079 06/02/09 alex 修正多語言資料顯示問題
# Modify.........: FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: FUN-680010 06/08/05 By Joe SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680102 06/09/13 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-680158 06/11/14 By pengu 勾選aoos010中"隱藏無權限的功能按鍵"，執行程式時沒友執行權限的action未disable 
# Modify.........: No.TQC-6B0103 06/11/20 By alexstar 做 'R' delete 時,相關多語言檔(gbc_file)需要一併處理
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-710076 07/03/06 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/05 By mike 報表格式修改為crystal reports
# Modify.........: NO.FUN-860036 08/06/17 by kim  MDM整合 for GP5.1
# Modify.........: No.FUN-870067 08/07/14 By douzh 新增匯豐銀行接口新增員工銀行信息按鈕
# Modify.........: No.FUN-870166 08/09/02 By kevin MDM整合call aws_mdmdata
# Modify.........: No.FUN-890113 08/10/27 By kevin 移除刪除功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS? 
# Modify.........: No.FUN-A30097 10/03/29 by huangrh add gen07
# Modify.........: No.FUN-A80148 10/08/31 by shaoyong 新增 gen08(行動電話) 欄位. 並在開啟時接收參數, 來限制查詢資料的範圍.
# Modify.........: No.FUN-AA0064 10/10/24 by johnson 同步到32區
# Modify.........: No.MOD-B20155 11/03/03 by baogc 修改資料重複的報錯信息
# Modify.........: No.FUN-B40071 11/04/27 by jason 已傳POS否狀態調整
# Modify.........: No.MOD-B70261 11/07/28 by sabrina 將gen_bank_inf action刪除
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.MOD-C70070 12/07/06 By Elise 判斷參數未勾選就不自動帶出多語系名稱維護
# Modify.........: No:FUN-CB0005 12/11/06 By chenying 報表改善
# Modify.........: No:FUN-D40030 13/04/09 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gen           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gen01       LIKE gen_file.gen01,   #員工編號
        gen02       LIKE gen_file.gen02,   #員工姓名
        gen03       LIKE gen_file.gen03,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        gen07       LIKE gen_file.gen07,     #FUN-A30097
        gen07_desc  LIKE azp_file.azp02,     #FUN-A30097
        gen04       LIKE gen_file.gen04,   #職稱
        gen05       LIKE gen_file.gen05,   #分機
        gen06       LIKE gen_file.gen06,   #Mail
        gen08       LIKE gen_file.gen08,   #FUN-A80148--add--
        genacti     LIKE gen_file.genacti,   #No.FUN-680102 VARCHAR(1) 
        genpos      LIKE gen_file.genpos      #FUN-A30030 ADD 
                    END RECORD,
    g_gen_t         RECORD                 #程式變數 (舊值)
        gen01       LIKE gen_file.gen01,   #員工編號
        gen02       LIKE gen_file.gen02,   #員工姓名
        gen03       LIKE gen_file.gen03,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        gen07       LIKE gen_file.gen07,     #FUN-A30097
        gen07_desc  LIKE azp_file.azp02,     #FUN-A30097
        gen04       LIKE gen_file.gen04,   #職稱
        gen05       LIKE gen_file.gen05,   #分機
        gen06       LIKE gen_file.gen06,   #Mail
        gen08       LIKE gen_file.gen08,   #FUN-A80148--add--
        genacti     LIKE gen_file.genacti,    #No.FUN-680102 VARCHAR(1) 
        genpos      LIKE gen_file.genpos      #FUN-A30030 ADD
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_str        STRING                    #No.FUN-760083     
DEFINE g_argv1      LIKE gen_file.gen07       #FUN-A80148--add--

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #FUN-A80148--add--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081

   LET g_str = FGL_GETENV("FGLASIP")
   LET g_cnt = g_str.getIndexOf("http://",1)
   LET g_i   = g_str.getIndexOf("/",9)

 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW x040_w AT p_row,p_col WITH FORM "aoo/42f/aoox040"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
  #FUN-A30030 ADD-------------------------
   IF g_aza.aza88='Y' THEN
      CALL cl_set_comp_visible('genpos',TRUE)
   ELSE
      CALL cl_set_comp_visible('genpos',FALSE)
   END IF
  #FUN-A30030 END------------------------
    CALL cl_ui_init()
#FUN-A30097---------------------begin-------------------
    IF g_azw.azw04 <> '2' THEN
       CALL cl_set_comp_visible('gen07,gen07_desc',FALSE)
    ELSE
       CALL cl_set_comp_visible('gen07,gen07_desc',TRUE)
    END IF
#FUN-A30097---------------------------end-------------------
  #MOD-B70261---mark---start---
  ##No.FUN-870067--begin
  # IF g_aza.aza73 = 'N' THEN
  #    CALL cl_set_act_visible("gen_bank_inf",FALSE)
  # ELSE
  #    CALL cl_set_act_visible("gen_bank_inf",TRUE)
  # END IF
  ##No.FUN-870067--begin
  #MOD-B70261---mark---end---
    LET g_wc2 = '1=1'
    CALL x040_b_fill(g_wc2)
    CALL x040_menu()
    CLOSE WINDOW x040_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION x040_menu()
 
   WHILE TRUE
      CALL x040_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL x040_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL x040_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       #MOD-B70261---mark---start---
       ##No.FUN-870067--begin
       # WHEN "gen_bank_inf" 
       #    IF cl_chk_act_auth() AND l_ac != 0 THEN 
       #       IF NOT cl_null(g_gen[l_ac].gen01) THEN
       #          LET g_cmd = "gpyi032 '",g_gen[l_ac].gen01,"'"
       #          CALL cl_cmdrun(g_cmd CLIPPED)
       #       END IF 
       #    END IF         
       #   #No.FUN-870067--end
       #MOD-B70261---mark---end---
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL x040_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gen[l_ac].gen01 IS NOT NULL THEN
                  LET g_doc.column1 = "gen01"
                  LET g_doc.value1 = g_gen[l_ac].gen01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gen),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION x040_q()
   CALL x040_b_askkey()
END FUNCTION
 
FUNCTION x040_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_gen07         LIKE gen_file.gen07,                 #MOD-B20155 ADD
    v               string
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
#   LET g_forupd_sql = "SELECT gen01,gen02,gen03,'',gen07,'',gen04,gen05,gen06,genacti,genpos",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mark--
    LET g_forupd_sql = "SELECT gen01,gen02,gen03,'',gen07,'',gen04,gen05,gen06,gen08,genacti,genpos",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM gen_file WHERE gen01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE x040_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gen WITHOUT DEFAULTS FROM s_gen.*
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
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL x040_set_entry(p_cmd)                                           
           CALL x040_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_gen_t.* = g_gen[l_ac].*  #BACKUP
           OPEN x040_bcl USING g_gen_t.gen01
           IF STATUS THEN
              CALL cl_err("OPEN x040_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH x040_bcl INTO g_gen[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gen_t.gen01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
#             ELSE   #TQC-5C0079
#                IF g_aza.aza44 = "Y" THEN    #FUN-550077
#                   IF NOT cl_null(g_gen[l_ac].gen02) THEN
#                      CALL cl_itemname_modsys("gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_i
#                   END IF
#                   CALL cl_itemname_by_lang("gen_file","gen02",g_gen[l_ac].gen01,g_lang,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02
#                END IF
              END IF
           END IF
           SELECT gem02  INTO g_gen[l_ac].gem02 FROM gem_file
            WHERE g_gen[l_ac].gen03 = gem01
           CALL x040_gen07('d')        #FUN-A30097
           #FUN-A80148 Begin---
            IF NOT cl_null(g_argv1) THEN
               CALL cl_set_comp_entry("gen07",FALSE)
            END IF
           #FUN-A80148 End-----
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                        
         CALL x040_set_entry(p_cmd)                                             
         CALL x040_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_gen[l_ac].* TO NULL      #900423
         #LET g_gen[l_ac].genpos ='N'   #FUN-A30030 ADD
        LET g_gen[l_ac].genpos ='1'   #FUN-B40071 modify  
         LET g_gen[l_ac].genacti = 'Y'       #Body default
        #FUN-A80148 Begin---
         IF NOT cl_null(g_argv1) THEN
            LET g_gen[l_ac].gen07 = g_argv1
            CALL cl_set_comp_entry("gen07",FALSE)
         END IF
        #FUN-A80148 End-----
         LET g_gen_t.* = g_gen[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gen01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE x040_bcl
           CANCEL INSERT
        END IF
       #IF g_aza.aza44 = "Y" THEN #FUN-550077  #TQC-6C0060 mark
       #   CALL cl_itemname_switch(1,"gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02
       #END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO gen_file(gen01,gen02,gen03,gen07,gen04,gen05,                          #FUN-A30097
#                    gen06,genacti,genpos,genuser,gendate,genoriu,genorig)                 #FUN-A30030 ADD POS  #FUN-A80148--mark--
                     gen06,gen08,genacti,genpos,genuser,gendate,genoriu,genorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_gen[l_ac].gen01,g_gen[l_ac].gen02,
               g_gen[l_ac].gen03,g_gen[l_ac].gen07,g_gen[l_ac].gen04,                      #FUN-A30097
#              g_gen[l_ac].gen05,g_gen[l_ac].gen06,                                        #FUN-A80148--mark--
               g_gen[l_ac].gen05,g_gen[l_ac].gen06,g_gen[l_ac].gen08,                      #FUN-A80148--mod-- 
               g_gen[l_ac].genacti,g_gen[l_ac].genpos,g_user,g_today, g_user, g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_gen[l_ac].gen01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("ins","gen_file",g_gen[l_ac].gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
          #IF g_aza.aza44 = "Y" THEN   #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_switch(2,"gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02
          #   DISPLAY g_gen[l_ac].gen02 TO gen02
          #END IF
 
           ##FUN-680010
           #MESSAGE 'INSERT O.K'
           #LET g_rec_b=g_rec_b+1
           #DISPLAY g_rec_b TO FORMONLY.cn2  
 
           # CALL aws_mdmcli           
           #CASE aws_mdmcli('employee','insert',base.TypeInfo.create(g_gen[l_ac]),'','','','') #FUN-870166
           CASE aws_mdmdata('gen_file','insert',g_gen[l_ac].gen01,base.TypeInfo.create(g_gen[l_ac]),'CreateEmployeeData') #FUN-870166
              WHEN 0  #無與 MDM 整合
                   CALL cl_msg('INSERT O.K')
              WHEN 1  #呼叫 MDM 成功
                   CALL cl_msg('INSERT O.K, INSERT MDM O.K')
              WHEN 2  #呼叫 MDM 失敗
                   ROLLBACK WORK
                   CANCEL INSERT
           END CASE
 
           # CALL aws_spccli_base()
           # 傳入參數: (1)TABLE名稱, (2)新增資料,
           #           (3)功能選項：insert(新增),update(修改),delete(刪除)
           CASE aws_spccli_base('gen_file',base.TypeInfo.create(g_gen[l_ac]),'insert')    
              WHEN 0  #無與 SPC 整合
                   MESSAGE 'INSERT O.K'
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
              WHEN 1  #呼叫 SPC 成功
                   MESSAGE 'INSERT O.K, INSERT SPC O.K'
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
              WHEN 2  #呼叫 SPC 失敗
                   ROLLBACK WORK
                   CANCEL INSERT
           END CASE
           COMMIT WORK 
           ##FUN-680010 
 
        END IF
 
     AFTER FIELD gen01                        #check 編號是否重複
        IF NOT cl_null(g_gen[l_ac].gen01) THEN
           IF g_gen[l_ac].gen01 != g_gen_t.gen01 OR
              g_gen_t.gen01 IS NULL THEN
              SELECT count(*) INTO l_n FROM gen_file
               WHERE gen01 = g_gen[l_ac].gen01
              IF l_n > 0 THEN
#                 CALL cl_err('',-239,0)  #MOD-B20155 MARK
#MOD-B20155 ADD--BEGIN-----
                  SELECT gen07 INTO l_gen07 FROM gen_file 
                   WHERE gen01 = g_gen[l_ac].gen01
                  IF NOT cl_null(l_gen07) THEN
                     CALL cl_err_msg('','aoo-028',g_gen[l_ac].gen01 CLIPPED|| "|" || l_gen07 CLIPPED,0)
                  ELSE
                     CALL cl_err('',-239,0)
                  END IF
#MOD-B20155 ADD--END-------
                  LET g_gen[l_ac].gen01 = g_gen_t.gen01
                  NEXT FIELD gen01
              END IF
           END IF
        END IF
 
     ON CHANGE gen02   # FUN-550077
        IF g_aza.aza44 = "Y" THEN 
          #CALL cl_itemname_modcurr("gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_i  #TQC-6C0060 mark
           IF g_zx14 = "Y" AND g_on_change THEN
             #CALL p_itemname_update("gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02  #TQC-6C0060 mark
              CALL p_itemname_update("gen_file","gen02",g_gen[l_ac].gen01) #TQC-6C0060 
           END IF
          #DISPLAY g_gen[l_ac].gen02 TO gen02  #TQC-6C0060 mark
           CALL cl_show_fld_cont()   #TQC-6C0060
       #MOD-C70070---mark---S--- 
       #ELSE
       #   IF NOT g_cuelang THEN    #FUN-580036
       #      CALL cl_err(g_gen[l_ac].gen01,"lib-151",1)
       #      LET g_cuelang = TRUE
       #   END IF
       #MOD-C70070---mark---E---
        END IF
 
     AFTER FIELD gen03
       IF NOT cl_null(g_gen[l_ac].gen03) THEN
          CALL x040_gen03('a')
          IF NOT cl_null(g_errno)  THEN
             CALL cl_err('',g_errno,0) NEXT FIELD gen03
          END IF
       END IF 

#FUN-A30097 -----------begin----------
    AFTER FIELD gen07
        IF NOT cl_null(g_gen[l_ac].gen07) THEN
           LET l_n=0
           SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01=g_gen[l_ac].gen07
           IF l_n=0 THEN
              CALL cl_err('','aoo-253',0)
              DISPLAY BY NAME g_gen_t.gen07
              NEXT FIELD gen07
           END IF
           CALL x040_gen07('d')
        END IF
#FUN-A30097 -----end--------------------
 
     AFTER FIELD genacti
        IF NOT cl_null(g_gen[l_ac].genacti) THEN
           IF g_gen[l_ac].genacti NOT MATCHES '[YN]' THEN 
              LET g_gen[l_ac].genacti = g_gen_t.genacti
              NEXT FIELD genacti
           END IF
        END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_gen_t.gen01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
           #FUN-A30030 ADD--------------------
            IF g_aza.aza88 = 'Y' THEN
               #IF g_gen[l_ac].genacti='Y' OR g_gen[l_ac].genpos='N' THEN   #NO.FUN-B40071
               IF NOT ((g_gen[l_ac].genpos='3' AND g_gen[l_ac].genacti='N') #NO.FUN-B40071
                        OR (g_gen[l_ac].genpos='1'))  THEN                  #NO.FUN-B40071
                  CALL cl_err('','apc-139',0)                               #NO.FUN-B40071
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
            END IF
           #FUN-A30030 END--------------------
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "gen01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_gen[l_ac].gen01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            #TQC-6B0103---start---
            IF (NOT cl_del_itemname("gen_file","gen02", g_gen_t.gen01)) THEN 
               ROLLBACK WORK
               RETURN
            END IF
            #TQC-6B0103---end---
            DELETE FROM gen_file WHERE gen01 = g_gen_t.gen01
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gen_t.gen01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("del","gen_file",g_gen_t.gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
                EXIT INPUT
            END IF
 
            #FUN-680010 
            #LET g_rec_b=g_rec_b-1
            #DISPLAY g_rec_b TO FORMONLY.cn2  
            #COMMIT WORK
            
            #FUN-860036        #FUN-890113  
            #CASE aws_mdmcli('employee','delete',base.TypeInfo.create(g_gen[l_ac]),'','','','') #FUN-870166
            #CASE aws_mdmdata('gen_file','delete',g_gen[l_ac].gen01,base.TypeInfo.create(g_gen[l_ac]),'CreateEmployeeData') #FUN-870166
            #   WHEN 0  #無與 MDM 整合
            #        CALL cl_msg('Delete O.K')
            #   WHEN 1  #呼叫 MDM 成功
            #        CALL cl_msg('Delete O.K, Delete MDM O.K')
            #   WHEN 2  #呼叫 MDM 失敗
            #        ROLLBACK WORK
            #        CANCEL DELETE
            #END CASE
 
            # CALL aws_spccli_base()
            # 傳入參數: (1)TABLE名稱, (2)刪除資料,
            #           (3)功能選項：insert(新增),update(修改),delete(刪除)
            CASE aws_spccli_base('gen_file',base.TypeInfo.create(g_gen[l_ac]),'delete')   
               WHEN 0  #無與 SPC 整合
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2  
                    COMMIT WORK
               WHEN 1  #呼叫 SPC 成功
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2  
                    COMMIT WORK
               WHEN 2  #呼叫 SPC 失敗
                    ROLLBACK WORK  
                    CANCEL DELETE
            END CASE
            #END FUN-680010 
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_gen[l_ac].* = g_gen_t.*
          CLOSE x040_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gen[l_ac].gen01,-263,0)
           LET g_gen[l_ac].* = g_gen_t.*
        ELSE
          #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_switch(1,"gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02
          #END IF
          #FUN-A30030 ADD--------------------
           IF g_aza.aza88 = 'Y' THEN
              #NO.FUN-B40071 --START--
              #LET  g_gen[l_ac].genpos='N' 
              IF g_gen[l_ac].genpos='2' OR g_gen[l_ac].genpos='3' THEN
                 LET  g_gen[l_ac].genpos='2'
              ELSE
                 LET  g_gen[l_ac].genpos='1'
              END IF
              #NO.FUN-B40071 --END-- 
              DISPLAY BY NAME  g_gen[l_ac].genpos  
           END IF
           
          #FUN-A30030 END--------------------
           UPDATE gen_file SET gen01=g_gen[l_ac].gen01,
                               gen02=g_gen[l_ac].gen02,
                               gen03=g_gen[l_ac].gen03,
                               gen07=g_gen[l_ac].gen07,  #FUN-A30097
                               gen04=g_gen[l_ac].gen04,
                               gen05=g_gen[l_ac].gen05,
                               gen06=g_gen[l_ac].gen06,    
                               gen08=g_gen[l_ac].gen08,     #FUN-A80148--add--
                               genpos=g_gen[l_ac].genpos,   #FUN-A30030 ADD
                               genacti=g_gen[l_ac].genacti,
                               genmodu=g_user,
                               gendate=g_today
           WHERE gen01 = g_gen_t.gen01
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_gen[l_ac].gen01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("upd","gen_file",g_gen_t.gen01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_gen[l_ac].* = g_gen_t.*
           ELSE
             #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
             #   CALL cl_itemname_switch(2,"gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02
             #   DISPLAY g_gen[l_ac].gen02 TO gen02
             #END IF
 
              #FUN-680010 
              #MESSAGE 'UPDATE O.K'
              #COMMIT WORK
 
              #FUN-860036
              # CALL aws_mdmcli              
              #CASE aws_mdmcli('employee','update',base.TypeInfo.create(g_gen[l_ac]),'','','','') #FUN-870166
              CASE aws_mdmdata('gen_file','update',g_gen[l_ac].gen01,base.TypeInfo.create(g_gen[l_ac]),'CreateEmployeeData') #FUN-870166
                 WHEN 0  #無與 MDM 整合
                      CALL cl_msg('Update O.K')
                 WHEN 1  #呼叫 MDM 成功
                      CALL cl_msg('Update O.K, Update MDM O.K')
                 WHEN 2  #呼叫 MDM 失敗
                      ROLLBACK WORK
                      LET g_gen[l_ac].* = g_gen_t.*
              END CASE
 
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)修改資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
              CASE aws_spccli_base('gen_file',base.TypeInfo.create(g_gen[l_ac]),'update')    
                 WHEN 0  #無與 SPC 整合
                      MESSAGE 'UPDATE O.K'
                      COMMIT WORK
                 WHEN 1  #呼叫 SPC 成功
                      MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                      COMMIT WORK
                 WHEN 2  #呼叫 SPC 失敗
                      ROLLBACK WORK  
                      LET g_gen[l_ac].* = g_gen_t.*
              END CASE
              #END FUN-680010 
 
              #-----TQC-B90211---------
              #IF g_gen[l_ac].gen03 <> g_gen_t.gen03 THEN
              #   SELECT COUNT(*) INTO l_n FROM cpf_file
              #    WHERE cpf01=g_gen[l_ac].gen01
              #   IF l_n > 0 THEN
              #      IF cl_confirm('aoo-106') THEN
              #         UPDATE cpf_file SET cpf29=g_gen[l_ac].gen03
              #          WHERE cpf01=g_gen[l_ac].gen01
              #         IF SQLCA.sqlcode THEN
#             #            CALL cl_err('up cpf29:',SQLCA.sqlcode,0)   #No.FUN-660131
              #            CALL cl_err3("upd","cpf_file",g_gen[l_ac].gen01,"",SQLCA.sqlcode,"","up cpf29:",1)  #No.FUN-660131
              #         END IF
              #      END IF
              #   END IF
              #END IF
              #-----END TQC-B90211-----
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
        #LET l_ac_t = l_ac               # 新增  #FUN-D40030
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gen[l_ac].* = g_gen_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_gen.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE x040_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac               # 新增  #FUN-D40030
        CLOSE x040_bcl                # 新增
        COMMIT WORK

   # ON ACTION CONTROLN
   #     CALL x040_b_askkey()
   #     EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gen01) AND l_ac > 1 THEN
             LET g_gen[l_ac].* = g_gen[l_ac-1].*
             NEXT FIELD gen01
         END IF
 
       ON ACTION controlp
           CASE 
             WHEN INFIELD(gen03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_gen[l_ac].gen03
                     CALL cl_create_qry() RETURNING g_gen[l_ac].gen03
                     DISPLAY g_gen[l_ac].gen03 TO gen03
#                    CALL FGL_DIALOG_SETBUFFER(g_gen[l_ac].gen03 )
                     CALL x040_gen03('a')
#FUN-A30097 --------begin-----------------
           WHEN INFIELD(gen07)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_azp"
             LET g_qryparam.default1 = g_gen[l_ac].gen07
             CALL cl_create_qry() RETURNING g_gen[l_ac].gen07
             DISPLAY BY NAME g_gen[l_ac].gen07
             CALL x040_gen07('d')
             NEXT FIELD gen07
#FUN-A30097--------------end-----------------
                OTHERWISE
                     EXIT CASE
            END CASE
 
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
 
#    #FUN-550077
     ON ACTION update_item
        IF g_aza.aza44 = "Y" THEN
           CALL GET_FLDBUF(gen02) RETURNING g_gen[l_ac].gen02
          #CALL p_itemname_update("gen_file","gen02",g_gen[l_ac].gen01,g_gen[l_ac].gen02) RETURNING g_gen[l_ac].gen02  #TQC-6C0060 mark
           CALL p_itemname_update("gen_file","gen02",g_gen[l_ac].gen01) #TQC-6C0060
           LET g_on_change=FALSE
          #DISPLAY g_gen[l_ac].gen02 TO gen02  #TQC-6C0060 mark
           CALL cl_show_fld_cont()   #TQC-6C0060 
        ELSE
           CALL cl_err(g_gen[l_ac].gen01,"lib-151",1)
           LET g_cuelang = TRUE
        END IF
 
    END INPUT
 
    CLOSE x040_bcl
    COMMIT WORK
END FUNCTION

#FUN-A30097 -----------------begin----------------------
FUNCTION x040_gen07(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_azp02      LIKE azp_file.azp02

    LET g_errno = ' '
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_gen[l_ac].gen07
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno = 'aoo-254'
                                 LET l_azp02 = NULL
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_gen[l_ac].gen07_desc=l_azp02
       DISPLAY BY NAME g_gen[l_ac].gen07_desc
  END IF

END FUNCTION
#FUN-A30097 -------------------------end-------------------
 
FUNCTION x040_gen03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680102 VARCHAR(1)
    l_gemacti       LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO g_gen[l_ac].gem02,l_gemacti
        FROM gem_file
        WHERE gem01 = g_gen[l_ac].gen03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-005'
                            LET g_gen[l_ac].gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION x040_b_askkey()
    CLEAR FORM
    CALL g_gen.clear()
 
#FUN-A80148--begin--
#   CONSTRUCT g_wc2 ON gen01,gen02,gen03,gen07,gen04,gen05,gen06,genacti,genpos       #FUN-A30030 ADD  pos#FUN-A30097
#        FROM s_gen[1].gen01,s_gen[1].gen02,s_gen[1].gen03,s_gen[1].gen07,             #FUN-A30097
#             s_gen[1].gen04,s_gen[1].gen05,s_gen[1].gen06,s_gen[1].genacti,s_gen[1].genpos   #FUN-A30030 ADD pos
    CONSTRUCT g_wc2 ON gen01,gen02,gen03,gen07,gen04,gen05,gen06,gen08,genacti,genpos                        #FUN-A30030 ADD  pos#FUN-A30097
         FROM s_gen[1].gen01,s_gen[1].gen02,s_gen[1].gen03,s_gen[1].gen07,                                   #FUN-A30097
              s_gen[1].gen04,s_gen[1].gen05,s_gen[1].gen06,s_gen[1].gen08,s_gen[1].genacti,s_gen[1].genpos   #FUN-A30030 ADD pos
#FUN-A80148--end--
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gen03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_gem"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_gen[1].gen03
                   CALL x040_gen03('a')
#FUN-A30097---begin------------------------
            WHEN INFIELD(gen07)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gen07"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gen07
               NEXT FIELD gen07
               CALL x040_gen07('d')
#FUN-A30097---end----------------------
 
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
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('genuser', 'gengrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL x040_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION x040_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
#FUN-A80148--begin--
#   LET g_sql = "SELECT gen01,gen02,gen03,gem02,gen07,'',gen04,gen05,gen06,genacti,genpos",   #FUN-A30030 ADD POS #FUN-A30097
#               " FROM gen_file,OUTER gem_file",
#               " WHERE gen_file.gen03 = gem_file.gem01  AND ", p_wc2 CLIPPED,           #單身
#               " ORDER BY 1" 
   
    IF not cl_null(g_argv1) THEN
       LET g_sql = "SELECT gen01,gen02,gen03,gem02,gen07,'',gen04,gen05,gen06,gen08,genacti,genpos",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM gen_file,OUTER gem_file",
                   " WHERE gen_file.gen03 = gem_file.gem01  AND ", p_wc2 CLIPPED,           #單身
                   "   AND gen07 ='",g_argv1,"' ",
                   " ORDER BY 1" 
    ELSE
       LET g_sql = "SELECT gen01,gen02,gen03,gem02,gen07,'',gen04,gen05,gen06,gen08,genacti,genpos",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM gen_file,OUTER gem_file",
                   " WHERE gen_file.gen03 = gem_file.gem01  AND ", p_wc2 CLIPPED,           #單身
                   " ORDER BY 1" 
    END IF
#FUN-A80148--end--
 
   #IF g_aza.aza44 = "Y" THEN   #FUN-550077  #TQC-6C0060 mark
   #   CALL cl_itemname_construct(g_sql,"gen_file","gen02","gen01") RETURNING g_sql
   #END IF
 
    PREPARE x040_pb FROM g_sql
    DECLARE gen_curs CURSOR FOR x040_pb
 
    CALL g_gen.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gen_curs INTO g_gen[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT azp02 INTO g_gen[g_cnt].gen07_desc FROM azp_file WHERE azp01 = g_gen[g_cnt].gen07 #FUN-A30097
        #FUN-550077  #TQC-6C0060 mark
       #IF g_aza.aza44 = "Y" AND NOT cl_null(g_gen[g_cnt].gen02) THEN
       #   CALL cl_itemname_by_lang("gen_file","gen02",g_gen[g_cnt].gen01 CLIPPED,g_lang,g_gen[g_cnt].gen02 ) RETURNING g_gen[g_cnt].gen02
       #END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gen.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION x040_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gen TO s_gen.* ATTRIBUTE(COUNT=g_rec_b)
 
     #---------No.TQC-680158 add
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
     #---------No.TQC-680158 end
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
    #MOD-B70261---mark---start--- 
    ##No.FUN-870067--begin
    # ON ACTION gen_bank_inf
    #    LET g_action_choice="gen_bank_inf"
    #    LET l_ac = 1
    #    EXIT DISPLAY
    ##No.FUN-870067--end  
    #MOD-B70261---mark---end---
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
 
FUNCTION x040_out()
    DEFINE
        l_gen           RECORD LIKE gen_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aoox040.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gen_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#No.FUN-760083 --BEGIN--
{
    PREPARE x040_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE x040_co                         # SCROLL CURSOR
        CURSOR FOR x040_p1
 
    #CALL cl_outnam('aoox040') RETURNING l_name    
    #START REPORT x040_rep TO l_name               
 
    FOREACH x040_co INTO l_gen.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        ELSE
          #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_by_lang("gen_file","gen02",l_gen.gen01 CLIPPED,g_lang,l_gen.gen02) RETURNING l_gen.gen02
          #END IF
        END IF
        OUTPUT TO REPORT x040_rep(l_gen.*)
    END FOREACH
 
    FINISH REPORT x040_rep
 
    CLOSE x040_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
}
    LET g_str=''
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
    IF g_zz05='Y' THEN 
#       CALL cl_wcchp(g_wc2,'gen01,gen02,gen03,gen04,gen05,gen06,genacti,genpos')   #FUN-A30030 ADD POS  #FUN-A80148--mark--
        CALL cl_wcchp(g_wc2,'gen01,gen02,gen03,gen04,gen05,gen06,gen08,genacti,genpos')   #FUN-A30030 ADD POS  #FUN-A80148--mod--
        RETURNING g_wc2
    END IF
    CALL cl_chk_kind_of_report('')
    CASE g_rep_choice
      WHEN 1 #CR
         LET g_str=g_wc2
         CALL cl_prt_cs1("aooi040","aooi040",g_sql,g_str)
      WHEN 2 #XtraGrid
         LET g_xgrid.sql = g_sql
         CALL cl_xg_view()
      OTHERWISE EXIT CASE
    END CASE

#No.FUN-760083 --END--
 
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT x040_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE gen_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gen01
 
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
            IF sr.genacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
          PRINT COLUMN g_c[32],sr.gen01,
                COLUMN g_c[33],sr.gen02,
                COLUMN g_c[34],sr.gen03,
                COLUMN g_c[35],sr.gen04,
                COLUMN g_c[36],sr.gen05,
                COLUMN g_c[37],sr.gen06
 
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
#No.FUN-760083 --end--
 
#No.FUN-570110 --start                                                          
FUNCTION x040_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gen01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION x040_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gen01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end 
#No.FUN-AA0064 --end         
