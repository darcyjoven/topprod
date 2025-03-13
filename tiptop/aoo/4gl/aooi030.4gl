# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi030.4gl
# Descriptions...: 部門名稱
# Date & Author..: 91/06/21 By Lee
# Modify.........: By Melody    新增 gem05、gem06 兩欄位               
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510027 05/01/13 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-580093 05/08/22 By saki 增加部門上線人數設定功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-670032 06/07/11 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670046 06/07/19 By Pengu DELETE i030_combo_gem07()應用
# Modify.........: No.FUN-680011 06/08/03 By Echo SPC整合專案-基本資料傳遞
# Modify.........: No.FUN-680102 06/09/13 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0090 06/11/07 By baogui隱藏欄位寬度問題
# Modify.........: No.TQC-6B0023 06/11/15 By baogui 報表問題修改
# Modify.........: No.TQC-6C0093 07/01/08 By kim 拿掉export按鈕,修改利潤中心的問題
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760083 07/07/05 By mike 報表格式改為crystal report
# Modify.........: No.FUN-870101 08/09/10 By jamie MES整合
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: NO.FUN-890113 08/11/17 By kevin MDM整合
# Modify.........: No.MOD-950054 09/05/05 BY Dido 筆數計算不可因 aza90 而有所不同
# Modify.........: No.FUN-870100 09/06/01 BY lala add gem11
# Modify.........: No.FUN-920138 09/08/14 By tsai_yen 和"部門與部門群組上線控管"(p_onlinepp)同步：1.刪除資料時 2.修改key時
# Modify.........: No.FUN-A10012 10/01/05 By destiny流通零售for業態管控 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30097 10/03/29 by huangrh 刪除歸屬機構 gem11
# Modify.........: No.TQC-A50075 10/05/19 By houlia CONSTRUCT中的字段與欄位不對應，添加 s_gem[1].gem
# Modify.........: No.MOD-A60111 10/06/18 By Carrier 字段不对应
# Modify.........: No:MOD-A60184 10/07/05 By Pengu 當MFG系統關閉時，進單身會造成無窮迴圈
# Modify.........: No:FUN-9A0056 11/03/31 By Abby MES整合功能調整
# Modify.........: No:MOD-C10154 12/02/09 By jt_chen 查詢時先將g_rec_b預設為0
# Modify.........: No:MOD-C70101 12/07/09 By Elise 修改多次總筆數會減少
# Modify.........: No:MOD-CC0125 13/01/29 By Elise (1) 調整將BEFORE ROW中的CALL i030_set_entry_b()搬到IF g_rec_b>=l_ac THEN上
#                                                  (2) 調整會計維護Action不可新增資料
# Modify.........: No:MOD-D30143 13/03/14 By ck2yuan 在進程式MAIN後考慮 權限控管
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gem           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gem01       LIKE gem_file.gem01,   #部門編號
        gem02       LIKE gem_file.gem02,   #簡稱
        gem03       LIKE gem_file.gem03,   #全名
        gem05       LIKE gem_file.gem05, 
#       gem06       LIKE gem_file.gem06,
#       gem07       LIKE gem_file.gem07,
        gem07       LIKE gem_file.gem07,              #No.FUN-680102 VARCHAR(20),              # Modify by Raymon because of "Combo box"
        gem09       LIKE gem_file.gem09, #FUN-670032
        gem10       LIKE gem_file.gem10, #FUN-670032
        gem02a      LIKE gem_file.gem02, #FUN-670032
#        gem11       LIKE gem_file.gem11, #FUN-870100 #FUN-A30097 mark
#        gem11_desc  LIKE azp_file.azp02, #FUN-870100 #FUN-A30097 mark
        gemacti     LIKE gem_file.gemacti             #No.FUN-680102 VARCHAR(1) 
                    END RECORD,
    g_gem_t         RECORD                 #程式變數 (舊值)
        gem01       LIKE gem_file.gem01,   #部門編號
        gem02       LIKE gem_file.gem02,   #簡稱
        gem03       LIKE gem_file.gem03,   #全名
        gem05       LIKE gem_file.gem05, 
#       gem06       LIKE gem_file.gem06,
#       gem07       LIKE gem_file.gem07,   # Modify by Raymon because of "Combo box"
        gem07       LIKE gem_file.gem07,              #No.FUN-680102 VARCHAR(20),
        gem09       LIKE gem_file.gem09, #FUN-670032
        gem10       LIKE gem_file.gem10, #FUN-670032
        gem02a      LIKE gem_file.gem02, #FUN-670032
#        gem11       LIKE gem_file.gem11, #FUN-870100   #FUN-A30097 mark
#        gem11_desc  LIKE azp_file.azp02, #FUN-870100   #FUN-A30097 mark
        gemacti     LIKE gem_file.gemacti             #No.FUN-680102 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,                           #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,              #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
    g_account       LIKE type_file.num5               #No.FUN-680102 SMALLINT               #FUN-670032 會計維護
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_forupd_gbo_sql     STRING                  #FOR UPDATE SQL   #FUN-920138
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680102 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5     #FUN-570110   #No.FUN-680102 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE l_table              STRING                  #No.FUN-760083
DEFINE g_str                STRING                  #No.FUN-760083
DEFINE g_u_flag             LIKE type_file.chr1     #FUN-870101 add 
 
MAIN
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
 
    LET g_sql="gem01.gem_file.gem01,",
              "gem02.gem_file.gem02,",
              "gem03.gem_file.gem03,",
              "gem04.gem_file.gem04,",
              "gem05.gem_file.gem05,",
              "gem06.gem_file.gem06,",
              "gem07.gem_file.gem07,",
              "gem08.gem_file.gem08,",
              "gemacti.gem_file.gemacti,",
              "gemuser.gem_file.gemuser,",
              "gemgrup.gem_file.gemgrup,",
              "gemmodu.gem_file.gemmodu,",
              "gemdate.gem_file.gemdate,",
              "gem09.gem_file.gem09,",
              "gem10.gem_file.gem10,",
              "l_gem02a.gem_file.gem02"
   LET l_table=cl_prt_temptable("aooi030",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err("insert_prep:",status,1)  
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
    OPEN WINDOW i030_w WITH FORM "aoo/42f/aooi030"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("gem09,gem10,gem02a",g_aaz.aaz90='Y')
#FUN-A30097 mark----------------begin------------
#    #No.FUN-A10012--being
#    IF g_azw.azw04 <> '2' THEN
#       CALL cl_set_comp_visible('gem11,gem11_desc',FALSE)  
#    ELSE
#       CALL cl_set_comp_visible('gem11,gem11_desc',TRUE)  
#    END IF
#    #No.FUN-A10012--end 
#FUN-A30097 mark----------------end----------------------
   #LET g_wc2 = '1=1' CALL i030_b_fill(g_wc2)                                                      #MOD-D30143 mark
    LET g_wc2 = '1=1' CLIPPED,cl_get_extra_cond('gemuser', 'gemgrup') CALL i030_b_fill(g_wc2)      #MOD-D30143 add
 
  CALL i030_menu()
  CLOSE WINDOW i030_w                 #結束畫面

  CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_account=FALSE #FUN-670032
               CALL i030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i030_out()
            END IF
         #FUN-670032...............begin
         WHEN "account"
            IF cl_chk_act_auth() THEN
               CALL i030_acc()
            END IF
         #FUN-670032...............end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gem[l_ac].gem01 IS NOT NULL THEN
                  LET g_doc.column1 = "gem01"
                  LET g_doc.value1 = g_gem[l_ac].gem01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gem),'','')
            END IF
         #No.FUN-580093 --start--
         WHEN "online_count"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("p_onlinepp")
            END IF
         #No.FUN-580093 ---end---
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i030_q()
   CALL i030_b_askkey()
END FUNCTION
 
FUNCTION i030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_cnt           LIKE type_file.num10                #No.FUN-680102 INTEGER #FUN-670032
 
    LET g_action_choice = ""    #No:MOD-A60184 add
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
   #LET g_action_choice = ""  #No:MOD-A60184 mark
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    IF g_account THEN LET l_allow_insert = FALSE END IF #MOD-CC0125 add
 
    LET g_forupd_sql = "SELECT gem01,gem02,gem03,gem05,gem07,gem09,gem10,'',gemacti", #FUN-670032#FUN-870100#FUN-A30097  #No.MOD-A60111
                       "  FROM gem_file WHERE gem01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    LET g_forupd_gbo_sql = "SELECT * FROM gbo_file",
                           " WHERE gbo01 = ? AND gbo04 = '1' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE gbo_bcl CURSOR FROM g_forupd_gbo_sql    

    INPUT ARRAY g_gem WITHOUT DEFAULTS FROM s_gem.*
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
        LET g_success = 'Y'            #FUN-9A0056 add
        CALL i030_set_entry_b()        #MOD-CC0125 add
        
        IF g_rec_b>=l_ac THEN
        #IF g_gem_t.gem01 IS NOT NULL THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_gem_t.* = g_gem[l_ac].*  #BACKUP
 
          #CALL i030_set_entry_b() #FUN-670032  #MOD-CC0125 mark
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i030_set_entry(p_cmd)                                           
           CALL i030_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end          
           OPEN i030_bcl USING g_gem_t.gem01
           IF STATUS THEN
              CALL cl_err("OPEN i030_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i030_bcl INTO g_gem[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gem_t.gem01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
#              CALL i030_gem11('d')    #FUN-870100 ADD#FUN-A30097 mark
              CALL i030_get_gem02a(g_gem[l_ac].gem01,g_gem[l_ac].gem02,g_gem[l_ac].gem10) 
                  RETURNING g_gem[l_ac].gem02a  #FUN-670032
                  
              ###FUN-920138 START ###
              OPEN gbo_bcl USING g_gem_t.gem01   
              IF STATUS THEN
                 CALL cl_err("OPEN gbo_bcl:", STATUS, 1)
              END IF
              ###FUN-920138 END ###
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                        
         CALL i030_set_entry(p_cmd)                                             
         CALL i030_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end     
         INITIALIZE g_gem[l_ac].* TO NULL      #900423
         LET g_gem[l_ac].gemacti = 'Y'       #Body default
         LET g_gem[l_ac].gem05 = 'Y'       #Body default
         IF g_aaz.aaz90='Y' THEN
            LET g_gem[l_ac].gem09='3'
         END IF
         LET g_gem_t.* = g_gem[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gem01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i030_bcl
           CLOSE gbo_bcl   #FUN-920138
           CANCEL INSERT
        END IF
  
        BEGIN WORK                    #FUN-680011
 
        INSERT INTO gem_file(gem01,gem02,gem03,gem05,gem06,gem07,
                             gem09,gem10,gemacti,gemuser,gemdate,gemoriu,gemorig) #FUN-670032 #FUN-870100 #FUN-A30097 
        VALUES(g_gem[l_ac].gem01,g_gem[l_ac].gem02,
               g_gem[l_ac].gem03,g_gem[l_ac].gem05,
               '',g_gem[l_ac].gem07,
               g_gem[l_ac].gem09,g_gem[l_ac].gem10, #FUN-670032
               g_gem[l_ac].gemacti,  #FUN-870100 #FUN-A30097 
               g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN 
#          CALL cl_err(g_gem[l_ac].gem01,SQLCA.sqlcode,0)   #No.FUN-660131
           CALL cl_err3("ins","gem_file",g_gem[l_ac].gem01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           CANCEL INSERT
        ELSE
           LET g_success = 'Y'    #FUN-9A0056 add
           #LET g_u_flag=''        #FUN-870101 add   #FUN-9A0056 mark
           #FUN-680011 
           #MESSAGE 'INSERT O.K'
           #LET g_rec_b=g_rec_b+1
           #DISPLAY g_rec_b TO FORMONLY.cn2  
           
           #FUN-890113 start
           CASE aws_mdmdata('gem_file','insert',g_gem[l_ac].gem01,base.TypeInfo.create(g_gem[l_ac]),'CreateDepartmentData')
              WHEN 0  #無與 MDM 整合
                   CALL cl_msg('INSERT O.K')
                   LET g_success = 'Y'                             #FUN-9A0056 add
                  #LET g_u_flag='0'                                #FUN-9A0056 mark
              WHEN 1  #呼叫 MDM 成功
                   CALL cl_msg('INSERT O.K, INSERT MDM O.K')
                   LET g_success = 'Y'                             #FUN-9A0056 add
                  #LET g_u_flag='0'                                #FUN-9A0056 mark
              WHEN 2  #呼叫 MDM 失敗
                   LET g_success = 'N'                             #FUN-9A0056 add
                  #LET g_u_flag='1'                                #FUN-9A0056 mark
           END CASE
           #FUN-890113 end
 
           # CALL aws_spccli_base()
           # 傳入參數: (1)TABLE名稱, (2)修改資料,
           #           (3)功能選項：insert(新增),update(修改),delete(刪除)
           CASE aws_spccli_base('gem_file',base.TypeInfo.create(g_gem[l_ac]),'insert')    
              WHEN 0  #無與 SPC 整合
                   MESSAGE 'INSERT O.K'
                   LET g_success = 'Y'                  #FUN-9A0056 add
                  #LET g_u_flag='0'                     #FUN-870101 add    #FUN-9A0056 mark
                  #LET g_rec_b=g_rec_b+1             #FUN-870101 mark
                  #DISPLAY g_rec_b TO FORMONLY.cn2   #FUN-870101 mark 
              WHEN 1  #呼叫 SPC 成功
                   MESSAGE 'INSERT O.K, INSERT SPC O.K'
                   LET g_success = 'Y'                  #FUN-9A0056 add
                  #LET g_u_flag='0'                     #FUN-870101 add    #FUN-9A0056 mark
                  #LET g_rec_b=g_rec_b+1             #FUN-870101 mark
                  #DISPLAY g_rec_b TO FORMONLY.cn2   #FUN-870101 mark
              WHEN 2  #呼叫 SPC 失敗
                   LET g_success = 'N'                  #FUN-9A0056 add
                  #LET g_u_flag='1'                     #FUN-870101 add    #FUN-9A0056 mark
                  #ROLLBACK WORK                     #FUN-870101 mark
                  #CANCEL INSERT                     #FUN-870101 mark
           END CASE

          #FUN-9A0056 mark str ---------- 
          #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
          #   #FUN-870101---add---str---
          #   # CALL aws_mescli()
          #   # 傳入參數: (1)程式代號
          #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
          #   #           (3)Key
          #    CASE aws_mescli('aooi030','insert',g_gem[l_ac].gem01)
          #       WHEN 0  #無與 MES 整合
          #            LET g_u_flag='0'           
          #            MESSAGE 'INSERT O.K'
          #       WHEN 1  #呼叫 MES 成功
          #            LET g_u_flag='0'           
          #            MESSAGE 'INSERT O.K, INSERT MES O.K'
          #       WHEN 2  #呼叫 MES 失敗
          #            LET g_u_flag='1'           
          #    END CASE
          #   #FUN-870101---add---end---
          #END IF  #TQC-8B0011  ADD
          #FUN-9A0056 mark end -----------

          #FUN-9A0056 add begin -------
          #新增資料為有效才傳送MES
           IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_gem[l_ac].gemacti='Y' THEN
              CALL i030_mes('insert',g_gem[l_ac].gem01)
           END IF
          #FUN-9A0056 add end -------  

             #IF g_u_flag='1' THEN         #FUN-9A0056 mark
              IF g_success = 'N' THEN      #FUN-9A0056 add
                 ROLLBACK WORK                                     
                 CANCEL INSERT                                     
              ELSE 
                 LET g_rec_b=g_rec_b+1                             
                 DISPLAY g_rec_b TO FORMONLY.cn2                   
                 COMMIT WORK 
              END IF
           #COMMIT WORK           #FUN-870101 mark
           #END FUN-680011 
        END IF
 
    AFTER FIELD gem01                        #check 編號是否重複
        IF NOT cl_null(g_gem[l_ac].gem01) THEN
           IF g_gem[l_ac].gem01 != g_gem_t.gem01 OR g_gem_t.gem01 IS NULL THEN
              SELECT COUNT(*) INTO g_cnt FROM gen_file 
               WHERE gen03 = g_gem_t.gem01 
              IF g_cnt > 0 THEN 
                 CALL cl_err('','aoo-105',1) 
                 LET g_gem[l_ac].gem01 = g_gem_t.gem01 
                 NEXT FIELD gem01 
              ELSE 
                 SELECT COUNT(*) INTO g_cnt FROM cpf_file 
                 WHERE cpf29 = g_gem_t.gem01 
                 IF g_cnt > 0 THEN 
                    CALL cl_err('','aoo-105',1) 
                    LET g_gem[l_ac].gem01 = g_gem_t.gem01 
                    NEXT FIELD gem01 
                 END IF 
              END IF 
              SELECT count(*) INTO g_cnt FROM gem_file
               WHERE gem01 = g_gem[l_ac].gem01
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_gem[l_ac].gem01 = g_gem_t.gem01
                 NEXT FIELD gem01
              END IF
              DISPLAY 'SELECT COUNT OK'
              #FUN-670032...............begin
              LET g_gem[l_ac].gem09 ='3'
              LET g_gem[l_ac].gem10 =NULL
              LET g_gem[l_ac].gem02a=NULL
              DISPLAY BY NAME g_gem[l_ac].gem09,
                              g_gem[l_ac].gem10,
                              g_gem[l_ac].gem02a
              #FUN-670032...............end
           END IF
        END IF
 
    AFTER FIELD gem05
        IF g_gem[l_ac].gem05 IS NOT NULL THEN
           IF g_gem[l_ac].gem05 NOT MATCHES '[YN]' THEN
              NEXT FIELD gem05
           END IF
        END IF
 
    AFTER FIELD gem07
        IF NOT cl_null(g_gem[l_ac].gem07) THEN 
           IF g_gem[l_ac].gem07[1,1] NOT MATCHES '[MPRS]' THEN 
              NEXT FIELD gem07
           END IF
        END IF
 
    #FUN-670032...............begin
    ON CHANGE gem09
        CASE g_gem[l_ac].gem09
           WHEN "1"
              LET g_gem[l_ac].gem10 =g_gem[l_ac].gem01
              LET g_gem[l_ac].gem02a=g_gem[l_ac].gem02
              DISPLAY BY NAME g_gem[l_ac].gem10,g_gem[l_ac].gem02a
           WHEN "2"
              LET g_gem[l_ac].gem10 =g_gem[l_ac].gem01
              LET g_gem[l_ac].gem02a=g_gem[l_ac].gem02
              DISPLAY BY NAME g_gem[l_ac].gem10,g_gem[l_ac].gem02a
           WHEN "3"
              LET g_gem[l_ac].gem10=NULL
              LET g_gem[l_ac].gem02a=NULL
              DISPLAY BY NAME g_gem[l_ac].gem10,g_gem[l_ac].gem02a
           OTHERWISE
              LET g_gem[l_ac].gem10=NULL
              LET g_gem[l_ac].gem02a=NULL
              DISPLAY BY NAME g_gem[l_ac].gem10,g_gem[l_ac].gem02a
        END CASE
    #FUN-670032...............end
    
    #TQC-6C0093...............begin
    AFTER FIELD gem09
        CASE g_gem[l_ac].gem09
           WHEN "1"
              CALL cl_set_comp_required("gem10",TRUE)
           WHEN "2"
              CALL cl_set_comp_required("gem10",TRUE)
           WHEN "3"
              CALL cl_set_comp_required("gem10",FALSE)
           OTHERWISE
              CALL cl_set_comp_required("gem10",FALSE)
        END CASE
    #TQC-6C0093...............end
 
    AFTER FIELD gem10
        IF NOT cl_null(g_gem[l_ac].gem10) THEN
           IF g_gem[l_ac].gem01<>g_gem[l_ac].gem10 THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM gem_file
                  WHERE gem01=g_gem[l_ac].gem10
                    AND gemacti='Y'
              IF l_cnt=0 THEN
                 CALL cl_err3("sel","gem_file",g_gem[l_ac].gem10,"",100,"","",1)
                 LET g_gem[l_ac].gem10=g_gem_t.gem10
                 LET g_gem[l_ac].gem02a=g_gem_t.gem02a
                 DISPLAY BY NAME g_gem[l_ac].gem10,g_gem[l_ac].gem02a
                 NEXT FIELD gem10
              END IF
           END IF
           CALL i030_get_gem02a(g_gem[l_ac].gem01,
                                g_gem[l_ac].gem02,
                                g_gem[l_ac].gem10) 
              RETURNING g_gem[l_ac].gem02a
           DISPLAY BY NAME g_gem[l_ac].gem10
        ELSE
           LET g_gem[l_ac].gem10=NULL
           DISPLAY BY NAME g_gem[l_ac].gem10
        END IF 
    #FUN-670032...............end
#FUN-A30097 mark  ------------------------------begin----------  
#    AFTER FIELD gem11
#        IF NOT cl_null(g_gem[l_ac].gem11) THEN
#           SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01=g_gem[l_ac].gem11
#           IF l_n=0 THEN
#              CALL cl_err('','aoo-253',0)
#              DISPLAY BY NAME g_gem_t.gem11
#              NEXT FIELD gem11
#           END IF
#           CALL i030_gem11('d')
#        END IF
#FUN-A30097 mark------------------------------------end--------------------
           
 
    BEFORE DELETE                            #是否取消單身

        LET g_success = 'Y'                  #FUN-9A0056 add
    {Modify :3015,,,99-02-24,刪除前先檢查此部門是否有員工棲屬}
        SELECT COUNT(*) INTO g_cnt FROM gen_file 
         WHERE gen03 = g_gem_t.gem01  
        IF g_cnt > 0 THEN 
           CALL cl_err('','aoo-105',1) 
        ELSE 
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM cpf_file 
          WHERE cpf29 = g_gem_t.gem01 
          IF g_cnt > 0 THEN 
             CALL cl_err('','aoo-105',1) 
          END IF 
        END IF 
       #IF g_rec_b>=l_ac THEN              #MOD-C70101 mark   
        IF g_gem_t.gem01 IS NOT NULL THEN  #MOD-C70101 remark
           IF g_cnt = 0 THEN 
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
              LET g_doc.column1 = "gem01"               #No.FUN-9B0098 10/02/24
              LET g_doc.value1 = g_gem[l_ac].gem01      #No.FUN-9B0098 10/02/24
              CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM gem_file WHERE gem01 = g_gem_t.gem01
              IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gem_t.gem01,SQLCA.sqlcode,0)   #No.FUN-660131
                 CALL cl_err3("del","gem_file",g_gem_t.gem01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 EXIT INPUT
              END IF
              #FUN-680011 
              #LET g_rec_b=g_rec_b-1
              #DISPLAY g_rec_b TO FORMONLY.cn2  
              #COMMIT WORK
              
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)修改資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
              CASE aws_spccli_base('gem_file',base.TypeInfo.create(g_gem[l_ac]),'delete')   
                 WHEN 0  #無與 SPC 整合
                      MESSAGE 'DELETE O.K.'
                      LET g_success = 'Y'              #FUN-9A0056 add
                     #LET g_u_flag='0'                 #FUN-870101 add   #FUN-9A0056 mark
                     #LET g_rec_b=g_rec_b-1            #FUN-870101 mark
                     #DISPLAY g_rec_b TO FORMONLY.cn2  #FUN-870101 mark 
                     #COMMIT WORK                      #FUN-870101 mark
                 WHEN 1  #呼叫 SPC 成功
                      MESSAGE 'DELETE O.K. DELETE SPC O.K'
                      LET g_success = 'Y'              #FUN-9A0056 add
                     #LET g_u_flag='0'                 #FUN-870101 add   #FUN-9A0056 mark
                     #LET g_rec_b=g_rec_b-1            #FUN-870101 mark
                     #DISPLAY g_rec_b TO FORMONLY.cn2  #FUN-870101 mark   
                     #COMMIT WORK                      #FUN-870101 mark
              
                 WHEN 2  #呼叫 SPC 失敗
                      LET g_success = 'N'              #FUN-9A0056 add
                     #LET g_u_flag='1'                 #FUN-870101 add  #FUN-9A0056 mark
                     #ROLLBACK WORK  
                     #CANCEL DELETE
              END CASE
              #END FUN-680011 

              #FUN-9A0056 mark str ----------
              #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
              #   #FUN-870101---add---str---
              #  # CALL aws_mescli()
              #   # 傳入參數: (1)程式代號
              #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #   #           (3)Key
              #    CASE aws_mescli('aooi030','delete',g_gem_t.gem01)
              #       WHEN 0  #無與 MES 整合
              #            LET g_u_flag='0'           
              #            MESSAGE 'DELETE O.K'
              #       WHEN 1  #呼叫 MES 成功
              #            LET g_u_flag='0'           
              #            MESSAGE 'DELETE O.K, DELETE MES O.K'
              #       WHEN 2  #呼叫 MES 失敗
              #            LET g_u_flag='1'           
              #    END CASE
              #    IF g_u_flag='1' THEN 
              #       ROLLBACK WORK                                     
              #       CANCEL DELETE
              #    ELSE 
              #      #LET g_rec_b=g_rec_b-1              #MOD-950054 mark
              #      #DISPLAY g_rec_b TO FORMONLY.cn2    #MOD-950054 mark
              #       COMMIT WORK 
              #    END IF
              #   #FUN-870101---add---end---
              #END IF  #TQC-8B0011  ADD             
              #LET g_rec_b=g_rec_b-1                     #MOD-950054 add
              #DISPLAY g_rec_b TO FORMONLY.cn2           #MOD-950054 add
              #FUN-9A0056 mark end ---------  
              
              ###FUN-920138 START ###
                 #刪除與"部門與部門群組上線控管"同步
                 DELETE FROM gbo_file 
                    WHERE gbo01 = g_gem_t.gem01 AND gbo04 = '1'
                 IF SQLCA.sqlcode THEN
                    LET g_success = 'N'                   #FUN-9A0056 add
                    CALL cl_err3("del","gbo_file",g_gem_t.gem01,"",SQLCA.sqlcode,"","BODY DELETE",0)
                 END IF
              ###FUN-920138 END ###
              
              #FUN-9A0056 add str ------- 
             #有效資料刪除時才傳送MES
              IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_gem_t.gemacti='Y' THEN
                CALL i030_mes('delete',g_gem_t.gem01)
              END IF

              IF g_success = 'N' THEN
                ROLLBACK WORK
                CANCEL DELETE
              ELSE
                COMMIT WORK
              END IF
              
              LET g_rec_b=g_rec_b-1                      
              DISPLAY g_rec_b TO FORMONLY.cn2            
             #FUN-9A0056 add end -------
            ELSE
              ROLLBACK WORK
              EXIT INPUT 
            END IF 
 
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_gem[l_ac].* = g_gem_t.*
           CLOSE i030_bcl
           CLOSE gbo_bcl   #FUN-920138
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gem[l_ac].gem01,-263,0)
           LET g_gem[l_ac].* = g_gem_t.*
        ELSE
           LET g_success = 'Y'   #FUN-9A0056 add
           UPDATE gem_file 
               SET gem01=g_gem[l_ac].gem01,gem02=g_gem[l_ac].gem02,
                   gem03=g_gem[l_ac].gem03,gem05=g_gem[l_ac].gem05,
                   gem07=g_gem[l_ac].gem07,gemacti=g_gem[l_ac].gemacti,
                   gem09=g_gem[l_ac].gem09,gem10=g_gem[l_ac].gem10, #FUN-670032
#                   gem11=g_gem[l_ac].gem11, #FUN-870100 #FUN-A30097 mark
                   gemmodu=g_user,gemdate=g_today
            WHERE gem01 = g_gem_t.gem01
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_gem[l_ac].gem01,SQLCA.sqlcode,0)   #No.FUN-660131
              CALL cl_err3("upd","gem_file",g_gem[l_ac].gem01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_gem[l_ac].* = g_gem_t.*
           ELSE
              ###FUN-920138 START ###
              #有效變成無效
              IF g_gem_t.gemacti = "Y" AND g_gem[l_ac].gemacti = "N" THEN   
                 #刪除與"部門與部門群組上線控管"同步
                 DELETE FROM gbo_file 
                    WHERE gbo01 = g_gem[l_ac].gem01 AND gbo04 = '1'
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","gbo_file",g_gem[l_ac].gem01,"",SQLCA.sqlcode,"","",0)
                 END IF
              END IF
              
              #修改key與"部門與部門群組上線控管"同步
              IF g_gem[l_ac].gemacti = "Y" THEN
                 UPDATE gbo_file 
                    SET gbo01 = g_gem[l_ac].gem01
                    WHERE gbo01 = g_gem_t.gem01 AND gbo04 = '1'
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","gbo_file",g_gem[l_ac].gem01,"",SQLCA.sqlcode,"","",0)
                 END IF
              END IF
              ###FUN-920138 END ###
           
              #LET g_u_flag=''   #FUN-870101 add    #FUN-9A0056 mark
              
              #FUN-680011 
              #MESSAGE 'UPDATE O.K'
              #COMMIT WORK
               
              #FUN-890113 start
              CASE aws_mdmdata('gem_file','update',g_gem[l_ac].gem01,base.TypeInfo.create(g_gem[l_ac]),'CreateDepartmentData')
              WHEN 0  #無與 MDM 整合
                   #LET g_u_flag='0'                               #FUN-9A0056 mark
                   LET g_success = 'Y'                            #FUN-9A0056 add
                   CALL cl_msg('UPDATE O.K')
              WHEN 1  #呼叫 MDM 成功
                   #LET g_u_flag='0'                               #FUN-9A0056 mark
                   LET g_success = 'Y'                            #FUN-9A0056 add
                   CALL cl_msg('UPDATE O.K, UPDATE MDM O.K')
              WHEN 2  #呼叫 MDM 失敗
                   LET g_success = 'N'                            #FUN-9A0056 add
                   #LET g_u_flag='1'                               #FUN-9A0056 mark
              END CASE
              #FUN-890113 end 
              
              # CALL aws_spccli_base()
              # 傳入參數: (1)TABLE名稱, (2)修改資料,
              #           (3)功能選項：insert(新增),update(修改),delete(刪除)
              CASE aws_spccli_base('gem_file',base.TypeInfo.create(g_gem[l_ac]),'update')    
                 WHEN 0  #無與 SPC 整合
                     #LET g_u_flag='0'     #FUN-870101 add        #FUN-9A0056 mark
                      LET g_success = 'Y'                         #FUN-9A0056 add     
                      MESSAGE 'UPDATE O.K'
                     #COMMIT WORK
                 WHEN 1  #呼叫 SPC 成功
                     #LET g_u_flag='0'     #FUN-870101 add        #FUN-9A0056 mark
                      LET g_success = 'Y'                         #FUN-9A0056 add     
                      MESSAGE 'UPDATE O.K. UPDATE SPC O.K'
                     #COMMIT WORK
              
                 WHEN 2  #呼叫 SPC 失敗
                      LET g_success = 'N'  #FUN-9A0056 add
                     #LET g_u_flag='1'     #FUN-870101 add        #FUN-9A0056 mark     
                     #ROLLBACK WORK  
                     #LET g_gem[l_ac].* = g_gem_t.*
              END CASE
              #END FUN-680011 

              #FUN-9A0056 mark str -------- 
              #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
              #  #FUN-870101---add---str---
              #  # CALL aws_mescli()
              #   # 傳入參數: (1)程式代號
              #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #   #           (3)Key
              #    CASE aws_mescli('aooi030','update',g_gem[l_ac].gem01)
              #       WHEN 0  #無與 MES 整合
              #            LET g_u_flag='0'           
              #            MESSAGE 'UPDATE O.K'
              #       WHEN 1  #呼叫 MES 成功
              #            LET g_u_flag='0'           
              #            MESSAGE 'UPDATE O.K, UPDATE MES O.K'
              #       WHEN 2  #呼叫 MES 失敗
              #            LET g_u_flag='1'           
              #    END CASE
              #    #IF g_u_flag='1' THEN 
              #    #   ROLLBACK WORK                                     
              #    #   LET g_gem[l_ac].* = g_gem_t.*
              #    #ELSE 
              #    #   COMMIT WORK 
              #    #END IF
              #   #FUN-870101---add---end---
              #END IF #TQC-8B0011 ADD
              #FUN-9A0056 mark end ----------

             #FUN-9A0056 add str ------
              IF g_aza.aza90 MATCHES "[Yy]" AND g_success = 'Y' THEN
                CASE
                  WHEN (g_gem_t.gemacti='Y' AND g_gem[l_ac].gemacti='N')  #有效變無效
                     CALL i030_mes('delete',g_gem_t.gem01)
                  WHEN (g_gem_t.gemacti='N' AND g_gem[l_ac].gemacti='Y')  #無效變有效
                     CALL i030_mes('insert',g_gem_t.gem01)
                  WHEN (g_gem_t.gemacti='Y' AND g_gem[l_ac].gemacti='Y')  #有效資料異動內容
                     CALL i030_mes('update',g_gem_t.gem01)
                END CASE
              END IF  
             #FUN-9A0056 add end ------

              IF g_success = 'N' THEN      #FUN-9A0056 add
             #IF g_u_flag='1' THEN         #FUN-9A0056 mark
                 ROLLBACK WORK                                     
                 LET g_gem[l_ac].* = g_gem_t.*
              ELSE 
                 COMMIT WORK 
              END IF
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
       #LET l_ac_t = l_ac             # 新增   #FUN-D40030 Mark
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gem[l_ac].* = g_gem_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_gem.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i030_bcl         # 新增
           CLOSE gbo_bcl          #FUN-920138
           ROLLBACK WORK          # 新增
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac                    #FUN-D40030 Add
        CLOSE i030_bcl            # 新增
        CLOSE gbo_bcl             #FUN-920138
        COMMIT WORK
 
     #FUN-670032...............begin
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(gem10)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              CALL cl_create_qry() RETURNING g_gem[l_ac].gem10
              DISPLAY BY NAME g_gem[l_ac].gem10
              NEXT FIELD gem10
#FUN-A30097 mark ------------begin-----------------
#           #FUN-870100---begin
#           WHEN INFIELD(gem11)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azp"
#              CALL cl_create_qry() RETURNING g_gem[l_ac].gem11
#              DISPLAY BY NAME g_gem[l_ac].gem11
#              CALL i030_gem11('d')
#              NEXT FIELD gem11
#           #FUN-870100---end
#FUN-A30097 mark--------------------end-----------------
        END CASE 
        
     #FUN-670032...............end
 
#    ON ACTION CONTROLN
#        CALL i030_b_askkey()
#        EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gem01) AND l_ac > 1 THEN
             LET g_gem[l_ac].* = g_gem[l_ac-1].*
             NEXT FIELD gem01
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
 
 
    CLOSE i030_bcl
    COMMIT WORK
END FUNCTION

#FUN-A30097 mark-------------------begin---------------------- 
#FUNCTION i030_gem11(p_cmd)
#DEFINE  p_cmd        LIKE type_file.chr1 
#DEFINE  l_gem11      LIKE azp_file.azp02
#DEFINE l_gemacti     LIKE gem_file.gemacti
#    
#    LET g_errno = ' '
#    SELECT azp02 INTO l_gem11 FROM azp_file WHERE azp01=g_gem[l_ac].gem11
#    CASE                          
#        WHEN SQLCA.sqlcode=100   LET g_errno = 'aoo-254'
#                                 LET l_gem11 = NULL
#        WHEN l_gemacti='N'       LET g_errno='9028'
#        OTHERWISE   
#        LET g_errno=SQLCA.sqlcode USING '------' 
#    END CASE 
# 
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       LET g_gem[l_ac].gem11_desc=l_gem11
#       DISPLAY BY NAME g_gem[l_ac].gem11_desc
#  END IF
# 
#END FUNCTION
#FUN-A30097 mark--------------------------end-------------------
 
FUNCTION i030_b_askkey()
 
    CLEAR FORM
   CALL g_gem.clear()
 
    CONSTRUCT g_wc2 ON gem01,gem02,gem03,gem05,gem07,gem09,gem10,gemacti #FUN-670032 #FUN-870100 #FUN-A30097 
         FROM s_gem[1].gem01,s_gem[1].gem02,s_gem[1].gem03,
              s_gem[1].gem05,s_gem[1].gem07,
              s_gem[1].gem09,  #FUN-670032 #FUN-870100 #FUN-A30097 
              s_gem[1].gem10,    #TQC-A50075  add s_gem[1].gem10
              s_gem[1].gemacti
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      #FUN-670032...............begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gem10)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gem10
               NEXT FIELD gem10
#FUN-A30097 mark----------------------begin---------------
#            #FUN-870100---begin
#            WHEN INFIELD(gem11)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  = "q_gem11"
#               LET g_qryparam.state = "c"   #多選
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO gem11
#               NEXT FIELD gem11
#               CALL i030_gem11('d')
#            #FUN-870100---end
#FUN-A30097 mark---------------------------end----------------
         END CASE 
      #FUN-670032...............end
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gemuser', 'gemgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0    #MOD-C10154 add
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i030_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT gem01,gem02,gem03,gem05,gem07,gem09,gem10,'',gemacti", #FUN-670032 #FUN-A30097 #No.MOD-A60111
        " FROM gem_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i030_pb FROM g_sql
    DECLARE gem_curs CURSOR FOR i030_pb
 
    CALL g_gem.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gem_curs INTO g_gem[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL i030_get_gem02a(g_gem[g_cnt].gem01,g_gem[g_cnt].gem02,g_gem[g_cnt].gem10) 
             RETURNING g_gem[g_cnt].gem02a  #FUN-670032
#        SELECT azp02 INTO g_gem[g_cnt].gem11_desc FROM azp_file WHERE azp01 = g_gem[g_cnt].gem11 #FUN-A30097 mark
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gem.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gem TO s_gem.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      #FUN-670032...............begin
      ON ACTION account
         LET g_action_choice="account"
         EXIT DISPLAY
      #FUN-670032...............end
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
 
     #TQC-6C0093...............mark begin 
     #ON ACTION export
     #   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gem),'','') 
     #   EXIT DISPLAY
     #TQC-6C0093...............mark end
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #No.FUN-580093 --start--
      ON ACTION online_count
         LET g_action_choice = 'online_count'
         EXIT DISPLAY
      #No.FUN-580093 ---end---
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i030_out()
    DEFINE
        l_gem           RECORD LIKE gem_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,                #  #No.FUN-680102 VARCHAR(40)
        l_gem02a        LIKE gem_file.gem02                    #No.FUN-760083  
 
    IF g_wc2 IS NULL THEN 
#       CALL cl_err('',-400,0)    #No.TQC-710076
       CALL cl_err('','9057',0)
     RETURN 
    END IF
    LET l_gem02a=' '                                             #No.FUN-760083
    CALL cl_del_data(l_table)                                    #No.FUN-760083
    LET g_str=' '                                                #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog       #No.FUN-760083
    CALL cl_wait()
#   LET l_name = 'aooi030.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gem_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i030_co                         # SCROLL CURSOR
         CURSOR FOR i030_p1
 
    #CALL cl_outnam('aooi030') RETURNING l_name          #No.FUN-760083  
    #FUN-670032...............begin
    IF g_aaz.aaz90<>'Y' THEN   #是否使用利潤中心功能
   #   LET g_zaa[37].zaa06='Y'                       #No.FUN-760083 mark
   #   LET g_zaa[38].zaa06='Y'                       #No.FUN-760083 mark
   #   LET g_zaa[39].zaa06='Y'                       #No.FUN-760083 mark
       LET l_name="aooi030_1"                        #No.FUN-760083  
    ELSE                                             #No.FUN-760083  
       LET l_name="aooi030"                          #No.FUN-760083  
    END IF
    #FUN-670032...............end
    #START REPORT i030_rep TO l_name                 #No.FUN-760083  
    #CALL cl_prt_pos_len()  #TQC-6A0090 add          #No.FUN-760083  
    FOREACH i030_co INTO l_gem.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)    
          EXIT FOREACH
       END IF
       #OUTPUT TO REPORT i030_rep(l_gem.*)           #No.FUN-760083  
      #IF g_zaa[39].zaa06='N' THEN                   #No.FUN-760083                                                                            
       IF g_aaz.aaz90='Y' THEN                       #No.FUN-760083  #是否使用利潤中心功能
          SELECT gem02 INTO l_gem02a FROM gem_file               #No.FUN-760083                                                                
             WHERE gem01=sr.gem10                                #No.FUN-760083                                                                 
          IF SQLCA.sqlcode THEN                                  #No.FUN-760083                                                                
             LET l_gem02a=NULL                                   #No.FUN-760083                                                                
          END IF                                                 #No.FUN-760083                                                                
       END IF                                                        #No.FUN-760083  
       EXECUTE insert_prep USING                                                               #No.FUN-760083 
                           l_gem.gem01,l_gem.gem02,l_gem.gem03,l_gem.gem04,l_gem.gem05,        #No.FUN-760083 
                           l_gem.gem06,l_gem.gem07,l_gem.gem08,l_gem.gemacti,l_gem.gemuser,    #No.FUN-760083 
                           l_gem.gemgrup,l_gem.gemmodu,l_gem.gemdate,l_gem.gem09,l_gem.gem10,  #No.FUN-760083 
                           l_gem02a                                                            #No.FUN-760083  
    END FOREACH
 
    #FINISH REPORT i030_rep                           #No.FUN-760083  
 
    CLOSE i030_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)                #No.FUN-760083  
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED       #No.FUN-760083  
    IF g_zz05 ='Y' THEN
       CALL cl_wcchp(g_wc2,'gem01,gem02,gem03,gem05,gem07,gem09,gem10,gemacti')
       RETURNING g_wc2
    END IF
    LET g_str=g_wc2
    CALL cl_prt_cs3("aooi030",l_name,g_sql,g_str)        #No.FUN-760083         
 
END FUNCTION
#No.FUN-760083  --begin--
{
 
REPORT i030_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        l_gem02a LIKE gem_file.gem02, #FUN-670032
        sr RECORD LIKE gem_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gem01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],     #TQC-6B0023
                  g_x[36],g_x[37],g_x[38],g_x[39] 
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.gemacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
            #FUN-670032...............begin
            IF g_zaa[39].zaa06='N' THEN
               SELECT gem02 INTO l_gem02a FROM gem_file 
                  WHERE gem01=sr.gem10
               IF SQLCA.sqlcode THEN
                  LET l_gem02a=NULL
               END IF
            END IF
            #FUN-670032...............end
            PRINTX name = D1 COLUMN g_c[32],sr.gem01,     #TQC-6B0023
                  COLUMN g_c[33],sr.gem02,
                  COLUMN g_c[34],sr.gem03,
                  COLUMN g_c[35],sr.gem05,
                  COLUMN g_c[36],sr.gem07,
                  COLUMN g_c[37],sr.gem09, #FUN-670032
                  COLUMN g_c[38],sr.gem10, #FUN-670032
                  COLUMN g_c[39],l_gem02a  #FUN-670032
 
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
#No.FUN-760083  --end--
 
#No.FUN-570110 --start                                                          
FUNCTION i030_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gem01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i030_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gem01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end              
 
#FUN-670032...............begin
FUNCTION i030_get_gem02a(p_gem01,p_gem02,p_gem10)
DEFINE p_gem01  LIKE gem_file.gem01,
       p_gem02  LIKE gem_file.gem02,
       p_gem10  LIKE gem_file.gem10,
       l_gem02a LIKE gem_file.gem02
   
   IF cl_null(p_gem10) THEN
      RETURN NULL
   ELSE
      IF p_gem10 = p_gem01 THEN
         LET l_gem02a=p_gem02
      ELSE
         SELECT gem02 INTO l_gem02a FROM gem_file
                                   WHERE gem01=p_gem10
      END IF
      RETURN l_gem02a
   END IF
END FUNCTION
 
FUNCTION i030_acc()
   LET g_account=TRUE
   CALL i030_b()
   LET g_account=FALSE
END FUNCTION
 
FUNCTION i030_set_entry_b()
   CASE g_account
      WHEN TRUE
         CALL cl_set_comp_entry("gem01,gem02,gem03,gemacti",FALSE)
         CALL cl_set_comp_entry("gem05,gem07,gem09,gem10",TRUE)
      OTHERWISE
         CALL cl_set_comp_entry("gem01,gem02,gem03,gemacti",TRUE)
         CALL cl_set_comp_entry("gem05,gem07,gem09,gem10",FALSE)
   END CASE
END FUNCTION
#FUN-670032...............end

#FUN-9A0056 -- add i030_mes() for MES
FUNCTION i030_mes(p_key1,p_key2)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('aooi030',p_key1,p_key2)
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE

END FUNCTION
