# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aimp620.4gl
# Descriptions...: 料件儲位各期異動統計重計作業
# Date & Author..: 93/06/01 By Felicity Tseng
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No:9900 04/09/03 By Nicola 庫存 imk_file 會有亂掉
# Modify.........: No.MOD-4A0251 04/10/18 By Mandy 1.連續切換語言時,程式執行順序羅輯有問題
# Modify.........: No.MOD-4A0251 04/10/18 By Mandy 2.離開BUTTOM要能作用
# Modify.........: No.FUN-550025 05/05/24 By Carrier 雙單位內容修改
# Modify.........: No.FUN-550082 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.MOD-570131 05/07/07 By pengu line 392\LET l_cmd ="chmod 77777 aimp620.out"修改為
                                          #        l_cmd ="chmod 777 l_name"
# Modify.........: No.MOD-590100 05/10/24 By pengu執行aimp620時若計算年度期別大
                                    #             於目前現行年度期別時應show警告
# Modify.........: NO.TQC-5C0050 05/12/19 BY Claire g_sql 錯誤
# Modify.........: NO.FUN-5C0001 06/01/03 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570122 06/02/16 By yiting 背景作業
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.MOD-650067 06/05/16 BY Claire g_sql 錯誤
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0057 06/11/14 By Ray 修正語言別切換無效
# Modify.........: No.FUN-710025 07/01/24 By bnlent 錯誤信息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-7B0017 07/11/08 By Pengu 若遇到單據別的成本分類為"X:非庫存異動"時則show訊息告知
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.MOD-860051 08/06/05 By Nicola SQL修改
# Modify.........: No.TQC-830014 08/07/14 By zhaijie輸入QBE條件后點確定，系統讓錄入年度，期別，這時候如果不想輸入，點退出，無法退出程序
# Modify.........: No.MOD-920317 09/02/24 By claire tlfs_file未考慮日期條件
# Modify.........: No.TQC-920085 09/02/25 By claire 重推imks_file以 tlfs10為單據而不是tlfs15
# Modify.........: No.TQC-920113 09/02/27 By claire p620_imks_p1少組g_w條件
# Modify.........: No.TQC-940049 09/04/13 By chenyu MOD-920317這個單號修改的g_wc1里面有tlff_file的字段，這樣在p620_imks_c2這個cursor的時候就會報錯
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.TQC-A60046 10/06/13 By chenmoyan p620_imks_p1中的OUTER MSV不認，改用標準LEFT OUTER JOIN的寫法
# Modify.........: No:MOD-A90060 10/09/08 By Summer 調整p620_imks_rep()的ORDER BY順序
# Modify.........: No:MOD-A90101 10/09/15 By Summer 將p620_rep(),p620_imkk_rep(),p620_imks_rep()裡的BEGIN WORK拿掉 
# Modify.........: No:MOD-A90133 10/09/20 By Summer 若有進行批序號管理會造成imgs或imks異常 
# Modify.........: No:TQC-AB0076 10/11/25 By sabrina 修改TQC-A60046的錯誤
# Modify.........: No:TQC-B30034 11/03/03 By yinhy mark没用到的CLOSE WINDOW p620_ww及CALL cl_ui_locale("aimp6201")
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-B40126 11/04/18 By destiny imk_file plant值更新错误    
# Modify.........: No.TQC-B40151 11/04/26 By destiny 期数计算错误                   
# Modify.........: No.TQC-B50156 11/05/31 By jan 還原TQC-B40151 程式處理
# Modify.........: No:MOD-B60109 11/07/17 By Summer 若料件為委外代買料，在計算時會有問題，會認為是tlf異常
# Modify.........: No:MOD-B80024 11/07/14 By zhangll sql缺少where條件
# Modify.........: No:FUN-C40088 12/08/08 By bart 增加選項"計算前先刪除當期資料"
# Modify.........: No:MOD-C80248 12/09/21 By Elise 修正FUN-C40088,應要刪當期資料而非上期
# Modify.........: No:FUN-CA0151 12/10/31 By bart 增加ICD計算
# Modify.........: No:FUN-CB0037 12/11/09 By bart 1.調整sql取資料的範圍為 (上期imk09 > 0 ) 
#                                                 2.針對已知影響效能程式進行處理，如：Declare的位置……等 
#                                                 3.不必要的DISPLAY
#                                                 4.rep段裡有一些delete或insert，改為先在外面定義，報表段再用execute執行
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能
# Modify.........: No.FUN-CC0064 12/12/20 By xumeimei 增加判斷:POS未日結,不允許執行！
# Modify.........: No.MOD-D60247 13/07/01 By fengmy 背景作業查詢條件為空時賦值


IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy               LIKE imk_file.imk05,
       mm               LIKE imk_file.imk06,
       next_compute     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       sw               LIKE type_file.chr1,    #NO.FUN-5C0001 ADD  #No.FUN-690026 VARCHAR(1)
       dc               LIKE type_file.chr1,    #FUN-C40088
       tlf0607_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_sql            string,                 #No.FUN-550025 #No.FUN-580092 HCN
       g_wc             string,                 #No.FUN-580092 HCN
       g_wc1            string,                 #No.FUN-550025 #No.FUN-580092 HCN
       g_wc2            string,                 #No.MOD-650067
       g_imk RECORD     
             imk01      LIKE imk_file.imk01,
             imk02      LIKE imk_file.imk02,
             imk03      LIKE imk_file.imk03,
             imk04      LIKE imk_file.imk04,
             imk081     LIKE imk_file.imk081,
             imk082     LIKE imk_file.imk082,
             imk083     LIKE imk_file.imk083,
             imk084     LIKE imk_file.imk084,
             imk085     LIKE imk_file.imk085,
             imk086     LIKE imk_file.imk086,
             imk09      LIKE imk_file.imk09
             END RECORD,
       g_imkk RECORD     
             imkk01      LIKE imkk_file.imkk01,
             imkk02      LIKE imkk_file.imkk02,
             imkk03      LIKE imkk_file.imkk03,
             imkk04      LIKE imkk_file.imkk04,
             imkk10      LIKE imkk_file.imkk10,
             imkk081     LIKE imkk_file.imkk081,
             imkk082     LIKE imkk_file.imkk082,
             imkk083     LIKE imkk_file.imkk083,
             imkk084     LIKE imkk_file.imkk084,
             imkk085     LIKE imkk_file.imkk085,
             imkk086     LIKE imkk_file.imkk086,
             imkk09      LIKE imkk_file.imkk09
             END RECORD,
       q_tlff RECORD
             tlff01		LIKE tlff_file.tlff01,  #料號    
             tlff06		LIKE tlff_file.tlff06,  #單據日期
             tlff07		LIKE tlff_file.tlff07,  #產生日期
             tlff10		LIKE tlff_file.tlff10,  #異動數量 
             tlff11		LIKE tlff_file.tlff11,  #異動單位 
             tlff12		LIKE tlff_file.tlff12,  #單位轉換率
             tlff02		LIKE tlff_file.tlff02,  #來源狀況
             tlff021		LIKE tlff_file.tlff021, #倉庫別
             tlff022		LIKE tlff_file.tlff022, #存放位置
             tlff023		LIKE tlff_file.tlff023, #批號 
             tlff026		LIKE tlff_file.tlff026, #
             tlff03		LIKE tlff_file.tlff03,  #目的狀況
             tlff031		LIKE tlff_file.tlff031, #倉庫別
             tlff032		LIKE tlff_file.tlff032, #存放位置
             tlff033		LIKE tlff_file.tlff033, #批號 
             tlff036		LIKE tlff_file.tlff036, #
             tlff13             LIKE tlff_file.tlff13   #MOD-B60109 add
             END RECORD,
       q_tlf RECORD
             tlf01		LIKE tlf_file.tlf01,  #料號    
             tlf06		LIKE tlf_file.tlf06,  #單據日期
             tlf07		LIKE tlf_file.tlf07,  #產生日期
             tlf10		LIKE tlf_file.tlf10,  #異動數量 
             tlf12		LIKE tlf_file.tlf12,  #單位轉換率
             tlf02		LIKE tlf_file.tlf02,  #來源狀況
             tlf021		LIKE tlf_file.tlf021, #倉庫別
             tlf022		LIKE tlf_file.tlf022, #存放位置
             tlf023		LIKE tlf_file.tlf023, #批號 
             tlf026		LIKE tlf_file.tlf026, #
             tlf03		LIKE tlf_file.tlf03,  #目的狀況
             tlf031		LIKE tlf_file.tlf031, #倉庫別
             tlf032		LIKE tlf_file.tlf032, #存放位置
             tlf033		LIKE tlf_file.tlf033, #批號 
             tlf036		LIKE tlf_file.tlf036, #
             tlf13              LIKE tlf_file.tlf13   #MOD-B60109 add
             END RECORD,
       g_imks RECORD     
              imks01      LIKE imks_file.imks01,
              imks02      LIKE imks_file.imks02,
              imks03      LIKE imks_file.imks03,
              imks04      LIKE imks_file.imks04,
              imks10      LIKE imks_file.imks10,
              imks11      LIKE imks_file.imks11,
              imks12      LIKE imks_file.imks12,
              imks081     LIKE imks_file.imks081,
              imks082     LIKE imks_file.imks082,
              imks083     LIKE imks_file.imks083,
              imks084     LIKE imks_file.imks084,
              imks085     LIKE imks_file.imks085,
              imks086     LIKE imks_file.imks086,
              imks09      LIKE imks_file.imks09
              END RECORD,
       q_tlfs RECORD
             tlfs01		LIKE tlfs_file.tlfs01,
             tlfs02		LIKE tlfs_file.tlfs02,
             tlfs03		LIKE tlfs_file.tlfs03,
             tlfs04		LIKE tlfs_file.tlfs04,
             tlfs05		LIKE tlfs_file.tlfs05,
             tlfs06		LIKE tlfs_file.tlfs06,
             tlfs09		LIKE tlfs_file.tlfs09,
             tlfs10 		LIKE tlfs_file.tlfs10, #TQC-920085 add 
             tlfs13 		LIKE tlfs_file.tlfs13,
             tlfs15 		LIKE tlfs_file.tlfs15 
             END RECORD,
       g_ima08          LIKE ima_file.ima08 ,
       g_bdate          LIKE type_file.dat,     #No.FUN-690026 DATE
       g_edate          LIKE type_file.dat,     #No.FUN-690026 DATE
       xxx              LIKE smy_file.smyslip,  #No.FUN-550082 #No.FUN-690026 VARCHAR(05)
       u_flag           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       p_row,p_col	LIKE type_file.num5     #No.FUN-690026 SMALLINT
#FUN-CA0151---begin
DEFINE g_idx RECORD 
            idx01  LIKE idx_file.idx01,
            idx02  LIKE idx_file.idx02,
            idx03  LIKE idx_file.idx03,
            idx04  LIKE idx_file.idx04,
            idx10  LIKE idx_file.idx10,
            idx11  LIKE idx_file.idx11,
            idx081 LIKE idx_file.idx081,
            idx082 LIKE idx_file.idx082,
            idx083 LIKE idx_file.idx083,
            idx084 LIKE idx_file.idx084,
            idx085 LIKE idx_file.idx085,
            idx09  LIKE idx_file.idx09
            END RECORD 
DEFINE g_idd RECORD
            idd01 LIKE idd_file.idd01,
            idd02 LIKE idd_file.idd02,
            idd03 LIKE idd_file.idd03,
            idd04 LIKE idd_file.idd04,
            idd05 LIKE idd_file.idd05,
            idd06 LIKE idd_file.idd06,
            idd12 LIKE idd_file.idd12,
            idd10 LIKE idd_file.idd10,
            idd13 LIKE idd_file.idd13
            END RECORD 
#FUN-CA0151---end
DEFINE g_change_lang    LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_cka00          LIKE cka_file.cka00     #FUN-C80092
DEFINE l_msg            STRING                  #FUN-C80092

MAIN
   DEFINE l_flag   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cnt    LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc = ARG_VAL(1)
   LET yy = ARG_VAL(2)
   LET mm = ARG_VAL(3)
   LET next_compute = ARG_VAL(4)
   LET tlf0607_flag = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET dc = ARG_VAL(7)  #FUN-C40088
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
   WHILE TRUE 
      LET g_success = 'Y'
 
      IF s_shut(0) THEN EXIT WHILE END IF
      IF g_bgjob = 'N' THEN  #NO.FUN-570122
         CALL p620_ask()
          IF cl_sure(20,20) THEN
   #FUN-C80092 -------------Begin---------------
             LET l_msg = "yy ='",yy,"'",";","mm = '",mm,"'",";","next_compute = '",next_compute,"'",";",
                         " sw = '",sw,"'",";","tlf0607_flag = '",tlf0607_flag,"'",";","g_bgjob = '",g_bgjob,"'"
             CALL s_log_ins(g_prog,yy,mm,g_wc,l_msg)
                  RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
              BEGIN WORK  #NO.FUN-570122
          #-------MOD-590100判斷是否大於現行年月
              IF (yy*12+mm)>=(g_sma.sma51*12+g_sma.sma52) THEN
                  IF NOT(cl_confirm("aim-928 ")) THEN
                      CONTINUE WHILE
                  END IF
              END IF
              CALL p620()
              CALL s_showmsg()      #No.FUN-710025
              IF g_success = 'Y' THEN
                  IF g_sma.sma115 = 'Y' THEN
                      CALL p620_imkk()
                  END IF
              END IF
              IF g_success = "Y" THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM ima_file
                  WHERE (ima918='Y' OR ima921='Y')
                 IF l_cnt > 0 THEN 
                    CALL p620_imks()
                 END IF
              END IF
              #FUN-CA0151---begin
              IF g_success = "Y" THEN
                 IF s_industry('icd') THEN
                    CALL p620_idx()
                 END IF 
              END IF 
              #FUN-CA0151---end
              IF g_success='Y' THEN
                  COMMIT WORK
                  CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
                  CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
              ELSE
                  ROLLBACK WORK
                  CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
                  CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
              END IF
              IF l_flag THEN
                  CONTINUE WHILE
              ELSE
                  CLOSE WINDOW p620_w
                  EXIT WHILE
              END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "yy ='",yy,"'",";","mm = '",mm,"'",";","next_compute = '",next_compute,"'",";",
                     " sw = '",sw,"'",";","tlf0607_flag = '",tlf0607_flag,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,yy,mm,g_wc,l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
          BEGIN WORK
          CALL p620()
          CALL s_showmsg()     #No.FUN-710025
          IF g_success = 'Y' THEN
             IF g_sma.sma115 = 'Y' THEN
                 CALL p620_imkk()
             END IF
          END IF
          IF g_success = "Y" THEN
             SELECT COUNT(*) INTO l_cnt
               FROM ima_file
              WHERE (ima918='Y' OR ima921='Y')
             IF l_cnt > 0 THEN 
                CALL p620_imks()
             END IF
          END IF
          #FUN-CA0151---begin
          IF g_success = "Y" THEN
             IF s_industry('icd') THEN
                CALL p620_idx()
             END IF 
          END IF 
          #FUN-CA0151---end
          IF g_success = "Y" THEN
              COMMIT WORK
              CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
          ELSE
              ROLLBACK WORK
              CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
      END IF
 
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION p620_ask()
   DEFINE lc_cmd  LIKE type_file.chr1000#NO.FUN-571022 #No.FUN-690026 VARCHAR(500) 
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW p620_w AT p_row,p_col
        WITH FORM "aim/42f/aimp620"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('q')
 
WHILE TRUE
   CONSTRUCT BY NAME g_wc ON ima01,ima08
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
     ON ACTION locale
        LET g_action_choice = "locale"
        LET g_change_lang = TRUE     #No.TQC-6B0057
        EXIT CONSTRUCT
 
      ON ACTION exit                 #MOD-4A0251
        LET g_action_choice='exit'
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_wc1 = g_wc   #No.FUN-550025
   LET next_compute = 'N'
   LET tlf0607_flag = g_sma.sma892[1,1]
   IF tlf0607_flag IS NULL THEN LET tlf0607_flag = '1' END IF
   LET sw = 'Y'       #NO.FUN-5C0001 ADD
   LET dc = 'Y'       #FUN-C40088
   LET g_bgjob = 'N'  #NO.FUN-570122
   INPUT BY NAME yy,mm,next_compute,sw,dc,tlf0607_flag,g_bgjob WITHOUT DEFAULTS #NO.FUN-570122 #FUN-C40088 dc
      AFTER FIELD yy
          IF yy = 0 THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF NOT cl_null(mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF mm > 12 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF mm > 13 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
          IF mm = 0 THEN NEXT FIELD mm END IF                #TQC-830014
      AFTER FIELD next_compute
         IF cl_null(next_compute) OR next_compute NOT MATCHES '[YN]' THEN
            NEXT FIELD next_compute
         END IF
      AFTER FIELD tlf0607_flag
         IF cl_null(tlf0607_flag) OR tlf0607_flag NOT MATCHES '[12]' THEN
            NEXT FIELD tlf0607_flag
         END IF
 
       ON CHANGE g_bgjob
          IF g_bgjob = "Y" THEN
             LET sw = "N"
             DISPLAY BY NAME sw
             CALL cl_set_comp_entry("sw",FALSE)
          ELSE
             CALL cl_set_comp_entry("sw",TRUE)
          END IF
 
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
             NEXT FIELD g_bgjob
          END IF
 
      AFTER INPUT 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
      ON ACTION locale
           LET g_change_lang = TRUE
         EXIT INPUT
 
       ON ACTION exit                 #MOD-4A0251
         LET g_action_choice='exit'
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
    END IF
 
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp620"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aimp620','9031',1)
       ELSE
          LET g_wc=cl_replace_str(g_wc, "'", "\"")
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_wc CLIPPED,"'",
                       " '",yy CLIPPED,"'",
                       " '",mm CLIPPED,"'",
                       " '",next_compute CLIPPED,"'",
                       " '",tlf0607_flag CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",dc CLIPPED,"'"  #FUN-C40088
          CALL cl_cmdat('aimp620',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p620_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p620()
   DEFINE l_yy,l_mm   LIKE type_file.num10     #No.FUN-690026 INTEGER
   DEFINE l_bdate     LIKE type_file.dat       #No.FUN-690026 DATE
   DEFINE l_edate     LIKE type_file.dat       #No.FUN-690026 DATE
   DEFINE l_correct   LIKE type_file.chr1      #No.FUN-690026 VARCHAR(1)
   DEFINE l_cmd       LIKE type_file.chr1000   #No.FUN-690026 VARCHAR(80)
   DEFINE l_name      LIKE type_file.chr20     #No.FUN-690026 VARCHAR(20)
   DEFINE l_sql       STRING                   #NO.FUN-5C0001 ADD
   DEFINE l_cnt1      LIKE type_file.num10     #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
   DEFINE l_sw_tot    LIKE type_file.num10     #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
   DEFINE l_sw        LIKE type_file.num10     #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
   DEFINE l_count     LIKE type_file.num10     #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
   #FUN-CC0064-----add----str
   DEFINE l_posdb       LIKE ryg_file.ryg00
   DEFINE l_posdb_link  LIKE ryg_file.ryg02
   DEFINE l_days        LIKE type_file.num10
   DEFINE l_date        LIKE type_file.dat
   DEFINE l_date1       STRING
   DEFINE l_pos         LIKE type_file.num10
   DEFINE l_n           LIKE type_file.num5
   #FUN-CC0064-----add----end

   #FUN-CB0037---begin
   LET g_sql = " SELECT imk_file.* FROM imk_file ",
               "  WHERE imk01 = ? ",
               "    AND imk02 = ? ",
               "    AND imk03 = ? ",
               "    AND imk04 = ? ",
               "    AND   (imk05 > ",yy,
               "     OR   (imk05 = ",yy," AND imk06 > ",mm," ))"
   DECLARE p620_next_imk CURSOR FROM g_sql

   LET g_sql = " DELETE FROM imk_file ",
               "        WHERE imk01 = ? ", 
               "          AND imk02 = ? ",
               "          AND imk03 = ? ", 
               "          AND imk04 = ? ", 
               "          AND imk05 = ",yy,    
               "          AND imk06 = ",mm
   PREPARE del_imk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('delete imk1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " INSERT INTO imk_file(imk01,imk02,imk03,imk04,imk05,imk06, ",
               "                      imk081,imk082,imk083,imk084,imk085, ",
               "                      imk086,imk087,imk088,imk089,imk09,imkplant,imklegal) ",
               "              VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,? ) "
   PREPARE ins_imk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert imk1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " UPDATE imk_file SET imk09 = ? ",
               "  WHERE imk01=? ",
               "    AND imk02=? ",
               "    AND imk03=? ",
               "    AND imk04=? ",
               "    AND imk05=? ",
               "    AND imk06=? "
   PREPARE upd_imk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update imk1:',STATUS,1)
      RETURN
   END IF
   #FUN-CB0037---end
   
   #FUN-CC0064--------add----str
   LET l_days = cl_days(yy,mm)
   LET l_date = MDY(mm,l_days,yy)
   LET l_date1 = l_date USING 'yyyymmdd'
   SELECT DISTINCT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00='ds_pos1'
   LET l_n = 0       
   SELECT COUNT(*) INTO l_n  FROM ryg_file
    WHERE ryg00 = l_posdb 
      AND ryg02 = l_posdb_link
      AND ryg01 = g_plant
   LET l_posdb=s_dbstring(l_posdb)
   LET l_posdb_link=p620_dblinks(l_posdb_link)
   IF l_n > 0 AND g_aza.aza88 = 'Y' THEN
      LET l_pos = 0
      LET l_sql = " SELECT COUNT(*)",
                  "   FROM ",l_posdb,"ta_DateEnd",l_posdb_link,
                  "  WHERE SHOP = '",g_plant,"'",
                  "    AND EDATE > = '",l_date1,"'"
      PREPARE p620_pos_pre FROM l_sql
      EXECUTE p620_pos_pre INTO l_pos
      IF l_pos = 0 THEN
         CALL cl_err('','art1099',1)
         RETURN
      END IF
   END IF
   #FUN-CC0064-------add---end
   LET g_success = 'Y'
   CALL cl_outnam('aimp620') RETURNING l_name
   START REPORT p620_rep TO l_name
   CALL s_azm(yy,mm)                     #得出期間的起始日與截止日
        RETURNING l_correct, g_bdate, g_edate
   IF l_correct != '0'  THEN 
      LET  g_success = 'N'
   END IF
   IF mm = 1
      THEN IF g_aza.aza02 = '1'
              THEN LET l_mm = 12
                   LET l_yy = yy - 1
              ELSE LET l_mm = 13
                   LET l_yy = yy - 1
           END IF
      ELSE
           LET l_mm = mm - 1     #TQC-B40151   #TQC-B50156
          #LET l_mm = mm         #TQC-B40151   #TQC-B50156
           LET l_yy = yy
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 3
   ELSE
       LET p_row = 12 LET p_col = 16
   END IF
 
   #CALL cl_ui_locale("aimp6201")   #TQC-B30034 mark
   #FUN-C40088---begin
   IF dc = 'Y' THEN 
      LET g_sql = " DELETE FROM imk_file ",
                 #" WHERE imk05 = ",l_yy,   #MOD-C80248 mark
                 #"   AND imk06 = ",l_mm,   #MOD-C80248 mark
                  " WHERE imk05 = ",yy,     #MOD-C80248
                  "   AND imk06 = ",mm,     #MOD-C80248
                  "   AND EXISTS (SELECT 1 FROM ima_file WHERE ima01 = imk01 AND ",g_wc CLIPPED," )"
      PREPARE del_imk FROM g_sql
      IF STATUS THEN
         CALL cl_err('delete imk:',STATUS,1)
         RETURN
      END IF
      EXECUTE del_imk
      IF SQLCA.sqlcode THEN
	     CALL cl_err('delete imk fail:',SQLCA.sqlcode,1)
         LET g_success = 'N'
	     RETURN
      END IF 
   END IF 
   #FUN-C40088---end
   #FUN-CB0037---begin mark
   #LET g_sql = "SELECT img01,img02,img03,img04,",
   #            "       imk081,imk082,imk083,imk084,imk085,imk086,imk09",
   #            "  FROM ima_file,img_file, OUTER imk_file",          #TQC-5C0050   #MOD-650067 add
   #            "  WHERE ima01 = img01 AND img_file.img01 = imk_file.imk01",
   #            "  AND   img_file.img02 = imk_file.imk02 AND img_file.img03 = imk_file.imk03 AND img_file.img04 = imk_file.imk04 ",
   #            "  AND   imk_file.imk05 =",l_yy,
   #            "  AND   imk_file.imk06 =",l_mm,
   #            "  AND ",g_wc CLIPPED,   
   #            " ORDER BY img01 "
   #FUN-CB0037---end
   #FUN-CB0037---begin
   LET g_sql =" SELECT imk01,imk02,imk03,imk04,",
              "       imk081,imk082,imk083,imk084,imk085,imk086,imk09",
              "  FROM imk_file,ima_file ",        
              "  WHERE imk01 = ima01 ",
              "  AND   imk05 =",l_yy,
              "  AND   imk06 =",l_mm,
              "  AND   imk09 != 0 ",
              "  AND ",g_wc CLIPPED,    
              " ORDER BY 1 "
   #FUN-CB0037---end
               
   PREPARE p620_p1 FROM g_sql
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('Prepare p620_p1 error !',SQLCA.SQLCODE,1)
        END IF
   DECLARE p620_c1 CURSOR WITH HOLD FOR p620_p1
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('Declare p620_c1 error !',SQLCA.SQLCODE,1)
        END IF
   CALL s_showmsg_init()    #No.FUN-710025
   FOREACH p620_c1 INTO g_imk.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach tlf_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          EXIT FOREACH
       END IF
       IF cl_null(g_imk.imk081) THEN LET g_imk.imk081 = 0 END IF
       IF cl_null(g_imk.imk082) THEN LET g_imk.imk082 = 0 END IF
       IF cl_null(g_imk.imk083) THEN LET g_imk.imk083 = 0 END IF
       IF cl_null(g_imk.imk084) THEN LET g_imk.imk084 = 0 END IF
       IF cl_null(g_imk.imk085) THEN LET g_imk.imk085 = 0 END IF
       IF cl_null(g_imk.imk086) THEN LET g_imk.imk086 = 0 END IF
       IF cl_null(g_imk.imk09)  THEN LET g_imk.imk09 =  0 END IF
       OUTPUT TO REPORT p620_rep(g_imk.*, 0, '', '','',0)
   END FOREACH
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_c1:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    #No.+062 010411 by plum
   END IF
   IF g_success = 'N' THEN
      RETURN     
   END IF 
 
   IF tlf0607_flag='1'
      THEN LET g_wc2=g_wc CLIPPED,   #MOD-650067 g_wc->g_wc2
               "  AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'"
      ELSE LET g_wc2=g_wc CLIPPED,   #MOD-650067 g_wc->g_wc2
               "  AND tlf07 BETWEEN '",g_bdate,"' AND '",g_edate,"'"
   END IF
   LET g_sql = "SELECT tlf01,tlf06,tlf07,tlf10,tlf12,",
               "       tlf02,tlf021,tlf022,tlf023,tlf026,",
               "       tlf03,tlf031,tlf032,tlf033,tlf036,tlf13 ",    #MOD-B60109 add tlf13
               "  FROM ima_file, tlf_file",
               "  WHERE tlf01 = ima01 ",
               "  AND tlf907 <> 0 ",
               "  AND ",g_wc2 CLIPPED,  #MOD-650067
               " ORDER BY tlf01,tlf06"
 
   IF sw = 'N' THEN
       LET l_sql = "SELECT COUNT(*)",
                   "  FROM ima_file, tlf_file",
                   "  WHERE tlf01 = ima01 ",
                   "  AND tlf907 <> 0 ",
                   "  AND ",g_wc2 CLIPPED    #MOD-650067
       PREPARE p620_swp2 FROM l_sql
       DECLARE p620_swc2 CURSOR WITH HOLD FOR p620_swp2
       FOREACH p620_swc2 INTO l_sw_tot
       END FOREACH
       LET l_count = 1
       IF l_sw_tot>0 THEN
           IF l_sw_tot > 10 THEN
               LET l_sw = l_sw_tot /10
               CALL cl_progress_bar(10)
           ELSE
               CALL cl_progress_bar(l_sw_tot)
           END IF
       END IF
   END IF
   PREPARE p620_p2 FROM g_sql
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg('','','Prepare p620_p2 error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'  
          IF sw = 'N' THEN
             CALL cl_close_progress_bar()
          END IF
          RETURN  #No.+062 010411 by plum
       END IF
   DECLARE p620_c2 CURSOR WITH HOLD FOR p620_p2
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg('','','Declare p620_c2 error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'  
          IF sw = 'N' THEN
             CALL cl_close_progress_bar()
          END IF
          RETURN  #No.+062 010411 by plum
       END IF
   FOREACH p620_c2 INTO q_tlf.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach tlf_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          IF sw = 'N' THEN
             CALL cl_close_progress_bar()
          END IF
          EXIT FOREACH
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       LET l_cnt1 = l_cnt1 + 1
 
       IF cl_null(q_tlf.tlf02) AND cl_null(q_tlf.tlf03) THEN
           IF sw = 'N' THEN
              IF l_sw_tot > 10 THEN  #筆數合計
                  IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                      CALL cl_progressing(" ")
                  END IF
                  IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才>
                      LET l_count = l_count+ 1
                      CALL cl_progressing(" ")
                  END IF
              ELSE
                  CALL cl_progressing(" ")
              END IF
           END IF
           CONTINUE FOREACH
       END IF
 
       IF cl_null(q_tlf.tlf12) THEN LET q_tlf.tlf12 = 1 END IF
       #-->出庫
       IF (q_tlf.tlf02 >= 50 AND q_tlf.tlf02 <= 59 ) 
                             AND (q_tlf.tlf02 != 57 ) THEN
          LET xxx=s_get_doc_no(q_tlf.tlf026)             #No.FUN-550082
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF
         #MOD-B60109---add---start---
          IF q_tlf.tlf03 = 18 AND q_tlf.tlf13='asfi511' THEN
             LET u_flag = '3'
          END IF
         #MOD-B60109---add---end--
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',1)
             IF sw = 'N' THEN
                 CALL cl_close_progress_bar()
             END IF
             CONTINUE FOREACH   #No.MOD-7B0017 add
          END IF
          OUTPUT TO REPORT p620_rep
                   ( q_tlf.tlf01,q_tlf.tlf021,q_tlf.tlf022,q_tlf.tlf023,
                     0, 0, 0, 0, 0, 0,  0,  q_tlf.tlf10*q_tlf.tlf12,
                     q_tlf.tlf02,q_tlf.tlf03,'O',u_flag)
       END IF
       #-->入庫
       IF (q_tlf.tlf03 >= 50 AND q_tlf.tlf03 <= 59 ) 
                             AND (q_tlf.tlf03 != 57 ) THEN
          LET xxx=s_get_doc_no(q_tlf.tlf036)             #No.FUN-550082
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',1)
             CONTINUE FOREACH   #No.MOD-7B0017 add
          END IF
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              MESSAGE xxx 
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF
          OUTPUT TO REPORT p620_rep
                    ( q_tlf.tlf01, q_tlf.tlf031, q_tlf.tlf032, q_tlf.tlf033,
                      0,  0,  0,  0,  0,  0,  0,  q_tlf.tlf10*q_tlf.tlf12,
                      q_tlf.tlf02, q_tlf.tlf03,'I',u_flag)
       END IF
      IF sw = 'N' THEN
          IF l_sw_tot > 10 THEN  #筆數合計
              IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                  CALL cl_progressing(" ")
              END IF
              IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才>
                  LET l_count = l_count+ 1
                  CALL cl_progressing(" ")
              END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
      END IF
       IF sw = 'Y' THEN
           MESSAGE q_tlf.tlf01
           CALL ui.Interface.refresh()
       END IF
   END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   IF STATUS OR SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_c2:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    
   END IF
   IF g_success = 'N' THEN RETURN  END IF 
   FINISH REPORT p620_rep
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
   #CLOSE WINDOW p620_ww   #TQC-B30034 mark
END FUNCTION
 
REPORT p620_rep(sr)
DEFINE sr    RECORD
             imk01    LIKE imk_file.imk01,   #料號
             imk02    LIKE imk_file.imk02,   #倉庫
             imk03    LIKE imk_file.imk03,   #儲位
             imk04    LIKE imk_file.imk04,   #批號
             imk081   LIKE imk_file.imk081,  #入
             imk082   LIKE imk_file.imk082,  #銷
             imk083   LIKE imk_file.imk083,  #領
             imk084   LIKE imk_file.imk084,  #轉
             imk085   LIKE imk_file.imk085,  #調
             imk086   LIKE imk_file.imk086,  #
             imk09    LIKE imk_file.imk09,   #期末數量
             tlf10    LIKE tlf_file.tlf10,   #異動數量
             tlf02    LIKE tlf_file.tlf02,   #來源
             tlf03    LIKE tlf_file.tlf03,   #目的
             code     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
             u_flag   LIKE type_file.num5    #No.FUN-690026 SMALLINT
        END  RECORD
DEFINE l_imk RECORD   LIKE imk_file.*
DEFINE l_imk081       LIKE imk_file.imk081
DEFINE l_imk082       LIKE imk_file.imk082
DEFINE l_imk083       LIKE imk_file.imk083
DEFINE l_imk084       LIKE imk_file.imk084
DEFINE l_imk085       LIKE imk_file.imk085
DEFINE l_imk086       LIKE imk_file.imk086
DEFINE l_imk09        LIKE imk_file.imk09 
DEFINE last_imk09     LIKE imk_file.imk09 
DEFINE l_temp         LIKE imk_file.imk09 
DEFINE l_year         LIKE imk_file.imk05 
DEFINE l_month        LIKE imk_file.imk06 
DEFINE l_imd20       LIKE imd_file.imd20    #MOD-B40126
DEFINE l_imk087       LIKE imk_file.imk087   #FUN-CB0037
DEFINE l_imk088       LIKE imk_file.imk088   #FUN-CB0037
DEFINE l_imk089       LIKE imk_file.imk089   #FUN-CB0037

  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line
  ORDER BY sr.imk01, sr.imk02, sr.imk03, sr.imk04
  FORMAT
    BEFORE GROUP OF sr.imk04
      #BEGIN WORK #MOD-A90101 mark
       LET g_success = 'Y'
       LET l_imk081 = 0
       LET l_imk082 = 0
       LET l_imk083 = 0
       LET l_imk084 = 0
       LET l_imk085 = 0
       LET l_imk086 = 0  
       LET l_imk09 = 0
       LET last_imk09  = 0
 
    ON EVERY ROW 
       IF sr.code = 'O' THEN LET sr.tlf10=sr.tlf10*-1 END IF
       CASE WHEN sr.u_flag=1 LET l_imk081=l_imk081+sr.tlf10
            WHEN sr.u_flag=2 LET l_imk082=l_imk082+sr.tlf10
            WHEN sr.u_flag=3 LET l_imk083=l_imk083+sr.tlf10
            WHEN sr.u_flag=4 LET l_imk084=l_imk084+sr.tlf10
            WHEN sr.u_flag=5 LET l_imk085=l_imk085+sr.tlf10
            OTHERWISE EXIT CASE
       END CASE
       LET l_imk09 = l_imk09 + sr.imk09
       PRINT 'every:',sr.imk01 CLIPPED, sr.imk02 CLIPPED, sr.imk03 CLIPPED, 
                      sr.imk04 CLIPPED
 
    AFTER GROUP OF sr.imk04 
       PRINT 'after:',sr.imk01 CLIPPED, sr.imk02 CLIPPED, sr.imk03 CLIPPED, 
                      sr.imk04 CLIPPED
       LET last_imk09  = l_imk09  + l_imk081 + l_imk082 + 
                         l_imk083 + l_imk084 + l_imk085
       #FUN-CB0037---begin mark                  
       #DELETE FROM imk_file WHERE imk01 = sr.imk01 
       #                     AND imk02 = sr.imk02 
       #                     AND imk03 = sr.imk03 
       #                     AND imk04 = sr.imk04 
       #                     AND imk05 = yy
       #                     AND imk06 = mm
       #FUN-CB0037---end
       EXECUTE del_imk1 USING sr.imk01,sr.imk02,sr.imk03,sr.imk04  #FUN-CB0037
       IF SQLCA.SQLCODE THEN
          LET g_showmsg = sr.imk01,"/",sr.imk02,"/",sr.imk03,"/",sr.imk04,"/",yy,mm
          CALL s_errmsg('imk01,imk02,imk03,imk04,imk05,imk06',g_showmsg,'Delete imk_file error !',SQLCA.sqlcode,1)  
          LET g_success = 'N'
       END IF
        SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=sr.imk02  #MOD-B40126
#FUN-CB0037---begin mark
#        IF cl_null(l_imd20) THEN LET l_imd20 = g_plant END IF   #FUN-CA0151
#        INSERT INTO imk_file(imk01,imk02,imk03,imk04,imk05,imk06,  #No.MOD-470041
#                            imk081,imk082,imk083,imk084,imk085,
#                            imk086,imk087,imk088,imk089,imk09,imkplant,imklegal) #No.FUN-980004
#            VALUES (sr.imk01,sr.imk02,sr.imk03,sr.imk04,yy,mm,l_imk081,l_imk082,
##                    l_imk083,l_imk084,l_imk085,l_imk086,0,0,0,last_imk09,g_plant,g_legal) #No.FUN-980004  #MOD-B40126
#                    l_imk083,l_imk084,l_imk085,l_imk086,0,0,0,last_imk09,l_imd20,g_legal)  #MOD-B40126
#FUN-CB0037---end
       #FUN-CB0037---begin
       LET l_imk087 = 0
       LET l_imk088 = 0
       LET l_imk089 = 0
       EXECUTE ins_imk1 USING  sr.imk01,sr.imk02,sr.imk03,sr.imk04,yy,mm,l_imk081,l_imk082,  
                               l_imk083,l_imk084,l_imk085,l_imk086,l_imk087,l_imk088,l_imk089,last_imk09,l_imd20,g_legal  
       #FUN-CB0037---end
       IF SQLCA.SQLCODE THEN     
          CALL s_errmsg('','','Insert imk_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       #ELSE  #FUN-CB0037
        #DISPLAY sr.imk01 TO FORMONLY.imk01  #FUN-CB0037
        #DISPLAY sr.imk02 TO FORMONLY.imk02  #FUN-CB0037
       END IF                 
       IF next_compute = 'Y' THEN
          #FUN-CB0037---begin mark
          #DECLARE p620_next_imk CURSOR FOR
          # SELECT imk_file.* FROM imk_file
          #  WHERE imk01 = sr.imk01
          #    AND   imk02 = sr.imk02
          #    AND   imk03 = sr.imk03
          #    AND   imk04 = sr.imk04
          #    AND   (imk05 > yy OR
          #          (imk05 = yy AND imk06 > mm))
          #FOREACH p620_next_imk INTO l_imk.*
          #FUN-CB0037---end
          FOREACH p620_next_imk USING sr.imk01,sr.imk02,sr.imk03,sr.imk04 INTO l_imk.*  #FUN-CB0037
              IF g_success='N' THEN                                                                                                        
               LET g_totsuccess='N'                                                                                                      
               LET g_success="Y"                                                                                                         
              END IF                                                                                                                       
 
             IF SQLCA.SQLCODE THEN 
                CALL s_errmsg('','','foreach p620_next_imk error!',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH 
             END IF
             IF cl_null(l_imk.imk081) THEN LET l_imk.imk081 = 0 END IF
             IF cl_null(l_imk.imk082) THEN LET l_imk.imk082 = 0 END IF
             IF cl_null(l_imk.imk083) THEN LET l_imk.imk083 = 0 END IF
             IF cl_null(l_imk.imk084) THEN LET l_imk.imk084 = 0 END IF
             IF cl_null(l_imk.imk085) THEN LET l_imk.imk085 = 0 END IF
             IF cl_null(l_imk.imk086) THEN LET l_imk.imk086 = 0 END IF
             IF cl_null(l_imk.imk09)  THEN LET l_imk.imk09 =  0 END IF
             LET l_temp = last_imk09 + l_imk.imk081 + l_imk.imk082
                           + l_imk.imk083 + l_imk.imk084 + l_imk.imk085
             #FUN-CB0037---begin mark
             #UPDATE imk_file SET imk09 = l_temp
             # WHERE imk01=l_imk.imk01
             #   AND imk02=l_imk.imk02
             #   AND imk03=l_imk.imk03
             #   AND imk04=l_imk.imk04
             #   AND imk05=l_imk.imk05
             #   AND imk06=l_imk.imk06 
             #FUN-CB0037---end
             EXECUTE upd_imk1 USING l_temp,l_imk.imk01,l_imk.imk02,l_imk.imk03,l_imk.imk04,l_imk.imk05,l_imk.imk06  #FUN-CB0037    
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] != 1 THEN
                CALL s_errmsg('',' ','Update imk_file error !',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             LET last_imk09=l_temp    #No:9900
          END FOREACH
           IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
           END IF                                                                                                                           
 
       END IF
          #MOD-A90101 mark --start--
          #IF g_success = 'Y'
          #   THEN COMMIT WORK    
          #   ELSE ROLLBACK WORK  
          #END IF
          #MOD-A90101 mark --end--
END REPORT 
 
FUNCTION p620_imkk()
   DEFINE l_yy,l_mm   LIKE type_file.num10   #No.FUN-690026 INTEGER
   DEFINE l_bdate     LIKE type_file.dat     #No.FUN-690026 DATE
   DEFINE l_edate     LIKE type_file.dat     #No.FUN-690026 DATE
   DEFINE l_correct   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(80)
   DEFINE l_name      LIKE type_file.chr20   #No.FUN-690026 VARCHAR(20)
   DEFINE l_ima906    LIKE ima_file.ima906
   DEFINE l_ima907    LIKE ima_file.ima907

   IF cl_null(g_wc1) THEN LET g_wc1 = " 1=1 " END IF #MOD-D60247
   #FUN-CB0037---begin
   LET g_sql = " SELECT imkk_file.* FROM imkk_file ",
               "  WHERE imkk01 = ? ",
               "    AND imkk02 = ? ",
               "    AND imkk03 = ? ",
               "    AND imkk04 = ? ",
               "    AND imkk10 = ? ",
               "    AND   (imkk05 > ",yy,
               "     OR   (imkk05 = ",yy," AND imkk06 > ",mm," ))",
               "  ORDER BY imkk05,imkk06 "
   DECLARE p620_next_imkk CURSOR FROM g_sql

   LET g_sql = "  DELETE FROM imkk_file ",
               "        WHERE imkk01 = ? ", 
               "          AND imkk02 = ? ",
               "          AND imkk03 = ? ", 
               "          AND imkk04 = ? ", 
               "          AND imkk05 = ",yy,    
               "          AND imkk06 = ",mm,
               "          AND imkk10 = ? "
   PREPARE del_imkk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('delete imkk1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " INSERT INTO imkk_file(imkk01,imkk02,imkk03,imkk04,imkk05,imkk06,  ",
               "                       imkk081,imkk082,imkk083,imkk084,imkk085, ",
               "                       imkk086,imkk087,imkk088,imkk089,imkk09,imkk10,imkkplant,imkklegal) ",
               "              VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,? ) "
   PREPARE ins_imkk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert imkk1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " UPDATE imkk_file SET imkk09 = ? ",
               "  WHERE imkk01=? ",
               "    AND imkk02=? ",
               "    AND imkk03=? ",
               "    AND imkk04=? ",
               "    AND imkk05=? ",
               "    AND imkk06=? ",
               "    AND imkk10=? "
   PREPARE upd_imkk1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update imkk1:',STATUS,1)
      RETURN
   END IF
   #FUN-CB0037---end
 
   LET g_success = 'Y'
   CALL cl_outnam('aimp620') RETURNING l_name
   START REPORT p620_imkk_rep TO l_name
   CALL s_azm(yy,mm)                     #得出期間的起始日與截止日
        RETURNING l_correct, g_bdate, g_edate
   IF l_correct != '0'  THEN 
      LET  g_success = 'N'
   END IF
   IF mm = 1
      THEN IF g_aza.aza02 = '1'
              THEN LET l_mm = 12
                   LET l_yy = yy - 1
              ELSE LET l_mm = 13
                   LET l_yy = yy - 1
           END IF
      ELSE LET l_mm = mm - 1
           LET l_yy = yy
   END IF

   #FUN-CB0037---begin
   IF dc = 'Y' THEN 
      LET g_sql = " DELETE FROM imkk_file ",
                  " WHERE imkk05 = ",yy,    
                  "   AND imkk06 = ",mm,    
                  "   AND EXISTS (SELECT 1 FROM ima_file WHERE ima01 = imkk01 AND ",g_wc CLIPPED," )"
      PREPARE del_imkk FROM g_sql
      IF STATUS THEN
         CALL cl_err('delete imkk:',STATUS,1)
         RETURN
      END IF
      EXECUTE del_imkk
      IF SQLCA.sqlcode THEN
	     CALL cl_err('delete imkk fail:',SQLCA.sqlcode,1)
         LET g_success = 'N'
	     RETURN
      END IF 
   END IF 
   #FUN-CB0037---end
   #FUN-CB0037---begin mark
   #LET g_sql = "SELECT imgg01,imgg02,imgg03,imgg04,imgg09,",
   #            "       imkk081,imkk082,imkk083,imkk084,imkk085,imkk086,imkk09",
   #            "  FROM ima_file,imgg_file, OUTER imkk_file",
   #            "  WHERE ima01 = imgg01 AND imgg_file.imgg01 = imkk_file.imkk01",
   #            "    AND imgg_file.imgg02 = imkk_file.imkk02 ",
   #            "    AND imgg_file.imgg03 = imkk_file.imkk03 ",
   #            "    AND imgg_file.imgg04 = imkk_file.imkk04 ",
   #            "    AND imgg_file.imgg09 = imkk_file.imkk10 ",
   #            "    AND imkk_file.imkk05 =",l_yy,
   #            "    AND imkk_file.imkk06 =",l_mm,
   #            "    AND ",g_wc1 CLIPPED,
   #            " ORDER BY imgg01 "
   #FUN-CB0037---end            
   #FUN-CB0037---begin
   LET g_sql = " SELECT imkk01,imkk02,imkk03,imkk04,imkk10,",
               "       imkk081,imkk082,imkk083,imkk084,imkk085,imkk086,imkk09",
               "  FROM imkk_file,ima_file ",        
               "  WHERE imkk01 = ima01 ",  
               "  AND   imkk05 =",l_yy,
               "  AND   imkk06 =",l_mm,
               "  AND   imkk09 != 0 ",
               "  AND ",g_wc1 CLIPPED,    
               " ORDER BY 1 "
   #FUN-CB0037---end            
   PREPARE p620_imkk_p1 FROM g_sql
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('Prepare p620_imkk_p1 error !',SQLCA.SQLCODE,1)
        END IF
   DECLARE p620_imkk_c1 CURSOR WITH HOLD FOR p620_imkk_p1
        IF SQLCA.SQLCODE THEN 
           CALL cl_err('Declare p620_imkk_c1 error !',SQLCA.SQLCODE,1)
        END IF
   FOREACH p620_imkk_c1 INTO g_imkk.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach tlff_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          EXIT FOREACH
       END IF
       IF cl_null(g_imkk.imkk081) THEN LET g_imkk.imkk081 = 0 END IF
       IF cl_null(g_imkk.imkk082) THEN LET g_imkk.imkk082 = 0 END IF
       IF cl_null(g_imkk.imkk083) THEN LET g_imkk.imkk083 = 0 END IF
       IF cl_null(g_imkk.imkk084) THEN LET g_imkk.imkk084 = 0 END IF
       IF cl_null(g_imkk.imkk085) THEN LET g_imkk.imkk085 = 0 END IF
       IF cl_null(g_imkk.imkk086) THEN LET g_imkk.imkk086 = 0 END IF
       IF cl_null(g_imkk.imkk09)  THEN LET g_imkk.imkk09 =  0 END IF
       OUTPUT TO REPORT p620_imkk_rep(g_imkk.*, 0, '', '','',0)
   END FOREACH
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_imkk_c1:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    #No.+062 010411 by plum
   END IF
   IF g_success = 'N' THEN
      RETURN     
   END IF 
 
   IF tlf0607_flag='1'
      THEN LET g_wc1=g_wc1 CLIPPED,
               "  AND tlff06 BETWEEN '",g_bdate,"' AND '",g_edate,"'"
      ELSE LET g_wc1=g_wc1 CLIPPED,
               "  AND tlff07 BETWEEN '",g_bdate,"' AND '",g_edate,"'"
   END IF
   LET g_sql = "SELECT tlff01,tlff06,tlff07,tlff10,tlff11,tlff12,",
               "       tlff02,tlff021,tlff022,tlff023,tlff026,",
               "       tlff03,tlff031,tlff032,tlff033,tlff036,tlff13 ",   #MOD-B60109 add tlff13
               "  FROM ima_file, tlff_file",
               "  WHERE tlff01 = ima01 ",
               "  AND tlff907 <> 0 ",
               "  AND ima906 <> '1' ",
               "  AND ",g_wc1 CLIPPED,
               " ORDER BY tlff01,tlff06"
   PREPARE p620_imkk_p2 FROM g_sql
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg('','','Prepare p620_imkk_p2 error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'  RETURN  #No.+062 010411 by plum
       END IF
   DECLARE p620_imkk_c2 CURSOR WITH HOLD FOR p620_imkk_p2
       IF SQLCA.SQLCODE THEN 
          CALL s_errmsg('','','Declare p620_imkk_c2 error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'  RETURN  #No.+062 010411 by plum
       END IF
   FOREACH p620_imkk_c2 INTO q_tlff.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach tlff_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          EXIT FOREACH
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       LET l_ima906 = NULL
       LET l_ima907 = NULL
       SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
        WHERE ima01=q_tlff.tlff01
       IF l_ima906 = '3' THEN
          IF l_ima907 <> q_tlff.tlff11 THEN
             CONTINUE FOREACH
          END IF
       END IF
       IF cl_null(q_tlff.tlff02) AND cl_null(q_tlff.tlff03) THEN
          CONTINUE FOREACH
       END IF
 
       IF cl_null(q_tlff.tlff12) THEN LET q_tlff.tlff12 = 1 END IF
       #-->出庫
       IF (q_tlff.tlff02 >= 50 AND q_tlff.tlff02 <= 59 ) 
                             AND (q_tlff.tlff02 != 57 ) THEN
          LET xxx=s_get_doc_no(q_tlff.tlff026)             #No.FUN-550082
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF
         #MOD-B60109---add---start---
          IF q_tlf.tlf03 = 18 AND q_tlf.tlf13='asfi511' THEN
             LET u_flag = '3'
          END IF
         #MOD-B60109---add---end--
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH   #No.MOD-7B0017 add
          END IF
          OUTPUT TO REPORT p620_imkk_rep
                   ( q_tlff.tlff01,q_tlff.tlff021,q_tlff.tlff022,q_tlff.tlff023,
                     q_tlff.tlff11,0, 0, 0, 0, 0, 0,  0,  q_tlff.tlff10,
                     q_tlff.tlff02,q_tlff.tlff03,'O',u_flag)
       END IF
       #-->入庫
       IF (q_tlff.tlff03 >= 50 AND q_tlff.tlff03 <= 59 ) 
                             AND (q_tlff.tlff03 != 57 ) THEN
          LET xxx=s_get_doc_no(q_tlff.tlff036)             #No.FUN-550082
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH   #No.MOD-7B0017 add
          END IF
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF
          OUTPUT TO REPORT p620_imkk_rep
                    ( q_tlff.tlff01, q_tlff.tlff031, q_tlff.tlff032, q_tlff.tlff033,
                      q_tlff.tlff11,0,  0,  0,  0,  0,  0,  0,  q_tlff.tlff10,
                      q_tlff.tlff02, q_tlff.tlff03,'I',u_flag)
       END IF
   END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   IF STATUS OR SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_imkk_c2:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    
   END IF
   IF g_success = 'N' THEN RETURN  END IF 
   FINISH REPORT p620_imkk_rep
    IF os.Path.chrwx("aimp620.out" ,511) THEN END IF   #No.FUN-9C0009
   CLOSE WINDOW p620_imkk_ww
END FUNCTION
 
REPORT p620_imkk_rep(sr)
DEFINE sr    RECORD
             imkk01    LIKE imkk_file.imkk01,   #料號
             imkk02    LIKE imkk_file.imkk02,   #倉庫
             imkk03    LIKE imkk_file.imkk03,   #儲位
             imkk04    LIKE imkk_file.imkk04,   #批號
             imkk10    LIKE imkk_file.imkk10,
             imkk081   LIKE imkk_file.imkk081,  #入
             imkk082   LIKE imkk_file.imkk082,  #銷
             imkk083   LIKE imkk_file.imkk083,  #領
             imkk084   LIKE imkk_file.imkk084,  #轉
             imkk085   LIKE imkk_file.imkk085,  #調
             imkk086   LIKE imkk_file.imkk086,  #
             imkk09    LIKE imkk_file.imkk09,   #期末數量
             tlff10    LIKE tlff_file.tlff10,   #異動數量
             tlff02    LIKE tlff_file.tlff02,   #來源
             tlff03    LIKE tlff_file.tlff03,   #目的
             code      LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
             u_flag    LIKE type_file.num5      #No.FUN-690026 SMALLINT
        END  RECORD
DEFINE l_imkk RECORD   LIKE imkk_file.*
DEFINE l_imkk081       LIKE imkk_file.imkk081
DEFINE l_imkk082       LIKE imkk_file.imkk082
DEFINE l_imkk083       LIKE imkk_file.imkk083
DEFINE l_imkk084       LIKE imkk_file.imkk084
DEFINE l_imkk085       LIKE imkk_file.imkk085
DEFINE l_imkk086       LIKE imkk_file.imkk086
DEFINE l_imkk09        LIKE imkk_file.imkk09 
DEFINE last_imkk09     LIKE imkk_file.imkk09 
DEFINE l_temp          LIKE imkk_file.imkk09 
DEFINE l_year          LIKE imkk_file.imkk05 
DEFINE l_month         LIKE imkk_file.imkk06 
DEFINE l_imd20        LIKE imd_file.imd20   #MOD-B40126 
DEFINE l_imkk087       LIKE imkk_file.imkk087  #FUN-CB0037
DEFINE l_imkk088       LIKE imkk_file.imkk088  #FUN-CB0037
DEFINE l_imkk089       LIKE imkk_file.imkk089  #FUN-CB0037

  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH g_page_line
  ORDER BY sr.imkk01, sr.imkk02, sr.imkk03, sr.imkk04, sr.imkk10
  FORMAT
    BEFORE GROUP OF sr.imkk10
      #BEGIN WORK #MOD-A90101 mark
       LET g_success = 'Y'
       LET l_imkk081 = 0
       LET l_imkk082 = 0
       LET l_imkk083 = 0
       LET l_imkk084 = 0
       LET l_imkk085 = 0
       LET l_imkk086 = 0  
       LET l_imkk09 = 0
       LET last_imkk09  = 0
 
    ON EVERY ROW 
       IF sr.code = 'O' THEN LET sr.tlff10=sr.tlff10*-1 END IF
       CASE WHEN sr.u_flag=1 LET l_imkk081=l_imkk081+sr.tlff10
            WHEN sr.u_flag=2 LET l_imkk082=l_imkk082+sr.tlff10
            WHEN sr.u_flag=3 LET l_imkk083=l_imkk083+sr.tlff10
            WHEN sr.u_flag=4 LET l_imkk084=l_imkk084+sr.tlff10
            WHEN sr.u_flag=5 LET l_imkk085=l_imkk085+sr.tlff10
            OTHERWISE EXIT CASE
       END CASE
       LET l_imkk09 = l_imkk09 + sr.imkk09
       PRINT 'every:',sr.imkk01 CLIPPED, sr.imkk02 CLIPPED, sr.imkk03 CLIPPED, 
                      sr.imkk04 CLIPPED, sr.imkk10 CLIPPED
 
    AFTER GROUP OF sr.imkk10
       PRINT 'after:',sr.imkk01 CLIPPED, sr.imkk02 CLIPPED, sr.imkk03 CLIPPED, 
                      sr.imkk04 CLIPPED, sr.imkk10 CLIPPED
       LET last_imkk09  = l_imkk09  + l_imkk081 + l_imkk082 + 
                         l_imkk083 + l_imkk084 + l_imkk085
       #FUN-CB0037---begin mark                  
       #DELETE FROM imkk_file WHERE imkk01 = sr.imkk01 
       #                     AND imkk02 = sr.imkk02 
       #                     AND imkk03 = sr.imkk03 
       #                     AND imkk04 = sr.imkk04 
       #                     AND imkk05 = yy
       #                     AND imkk06 = mm
       #                     AND imkk10 = sr.imkk10
       #FUN-CB0037---end
       EXECUTE del_imkk1 USING sr.imkk01,sr.imkk02,sr.imkk03,sr.imkk04,sr.imkk10  #FUN-CB0037
       IF SQLCA.SQLCODE THEN
          LET g_showmsg = sr.imkk01,"/",sr.imkk02,"/",sr.imkk03,"/",sr.imkk04,"/",yy,"/",mm,"/",sr.imkk10
          CALL s_errmsg('imkk01,imkk02,imkk03,imkk04,imkk05,imkk06,imkk10',g_showmsg,
                                          'Delete imkk_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       END IF
        SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=sr.imkk02 #MOD-B40126
#FUN-CB0037---begin mark
#        IF cl_null(l_imd20) THEN LET l_imd20 = g_plant END IF   #FUN-CA0151
#        INSERT INTO imkk_file(imkk01,imkk02,imkk03,imkk04,imkk05,imkk06,  #No.MOD-470041
#                            imkk081,imkk082,imkk083,imkk084,imkk085,
#                            imkk086,imkk087,imkk088,imkk089,imkk09,imkk10,imkkplant,imkklegal) #No.FUN-980004
#            VALUES (sr.imkk01,sr.imkk02,sr.imkk03,sr.imkk04,yy,mm,l_imkk081,l_imkk082,
##                    l_imkk083,l_imkk084,l_imkk085,l_imkk086,0,0,0,last_imkk09,sr.imkk10,g_plant,g_legal)  #No.FUN-980004
#                    l_imkk083,l_imkk084,l_imkk085,l_imkk086,0,0,0,last_imkk09,sr.imkk10,l_imd20,g_legal)  #MOD-B40126 
#FUN-CB0037---end
       #FUN-CB0037---begin
       LET l_imkk087 = 0
       LET l_imkk088 = 0
       LET l_imkk089 = 0
       EXECUTE ins_imkk1 USING sr.imkk01,sr.imkk02,sr.imkk03,sr.imkk04,yy,mm,l_imkk081,l_imkk082,
                               l_imkk083,l_imkk084,l_imkk085,l_imkk086,l_imkk087,l_imkk088,l_imkk089,last_imkk09,sr.imkk10,l_imd20,g_legal
       #FUN-CB0037---end
       IF SQLCA.SQLCODE THEN     
          CALL s_errmsg('','','Insert imkk_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       #ELSE  #FUN-CB0037
        #DISPLAY sr.imkk01 TO FORMONLY.imkk01  #FUN-CB0037
        #DISPLAY sr.imkk02 TO FORMONLY.imkk02  #FUN-CB0037
       END IF                 
#---------------------- UPDATE next imkk_file -------------------------------
       IF next_compute = 'Y' THEN
          #FUN-CB0037---begin
          #DECLARE p620_next_imkk CURSOR FOR
          # SELECT imkk_file.* FROM imkk_file
          #  WHERE imkk01 = sr.imkk01
          #    AND   imkk02 = sr.imkk02
          #    AND   imkk03 = sr.imkk03
          #    AND   imkk04 = sr.imkk04
          #    AND   imkk10 = sr.imkk10
          #    AND   (imkk05 > yy OR
          #          (imkk05 = yy AND imkk06 > mm))
          #  ORDER BY imkk05,imkk06
          #FOREACH p620_next_imkk INTO l_imkk.*
          #FUN-CB0037---end
          FOREACH p620_next_imkk USING sr.imkk01,sr.imkk02,sr.imkk03,sr.imkk04,sr.imkk10 INTO l_imkk.*  #FUN-CB0037
          IF g_success='N' THEN                                                                                                        
             LET g_totsuccess='N'                                                                                                      
             LET g_success="Y"                                                                                                         
          END IF                                                                                                                       
 
             IF SQLCA.SQLCODE THEN 
                CALL s_errmsg('','','foreach p620_next_imkk error!',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH 
             END IF
             IF cl_null(l_imkk.imkk081) THEN LET l_imkk.imkk081 = 0 END IF
             IF cl_null(l_imkk.imkk082) THEN LET l_imkk.imkk082 = 0 END IF
             IF cl_null(l_imkk.imkk083) THEN LET l_imkk.imkk083 = 0 END IF
             IF cl_null(l_imkk.imkk084) THEN LET l_imkk.imkk084 = 0 END IF
             IF cl_null(l_imkk.imkk085) THEN LET l_imkk.imkk085 = 0 END IF
             IF cl_null(l_imkk.imkk086) THEN LET l_imkk.imkk086 = 0 END IF
             IF cl_null(l_imkk.imkk09)  THEN LET l_imkk.imkk09 =  0 END IF
             LET l_temp = last_imkk09 + l_imkk.imkk081 + l_imkk.imkk082
                           + l_imkk.imkk083 + l_imkk.imkk084 + l_imkk.imkk085
             #FUN-CB0037---begin mark
             #UPDATE imkk_file SET imkk09 = l_temp
             # WHERE imkk01=l_imkk.imkk01
             #   AND imkk02=l_imkk.imkk02
             #  #AND imk03=l_imkk.imkk03
             #   AND imkk03=l_imkk.imkk03  #MOD-B80024 mod
             #   AND imkk04=l_imkk.imkk04
             #   AND imkk05=l_imkk.imkk05
             #   AND imkk06=l_imkk.imkk06     
             #   AND imkk10=l_imkk.imkk10  #MOD-B80024 add
             #FUN-CB0037---end
             EXECUTE upd_imkk1 USING l_temp,l_imkk.imkk01,l_imkk.imkk02,l_imkk.imkk03,l_imkk.imkk04,l_imkk.imkk05,l_imkk.imkk06,l_imkk.imkk10  #FUN-CB0037
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] != 1 THEN
                CALL s_errmsg('',' ','Update imkk_file error !',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             LET last_imkk09=l_temp    #No:9900
          END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
       END IF
#---------------------- UPDATE next imkk_file finish ----------------------
          #MOD-A90101 mark --start--
          #IF g_success = 'Y'
          #   THEN COMMIT WORK    
          #   ELSE ROLLBACK WORK  
          #END IF
          #MOD-A90101 mark --end--
END REPORT 
 
FUNCTION p620_imks()
   DEFINE l_yy,l_mm   LIKE type_file.num10  
   DEFINE l_bdate     LIKE type_file.dat    
   DEFINE l_edate     LIKE type_file.dat    
   DEFINE l_correct   LIKE type_file.chr1   
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_name      LIKE type_file.chr20  

   #FUN-CB0037---begin
   LET g_sql = " SELECT imks_file.* FROM imks_file ",
               "  WHERE imks01 = ? ",
               "    AND imks02 = ? ",
               "    AND imks03 = ? ",
               "    AND imks04 = ? ",
               "    AND imks10 = ? ",
               "    AND imks11 = ? ",
               "    AND   (imks05 > ",yy,
               "     OR   (imks05 = ",yy," AND imks06 > ",mm," ))",
               "  ORDER BY imks05,imks06 "
   DECLARE p620_next_imks CURSOR FROM g_sql

   LET g_sql = " DELETE FROM imks_file ",
               "       WHERE imks01 = ? ", 
               "         AND imks02 = ? ",
               "         AND imks03 = ? ", 
               "         AND imks04 = ? ", 
               "         AND imks10 = ? ",
               "         AND imks11 = ? ",
               "         AND imks05 = ",yy,    
               "         AND imks06 = ",mm
   PREPARE del_imks1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('delete imks1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " INSERT INTO imks_file(imks01,imks02,imks03,imks04,imks05,imks06, ",
               "                      imks081,imks082,imks083,imks084,imks085, ",
               "                      imks086,imks087,imks088,imks089,imks09,imks10,imks11,imks12,imksplant,imkslegal) ",
               "              VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ? ) "
   PREPARE ins_imks1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert imks1:',STATUS,1)
      RETURN
   END IF
   
   LET g_sql = " UPDATE imks_file SET imks09 = ? ",
               "  WHERE imks01=? ",
               "    AND imks02=? ",
               "    AND imks03=? ",
               "    AND imks04=? ",
               "    AND imks05=? ",
               "    AND imks06=? ",
               "    AND imks10=? ",
               "    AND imks11=? ",
               "    AND imks12=? "
   PREPARE upd_imks1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update imks1:',STATUS,1)
      RETURN
   END IF
   #FUN-CB0037---end
 
   LET g_success = 'Y'
 
   CALL cl_outnam('aimp620') RETURNING l_name
 
   START REPORT p620_imks_rep TO l_name
 
   CALL s_azm(yy,mm) RETURNING l_correct,g_bdate,g_edate
 
   IF l_correct != '0'  THEN 
      LET  g_success = 'N'
   END IF
 
   IF mm = 1 THEN 
      IF g_aza.aza02 = '1' THEN 
         LET l_mm = 12
         LET l_yy = yy - 1
      ELSE
         LET l_mm = 13
         LET l_yy = yy - 1
      END IF
   ELSE
      LET l_mm = mm - 1
      LET l_yy = yy
   END IF

   #FUN-CB0037---begin
   IF dc = 'Y' THEN 
      LET g_sql = " DELETE FROM imks_file ",
                  " WHERE imks05 = ",yy,    
                  "   AND imks06 = ",mm,    
                  "   AND EXISTS (SELECT 1 FROM ima_file WHERE ima01 = imks01 AND ",g_wc CLIPPED," )"
      PREPARE del_imks FROM g_sql
      IF STATUS THEN
         CALL cl_err('delete imks:',STATUS,1)
         RETURN
      END IF
      EXECUTE del_imks
      IF SQLCA.sqlcode THEN
	     CALL cl_err('delete imks fail:',SQLCA.sqlcode,1)
         LET g_success = 'N'
	     RETURN
      END IF 
   END IF 
   #FUN-CB0037---end
#FUN-CB0037---begin mark
#   LET g_sql = "SELECT imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,imgs11,",
#               "       imks081,imks082,imks083,imks084,imks085,imks086,imks09",
##              "  FROM ima_file,imgs_file, OUTER imks_file",          #TQC-A60046
#               "  FROM ima_file,imgs_file LEFT OUTER JOIN imks_file ON",#TQC-A60046
#               "        imgs01 = imks01 ",     #TQC-A60046   
#               "    AND imgs02 = imks02 ",     #TQC-A60046
#               "    AND imgs03 = imks03 ",     #TQC-A60046
#               "    AND imgs04 = imks04 ",     #TQC-A60046
#               "    AND imgs05 = imks10 ",     #TQC-A60046
#               "    AND imgs06 = imks11 ",     #TQC-A60046
#              #"    AND imgs06 = ",l_yy,       #TQC-A60046       #TQC-AB0076 mark  
#              #"    AND imgs06 = ",l_mm,       #TQC-A60046       #TQC-AB0076 mark   
#               "    AND imks_file.imks05 = ",l_yy,               #TQC-AB0076 add
#               "    AND imks_file.imks06 = ",l_mm,               #TQC-AB0076 add
#               "  WHERE ima01 = imgs01 ",      #TQC-A60046 
##TQC-A60046 --Begin
##              "  WHERE ima01 = imgs01 AND imgs01 = imks_file.imks01",
##              "    AND imgs02 = imks_file.imks02 ",
##              "    AND imgs03 = imks_file.imks03 ",
##              "    AND imgs04 = imks_file.imks04 ",
##              "    AND imgs05 = imks_file.imks10 ",
##              "    AND imgs06 = imks_file.imks11 ",
##              "    AND imks_file.imks05 =",l_yy,
##              "    AND imks_file.imks06 =",l_mm,
##TQC-A60046 --End
#               "    AND ",g_wc CLIPPED,     #TQC-920113 add
#               " ORDER BY imgs01 "
#FUN-CB0037---end
   #FUN-CB0037---begin
   LET g_sql =  
               " SELECT imks01,imks02,imks03,imks04,imks10,imks11,imks12,",
               "       imks081,imks082,imks083,imks084,imks085,imks086,imks09",
               "  FROM imks_file,ima_file ",        
               "  WHERE imks01 = ima01 ",  
               "  AND   imks05 =",l_yy,
               "  AND   imks06 =",l_mm,
               "  AND   imks09 != 0 ",
               "  AND ",g_wc CLIPPED,    
               " ORDER BY 1 "
   #FUN-CB0037---end
 
   PREPARE p620_imks_p1 FROM g_sql
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('Prepare p620_imks_p1 error !',SQLCA.SQLCODE,1)
   END IF
 
   DECLARE p620_imks_c1 CURSOR WITH HOLD FOR p620_imks_p1
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('Declare p620_imks_c1 error !',SQLCA.SQLCODE,1)
   END IF
 
   FOREACH p620_imks_c1 INTO g_imks.*
      IF STATUS THEN
         CALL s_errmsg('','','Foreach tlfs_file error !',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
 
      IF cl_null(g_imks.imks081) THEN LET g_imks.imks081 = 0 END IF
      IF cl_null(g_imks.imks082) THEN LET g_imks.imks082 = 0 END IF
      IF cl_null(g_imks.imks083) THEN LET g_imks.imks083 = 0 END IF
      IF cl_null(g_imks.imks084) THEN LET g_imks.imks084 = 0 END IF
      IF cl_null(g_imks.imks085) THEN LET g_imks.imks085 = 0 END IF
      IF cl_null(g_imks.imks086) THEN LET g_imks.imks086 = 0 END IF
      IF cl_null(g_imks.imks09)  THEN LET g_imks.imks09 =  0 END IF
 
      OUTPUT TO REPORT p620_imks_rep(g_imks.*,0,'',0)
 
   END FOREACH
 
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_imks_c1:',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
   END IF
 
   IF g_success = 'N' THEN
      RETURN     
   END IF 
 
   IF tlf0607_flag='1' THEN
      LET g_wc1=g_wc CLIPPED,    #No.TQC-940049 add
                "  AND tlfs111 BETWEEN '",g_bdate,"' AND '",g_edate,"'"  #MOD-920317 add
   ELSE
     #LET g_wc1=g_wc1 CLIPPED,   #No.TQC-940049 mark
      LET g_wc1=g_wc CLIPPED,    #No.TQC-940049 add
                "  AND tlfs12 BETWEEN '",g_bdate,"' AND '",g_edate,"'"   #MOD-920317 add
   END IF
 
   LET g_sql = "SELECT tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,",  #No.MOD-860051
               "       tlfs09,tlfs10,tlfs13,tlfs15",  #TQC-920085 add tlfs10
               "  FROM ima_file, tlfs_file",
               "  WHERE tlfs01 = ima01 ",
               "  AND tlfs09 <> 0 ",   #No.MOD-860051
               "  AND ",g_wc1 CLIPPED, #MOD-920317 add 
               " ORDER BY tlfs01"
 
   PREPARE p620_imks_p2 FROM g_sql
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','Prepare p620_imks_p2 error !',SQLCA.SQLCODE,1)
      LET g_success = 'N'  RETURN  
   END IF
 
   DECLARE p620_imks_c2 CURSOR WITH HOLD FOR p620_imks_p2
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','Declare p620_imks_c2 error !',SQLCA.SQLCODE,1)
      LET g_success = 'N'  RETURN 
   END IF
 
   FOREACH p620_imks_c2 INTO q_tlfs.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach tlfs_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          EXIT FOREACH
       END IF
 
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       #-->出庫
       IF q_tlfs.tlfs09 = -1 THEN 
          LET xxx=s_get_doc_no(q_tlfs.tlfs10)  #TQC-920085
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF STATUS THEN 
             IF g_bgjob = 'N' THEN
                MESSAGE xxx
             END IF
             CALL ui.Interface.refresh()
             LET u_flag=5 
          END IF
 
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH 
          END IF
 
          OUTPUT TO REPORT p620_imks_rep (q_tlfs.tlfs01,q_tlfs.tlfs02,
                                          q_tlfs.tlfs03,q_tlfs.tlfs04,
                                          q_tlfs.tlfs05,q_tlfs.tlfs06,
                                          q_tlfs.tlfs15,0,0,0,0,0,0,0,
                                          q_tlfs.tlfs13,'O',u_flag)
       END IF
 
       #-->入庫
       IF q_tlfs.tlfs09 = 1 THEN 
          LET xxx=s_get_doc_no(q_tlfs.tlfs10)  #TQC-920085
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH 
          END IF
 
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF
 
          OUTPUT TO REPORT p620_imks_rep (q_tlfs.tlfs01,q_tlfs.tlfs02,
                                          q_tlfs.tlfs03,q_tlfs.tlfs04,
                                          q_tlfs.tlfs05,q_tlfs.tlfs06,
                                          q_tlfs.tlfs15,0,0,0,0,0,0,0,
                                          q_tlfs.tlfs13,'I',u_flag)
       END IF
 
   END FOREACH
 
   IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
   IF STATUS OR SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_imks_c2:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    
   END IF
 
   IF g_success = 'N' THEN
      RETURN
   END IF 
 
   FINISH REPORT p620_imks_rep
 
   CLOSE WINDOW p620_imks_ww
 
END FUNCTION
 
REPORT p620_imks_rep(sr)
DEFINE sr    RECORD
             imks01    LIKE imks_file.imks01,   #料號
             imks02    LIKE imks_file.imks02,   #倉庫
             imks03    LIKE imks_file.imks03,   #儲位
             imks04    LIKE imks_file.imks04,   #批號
             imks10    LIKE imks_file.imks10,   #序號
             imks11    LIKE imks_file.imks11,   #外批
             imks12    LIKE imks_file.imks12,   #歸屬單號
             imks081   LIKE imks_file.imks081,  #入
             imks082   LIKE imks_file.imks082,  #銷
             imks083   LIKE imks_file.imks083,  #領
             imks084   LIKE imks_file.imks084,  #轉
             imks085   LIKE imks_file.imks085,  #調
             imks086   LIKE imks_file.imks086,  #
             imks09    LIKE imks_file.imks09,   #期末數量
             tlfs13    LIKE tlfs_file.tlfs13,   #異動數量
             code      LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
             u_flag    LIKE type_file.num5      #No.FUN-690026 SMALLINT
        END  RECORD
DEFINE l_imks RECORD   LIKE imks_file.*
DEFINE l_imks081       LIKE imks_file.imks081
DEFINE l_imks082       LIKE imks_file.imks082
DEFINE l_imks083       LIKE imks_file.imks083
DEFINE l_imks084       LIKE imks_file.imks084
DEFINE l_imks085       LIKE imks_file.imks085
DEFINE l_imks086       LIKE imks_file.imks086
DEFINE l_imks09        LIKE imks_file.imks09 
DEFINE last_imks09     LIKE imks_file.imks09 
DEFINE l_temp          LIKE imks_file.imks09 
DEFINE l_year          LIKE imks_file.imks05 
DEFINE l_month         LIKE imks_file.imks06 
DEFINE l_imd20        LIKE imd_file.imd20   #MOD-B40126 
DEFINE l_imks087       LIKE imks_file.imks087  #FUN-CB0037
DEFINE l_imks088       LIKE imks_file.imks088  #FUN-CB0037
DEFINE l_imks089       LIKE imks_file.imks089  #FUN-CB0037

   OUTPUT 
      TOP MARGIN g_top_margin 
      LEFT MARGIN g_left_margin 
      BOTTOM MARGIN g_bottom_margin 
      PAGE LENGTH g_page_line
 
  #ORDER BY sr.imks01, sr.imks02, sr.imks03, sr.imks04,sr.imks10,sr.imks11 #MOD-A90060 mark
   ORDER BY sr.imks01, sr.imks02, sr.imks03, sr.imks04,sr.imks11,sr.imks10 #MOD-A90060
 
   FORMAT
     #BEFORE GROUP OF sr.imks11 #MOD-A90133 mark
      BEFORE GROUP OF sr.imks10 #MOD-A90133
        #BEGIN WORK #MOD-A90101 mark
         LET g_success = 'Y'
         LET l_imks081 = 0
         LET l_imks082 = 0
         LET l_imks083 = 0
         LET l_imks084 = 0
         LET l_imks085 = 0
         LET l_imks086 = 0  
         LET l_imks09 = 0
         LET last_imks09  = 0
      
      ON EVERY ROW 
         IF sr.code = 'O' THEN
            LET sr.tlfs13=sr.tlfs13 * -1
         END IF
 
         CASE WHEN sr.u_flag=1 LET l_imks081=l_imks081+sr.tlfs13
              WHEN sr.u_flag=2 LET l_imks082=l_imks082+sr.tlfs13
              WHEN sr.u_flag=3 LET l_imks083=l_imks083+sr.tlfs13
              WHEN sr.u_flag=4 LET l_imks084=l_imks084+sr.tlfs13
              WHEN sr.u_flag=5 LET l_imks085=l_imks085+sr.tlfs13
              OTHERWISE EXIT CASE
         END CASE
 
         LET l_imks09 = l_imks09 + sr.imks09
 
         PRINT 'every:',sr.imks01 CLIPPED, sr.imks02 CLIPPED, sr.imks03 CLIPPED, 
                        sr.imks04 CLIPPED, sr.imks10 CLIPPED, sr.imks11 CLIPPED 
      
      AFTER GROUP OF sr.imks10
         PRINT 'after:',sr.imks01 CLIPPED, sr.imks02 CLIPPED, sr.imks03 CLIPPED, 
                        sr.imks04 CLIPPED, sr.imks10 CLIPPED, sr.imks11 CLIPPED 
      
         LET last_imks09  = l_imks09  + l_imks081 + l_imks082 + 
                            l_imks083 + l_imks084 + l_imks085
         #FUN-CB0037---begin mark
         #DELETE FROM imks_file WHERE imks01 = sr.imks01 
         #                     AND imks02 = sr.imks02 
         #                     AND imks03 = sr.imks03 
         #                     AND imks04 = sr.imks04 
         #                     AND imks10 = sr.imks10 
         #                     AND imks11 = sr.imks11 
         #                     AND imks05 = yy
         #                     AND imks06 = mm
         #FUN-CB0037---end
         EXECUTE del_imks1 USING sr.imks01,sr.imks02,sr.imks03,sr.imks04,sr.imks10,sr.imks11  #FUN-CB0037
         IF SQLCA.SQLCODE THEN
            LET g_showmsg = sr.imks01,"/",sr.imks02,"/",sr.imks03,"/",sr.imks04,"/",sr.imks10,"/",sr.imks11,"/",yy,"/",mm,"/"
            CALL s_errmsg('imks01,imks02,imks03,imks04,imks10,imks11,imks05,imks06',g_showmsg,
                                            'Delete imks_file error !',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=sr.imks02 #MOD-B40126
#FUN-CB0037---begin mark         
#         IF cl_null(l_imd20) THEN LET l_imd20 = g_plant END IF   #FUN-CA0151
#         INSERT INTO imks_file(imks01,imks02,imks03,imks04,imks05,imks06,  #No.MOD-470041
#                              imks081,imks082,imks083,imks084,imks085,
#                              imks086,imks087,imks088,imks089,imks09,imks10,imks11,imks12,imksplant,imkslegal) #No.FUN-980004
#              VALUES (sr.imks01,sr.imks02,sr.imks03,sr.imks04,yy,mm,l_imks081,l_imks082,
##                      l_imks083,l_imks084,l_imks085,l_imks086,0,0,0,last_imks09,sr.imks10,sr.imks11,sr.imks12,g_plant,g_legal)  #No.FUN-980004 #MOD-B40126
#                      l_imks083,l_imks084,l_imks085,l_imks086,0,0,0,last_imks09,sr.imks10,sr.imks11,sr.imks12,l_imd20,g_legal)  #MOD-B40126
#FUN-CB0037---end
         #FUN-CB0037---begin    
         LET l_imks087 = 0
         LET l_imks088 = 0
         LET l_imks089 = 0
         EXECUTE ins_imks1 USING sr.imks01,sr.imks02,sr.imks03,sr.imks04,yy,mm,l_imks081,l_imks082,
                                 l_imks083,l_imks084,l_imks085,l_imks086,l_imks087,l_imks088,l_imks089,last_imks09,sr.imks10,sr.imks11,sr.imks12,l_imd20,g_legal
         #FUN-CB0037---end
         IF SQLCA.SQLCODE THEN     
            CALL s_errmsg('','','Insert imks_file error !',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         ELSE 
            DISPLAY sr.imks01 TO FORMONLY.imks01
            DISPLAY sr.imks02 TO FORMONLY.imks02
         END IF
#------------------------ UPDATE next imks_file -------------------------------
         IF next_compute = 'Y' THEN
            #FUN-CB0037---begin
            #DECLARE p620_next_imks CURSOR FOR
            # SELECT imks_file.* FROM imks_file
            #  WHERE imks01 = sr.imks01
            #    AND imks02 = sr.imks02
            #    AND imks03 = sr.imks03
            #    AND imks04 = sr.imks04
            #    AND imks10 = sr.imks10
            #    AND imks11 = sr.imks11
            #    AND (imks05 > yy OR
            #        (imks05 = yy AND imks06 > mm))
            #  ORDER BY imks05,imks06
            #
            #FOREACH p620_next_imks INTO l_imks.*
            #FUN-CB0037---end
            FOREACH p620_next_imks USING sr.imks01,sr.imks02,sr.imks03,sr.imks04,sr.imks10,sr.imks11 INTO l_imks.*  #FUN-CB0037
               IF g_success='N' THEN                                                                                                        
                  LET g_totsuccess='N'                                                                                                      
                  LET g_success="Y"                                                                                                         
               END IF                                                                                                                       
      
               IF SQLCA.SQLCODE THEN 
                  CALL s_errmsg('','','foreach p620_next_imks error!',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF
 
               IF cl_null(l_imks.imks081) THEN LET l_imks.imks081 = 0 END IF
               IF cl_null(l_imks.imks082) THEN LET l_imks.imks082 = 0 END IF
               IF cl_null(l_imks.imks083) THEN LET l_imks.imks083 = 0 END IF
               IF cl_null(l_imks.imks084) THEN LET l_imks.imks084 = 0 END IF
               IF cl_null(l_imks.imks085) THEN LET l_imks.imks085 = 0 END IF
               IF cl_null(l_imks.imks086) THEN LET l_imks.imks086 = 0 END IF
               IF cl_null(l_imks.imks09)  THEN LET l_imks.imks09 =  0 END IF
 
               LET l_temp = last_imks09 + l_imks.imks081 + l_imks.imks082
                             + l_imks.imks083 + l_imks.imks084 + l_imks.imks085
               #FUN-CB0037---begin mark
               #UPDATE imks_file SET imks09 = l_temp     
               # #MOD-B80024 add
               # WHERE imks01=l_imks.imks01
               #   AND imks02=l_imks.imks02
               #   AND imks03=l_imks.imks03
               #   AND imks04=l_imks.imks04
               #   AND imks05=l_imks.imks05
               #   AND imks06=l_imks.imks06
               #   AND imks10=l_imks.imks10
               #   AND imks11=l_imks.imks11
               #   AND imks12=l_imks.imks12
               # #MOD-B80024 add--end
               #FUN-CB0037---end
               EXECUTE upd_imks1 USING l_temp,l_imks.imks01,l_imks.imks02,l_imks.imks03,l_imks.imks04,l_imks.imks05,l_imks.imks06,l_imks.imks10,l_imks.imks11,l_imks.imks12  #FUN-CB0037  
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] != 1 THEN
                  CALL s_errmsg('',' ','Update imks_file error !',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
      
               LET last_imks09=l_temp 
            END FOREACH
      
            IF g_totsuccess="N" THEN                                                                                                         
                LET g_success="N"                                                                                                             
            END IF                                                                                                                           
         
         END IF
      
         #---------------------- UPDATE next imks_file finish ----------------------
         #MOD-A90101 mark --start--
         #IF g_success = 'Y' THEN
         #   COMMIT WORK    
         #ELSE
         #   ROLLBACK WORK  
         #END IF
         #MOD-A90101 mark --end--
 
END REPORT 
#No.FUN-9C0072 精簡程式碼
#FUN-CA0151---begin
FUNCTION p620_idx()
   DEFINE l_yy,l_mm   LIKE type_file.num10  
   DEFINE l_bdate     LIKE type_file.dat    
   DEFINE l_edate     LIKE type_file.dat    
   DEFINE l_correct   LIKE type_file.chr1   
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_name      LIKE type_file.chr20 
   
   #FUN-CB0037---begin
   LET g_sql = " SELECT idx_file.* FROM idx_file ",
               "  WHERE idx01 = ? ",
               "    AND idx02 = ? ",
               "    AND idx03 = ? ",
               "    AND idx04 = ? ",
               "    AND idx10 = ? ",
               "    AND idx11 = ? ",
               "    AND   (idx05 > ",yy,
               "     OR   (idx05 = ",yy," AND idx06 > ",mm," ))"
   DECLARE p620_next_idx CURSOR FROM g_sql
   
   LET g_sql = " DELETE FROM idx_file ",
               "        WHERE idx01 = ? ", 
               "          AND idx02 = ? ",
               "          AND idx03 = ? ", 
               "          AND idx04 = ? ", 
               "          AND idx10 = ? ", 
               "          AND idx11 = ? ", 
               "          AND idx05 = ",yy,    
               "          AND idx06 = ",mm
   PREPARE del_idx1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('delete idx1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " INSERT INTO idx_file(idx01,idx02,idx03,idx04,idx05,idx06, ",
               "                      idx081,idx082,idx083,idx084,idx085, ",
               "                      idx09,idx10,idx11,idxplant,idxlegal) ",
               "              VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? ) "
   PREPARE ins_idx1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert idx1:',STATUS,1)
      RETURN
   END IF

   LET g_sql = " UPDATE idx_file SET idx09 = ? ",
               "  WHERE idx01=? ",
               "    AND idx02=? ",
               "    AND idx03=? ",
               "    AND idx04=? ",
               "    AND idx05=? ",
               "    AND idx06=? ",
               "    AND idx10=? ",
               "    AND idx11=? "
               
   PREPARE upd_idx1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('update idx1:',STATUS,1)
      RETURN
   END IF
   #FUN-CB0037---end
   
   LET g_success = 'Y'
   CALL cl_outnam('aimp620') RETURNING l_name
   START REPORT p620_idx_rep TO l_name
   CALL s_azm(yy,mm) RETURNING l_correct, g_bdate, g_edate
   IF l_correct != '0'  THEN 
      LET  g_success = 'N'
   END IF
   IF mm = 1
      THEN IF g_aza.aza02 = '1'
              THEN LET l_mm = 12
                   LET l_yy = yy - 1
              ELSE LET l_mm = 13
                   LET l_yy = yy - 1
           END IF
      ELSE LET l_mm = mm - 1
           LET l_yy = yy
   END IF
   #FUN-CB0037---begin
   IF dc = 'Y' THEN 
      LET g_sql = " DELETE FROM idx_file ",
                  " WHERE idx05 = ",yy,   
                  "   AND idx06 = ",mm,    
                  "   AND EXISTS (SELECT 1 FROM ima_file WHERE ima01 = idx01 AND ",g_wc CLIPPED," )"
      PREPARE del_idx FROM g_sql
      IF STATUS THEN
         CALL cl_err('delete idx:',STATUS,1)
         RETURN
      END IF
      EXECUTE del_idx
      IF SQLCA.sqlcode THEN
	     CALL cl_err('delete idx fail:',SQLCA.sqlcode,1)
         LET g_success = 'N'
	     RETURN
      END IF 
   END IF 
   #FUN-CB0037---end
   #FUN-CB0037---begin mark
   #LET g_sql = "SELECT idc01,idc02,idc03,idc04,idc05,idc06,",
   #            "       idx081,idx082,idx083,idx084,idx085,idx09",
   #            "  FROM ima_file,idc_file LEFT OUTER JOIN idx_file ON ",
   #            "        idc01 = idx01",
   #            "    AND idc02 = idx02 ",
   #            "    AND idc03 = idx03 ",
   #            "    AND idc04 = idx04 ",
   #            "    AND idc05 = idx10 ",
   #            "    AND idc06 = idx11 ",
   #            "    AND idx05 =",l_yy,
   #            "    AND idx06 =",l_mm,
   #            "  WHERE ima01 = idc01 ",
   #            "    AND ",g_wc CLIPPED,
   #            " ORDER BY idc01 "
   #FUN-CB0037---end
   #FUN-CB0037---begin
   LET g_sql = " SELECT idx01,idx02,idx03,idx04,idx10,idx11,",
               "       idx081,idx082,idx083,idx084,idx085,idx09",
               "  FROM idx_file,ima_file ",        
               "  WHERE idx01 = ima01 ",
               "  AND   idx05 =",l_yy,
               "  AND   idx06 =",l_mm,
               "  AND   idx09 != 0 ",
               "  AND ",g_wc CLIPPED,    
               " ORDER BY 1 "
   #FUN-CB0037---end
   PREPARE p620_idx_p1 FROM g_sql
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('Prepare p620_idx_p1 error !',SQLCA.SQLCODE,1)
   END IF
   DECLARE p620_idx_c1 CURSOR WITH HOLD FOR p620_idx_p1
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('Declare p620_idx_c1 error !',SQLCA.SQLCODE,1)
   END IF
   FOREACH p620_idx_c1 INTO g_idx.*
      IF STATUS THEN
         CALL s_errmsg('','','Foreach idx_file error !',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
         EXIT FOREACH
      END IF

      IF cl_null(g_idx.idx081) THEN LET g_idx.idx081 = 0 END IF
      IF cl_null(g_idx.idx082) THEN LET g_idx.idx082 = 0 END IF
      IF cl_null(g_idx.idx083) THEN LET g_idx.idx083 = 0 END IF
      IF cl_null(g_idx.idx084) THEN LET g_idx.idx084 = 0 END IF
      IF cl_null(g_idx.idx085) THEN LET g_idx.idx085 = 0 END IF
      IF cl_null(g_idx.idx09)  THEN LET g_idx.idx09 =  0 END IF
 
      OUTPUT TO REPORT p620_idx_rep(g_idx.*,0,'',0)
   END FOREACH 
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_idx_c1:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    
   END IF
   IF g_success = 'N' THEN
      RETURN     
   END IF 

   IF tlf0607_flag='1' THEN
      LET g_wc1=g_wc CLIPPED,  
                "  AND idd08 BETWEEN '",g_bdate,"' AND '",g_edate,"'" 
   ELSE
      LET g_wc1=g_wc CLIPPED,   
                "  AND idd09 BETWEEN '",g_bdate,"' AND '",g_edate,"'"   
   END IF
   LET g_sql = "SELECT idd01,idd02,idd03,idd04,idd05,idd06,",  
               "       idd12,idd10,idd13", 
               "  FROM ima_file, idd_file",
               "  WHERE idd01 = ima01 ",
               "  AND idd12 IN ('-1','1','5','6') ",   
               "  AND ",g_wc1 CLIPPED, 
               " ORDER BY idd01"
               
   PREPARE p620_idx_p2 FROM g_sql
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','Prepare p620_idx_p2 error !',SQLCA.SQLCODE,1)
      LET g_success = 'N'  RETURN  
   END IF   
   
   DECLARE p620_idx_c2 CURSOR WITH HOLD FOR p620_idx_p2
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','Declare p620_idx_c2 error !',SQLCA.SQLCODE,1)
      LET g_success = 'N'  RETURN 
   END IF   

   FOREACH p620_idx_c2 INTO g_idd.*
       IF STATUS THEN
          CALL s_errmsg('','','Foreach idd_file error !',SQLCA.SQLCODE,1)
          LET g_success = 'N' 
          EXIT FOREACH
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF    
       #-->出庫
       IF g_idd.idd12 = '-1' OR g_idd.idd12 = '5' THEN
          LET xxx=s_get_doc_no(g_idd.idd10)
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF STATUS THEN 
             IF g_bgjob = 'N' THEN
                MESSAGE xxx
             END IF
             CALL ui.Interface.refresh()
             LET u_flag=5 
          END IF

          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH 
          END IF

          OUTPUT TO REPORT p620_idx_rep (g_idd.idd01,g_idd.idd02,
                                          g_idd.idd03,g_idd.idd04,
                                          g_idd.idd05,g_idd.idd06,
                                          0,0,0,0,0,0,
                                          g_idd.idd13,'O',u_flag)
       END IF  
       #-->入庫 
       IF g_idd.idd12 = '1' OR g_idd.idd12 = '6' THEN
          LET xxx=s_get_doc_no(g_idd.idd10)  
          SELECT smydmy2 INTO u_flag FROM smy_file WHERE smyslip=xxx
          IF cl_null(u_flag) OR u_flag = 'X' THEN
             CALL s_errmsg('','',xxx,'aim-207',0)
             CONTINUE FOREACH 
          END IF
          IF STATUS THEN 
              IF g_bgjob = 'N' THEN
                 MESSAGE xxx
              END IF
              CALL ui.Interface.refresh()
              LET u_flag=5 
          END IF

          OUTPUT TO REPORT p620_idx_rep (g_idd.idd01,g_idd.idd02,
                                          g_idd.idd03,g_idd.idd04,
                                          g_idd.idd05,g_idd.idd06,
                                          0,0,0,0,0,0,
                                          g_idd.idd13,'I',u_flag)
       END IF  
   END FOREACH 
 
   IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
   IF STATUS OR SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','foreach p620_idx_c2:',SQLCA.SQLCODE,1)
      LET g_success = 'N'    
   END IF
 
   IF g_success = 'N' THEN
      RETURN
   END IF 
 
   FINISH REPORT p620_idx_rep
   
   CLOSE WINDOW p620_idx_ww
END FUNCTION 
REPORT p620_idx_rep(sr)
DEFINE sr    RECORD
             idx01    LIKE idx_file.idx01,   #料號
             idx02    LIKE idx_file.idx02,   #倉庫
             idx03    LIKE idx_file.idx03,   #儲位
             idx04    LIKE idx_file.idx04,   #批號
             idx10    LIKE idx_file.idx10,   #刻號
             idx11    LIKE idx_file.idx11,   #BIN
             idx081   LIKE idx_file.idx081,  #入
             idx082   LIKE idx_file.idx082,  #銷
             idx083   LIKE idx_file.idx083,  #領
             idx084   LIKE idx_file.idx084,  #轉
             idx085   LIKE idx_file.idx085,  #調
             idx09    LIKE idx_file.idx09,   #期末數量
             idd13    LIKE idd_file.idd13,   #異動數量
             code     LIKE type_file.chr1,     
             u_flag   LIKE type_file.num5      
        END  RECORD
DEFINE l_idx RECORD   LIKE idx_file.*
DEFINE l_idx081       LIKE idx_file.idx081
DEFINE l_idx082       LIKE idx_file.idx082
DEFINE l_idx083       LIKE idx_file.idx083
DEFINE l_idx084       LIKE idx_file.idx084
DEFINE l_idx085       LIKE idx_file.idx085
DEFINE l_idx09        LIKE idx_file.idx09 
DEFINE last_idx09     LIKE idx_file.idx09 
DEFINE l_imd20        LIKE imd_file.imd20
DEFINE l_temp         LIKE idx_file.idx09 

   OUTPUT 
      TOP MARGIN g_top_margin 
      LEFT MARGIN g_left_margin 
      BOTTOM MARGIN g_bottom_margin 
      PAGE LENGTH g_page_line

   ORDER BY sr.idx01, sr.idx02, sr.idx03, sr.idx04,sr.idx10,sr.idx11

   FORMAT
      BEFORE GROUP OF sr.idx11
         LET g_success = 'Y'
         LET l_idx081 = 0
         LET l_idx082 = 0
         LET l_idx083 = 0
         LET l_idx084 = 0
         LET l_idx085 = 0
         LET l_idx09 = 0
         LET last_idx09  = 0

      ON EVERY ROW 
         IF sr.code = 'O' THEN
            LET sr.idd13=sr.idd13 * -1
         END IF

         CASE WHEN sr.u_flag=1 LET l_idx081=l_idx081+sr.idd13
              WHEN sr.u_flag=2 LET l_idx082=l_idx082+sr.idd13
              WHEN sr.u_flag=3 LET l_idx083=l_idx083+sr.idd13
              WHEN sr.u_flag=4 LET l_idx084=l_idx084+sr.idd13
              WHEN sr.u_flag=5 LET l_idx085=l_idx085+sr.idd13
              OTHERWISE EXIT CASE
         END CASE
         LET l_idx09 = l_idx09 + sr.idx09
         
         PRINT 'every:',sr.idx01 CLIPPED, sr.idx02 CLIPPED, sr.idx03 CLIPPED, 
                        sr.idx04 CLIPPED, sr.idx10 CLIPPED, sr.idx11 CLIPPED 
                        
      AFTER GROUP OF sr.idx11  
         PRINT 'after:',sr.idx01 CLIPPED, sr.idx02 CLIPPED, sr.idx03 CLIPPED, 
                        sr.idx04 CLIPPED, sr.idx10 CLIPPED, sr.idx11 CLIPPED  

         LET last_idx09  = l_idx09  + l_idx081 + l_idx082 + 
                           l_idx083 + l_idx084 + l_idx085 
         #FUN-CB0037---begin mark
         #DELETE FROM idx_file WHERE idx01 = sr.idx01 
         #                       AND idx02 = sr.idx02 
         #                       AND idx03 = sr.idx03 
         #                       AND idx04 = sr.idx04 
         #                       AND idx10 = sr.idx10 
         #                       AND idx11 = sr.idx11 
         #                       AND idx05 = yy
         #                       AND idx06 = mm 
         #FUN-CB0037---end
         EXECUTE del_idx1 USING sr.idx01,sr.idx02,sr.idx03,sr.idx04,sr.idx10,sr.idx11  #FUN-CB0037
         IF SQLCA.SQLCODE THEN
            LET g_showmsg = sr.idx01,"/",sr.idx02,"/",sr.idx03,"/",sr.idx04,"/",sr.idx10,"/",sr.idx11,"/",yy,"/",mm,"/"
            CALL s_errmsg('idx01,idx02,idx03,idx04,idx10,idx11,idx05,idx06',g_showmsg,
                                            'Delete idx_file error !',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         SELECT imd20 INTO l_imd20 FROM imd_file WHERE imd01=sr.idx02
         #FUN-CB0037---begin mark
         #IF cl_null(l_imd20) THEN LET l_imd20 = g_plant END IF 
         #INSERT INTO idx_file(idx01,idx02,idx03,idx04,idx05,idx06, 
         #                     idx081,idx082,idx083,idx084,idx085,
         #                     idx09,idx10,idx11,idxplant,idxlegal) 
         #     VALUES (sr.idx01,sr.idx02,sr.idx03,sr.idx04,yy,mm,l_idx081,l_idx082, 
         #             l_idx083,l_idx084,l_idx085,last_idx09,sr.idx10,sr.idx11,l_imd20,g_legal) 
         #FUN-CB0037---end
         EXECUTE ins_idx1 USING  sr.idx01,sr.idx02,sr.idx03,sr.idx04,yy,mm,l_idx081,l_idx082,  #FUN-CB0037
                               l_idx083,l_idx084,l_idx085,last_idx09,sr.idx10,sr.idx11,l_imd20,g_legal   #FUN-CB0037                              
         IF SQLCA.SQLCODE THEN     
            CALL s_errmsg('','','Insert idx_file error !',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF

         IF next_compute = 'Y' THEN
            #FUN-CB0037---begin mark
            #DECLARE p620_next_idx CURSOR FOR
            # SELECT idx_file.* FROM idx_file
            #  WHERE idx01 = sr.idx01
            #    AND idx02 = sr.idx02
            #    AND idx03 = sr.idx03
            #    AND idx04 = sr.idx04
            #    AND idx10 = sr.idx10
            #    AND idx11 = sr.idx11
            #    AND (idx05 > yy OR
            #        (idx05 = yy AND idx06 > mm))
            #  ORDER BY idx05,idx06
            #FOREACH p620_next_idx INTO l_idx.*
            #FUN-CB0037---end
            FOREACH p620_next_idx USING sr.idx01,sr.idx02,sr.idx03,sr.idx04,sr.idx10,sr.idx11 INTO l_idx.*  #FUN-CB0037
               IF g_success='N' THEN                                                                                                        
                  LET g_totsuccess='N'                                                                                                      
                  LET g_success="Y"                                                                                                         
               END IF 

               IF SQLCA.SQLCODE THEN 
                  CALL s_errmsg('','','foreach p620_next_idx error!',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF

               IF cl_null(l_idx.idx081) THEN LET l_idx.idx081 = 0 END IF
               IF cl_null(l_idx.idx082) THEN LET l_idx.idx082 = 0 END IF
               IF cl_null(l_idx.idx083) THEN LET l_idx.idx083 = 0 END IF
               IF cl_null(l_idx.idx084) THEN LET l_idx.idx084 = 0 END IF
               IF cl_null(l_idx.idx085) THEN LET l_idx.idx085 = 0 END IF
               IF cl_null(l_idx.idx09)  THEN LET l_idx.idx09 =  0 END IF

               LET l_temp = last_idx09 + l_idx.idx081 + l_idx.idx082
                             + l_idx.idx083 + l_idx.idx084 + l_idx.idx085
               #FUN-CB0037---begin mark
               #UPDATE idx_file SET idx09 = l_temp 
               # WHERE idx01=l_idx.idx01
               #   AND idx02=l_idx.idx02
               #   AND idx03=l_idx.idx03
               #   AND idx04=l_idx.idx04
               #   AND idx05=l_idx.idx05
               #   AND idx06=l_idx.idx06
               #   AND idx10=l_idx.idx10
               #   AND idx11=l_idx.idx11
               #FUN-CB0037---end
               EXECUTE upd_idx1 USING l_temp,l_idx.idx01,l_idx.idx02,l_idx.idx03,l_idx.idx04,l_idx.idx05,l_idx.idx06,l_idx.idx10,l_idx.idx11  #FUN-CB0037
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] != 1 THEN
                  CALL s_errmsg('',' ','Update idx_file error !',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
      
               LET last_idx09=l_temp 
            END FOREACH
            IF g_totsuccess="N" THEN                                                                                                         
                LET g_success="N"                                                                                                             
            END IF  
         END IF  
END REPORT 
#FUN-CA0151---end
#FUN-CC0064----add-----str
FUNCTION p620_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02

   IF l_db_links IS NULL OR l_db_links = ' ' THEN
      RETURN ' '
   ELSE
      LET l_db_links = '@',l_db_links CLIPPED
      RETURN l_db_links
   END IF
END FUNCTION
#FUN-CC0064----add-----end
