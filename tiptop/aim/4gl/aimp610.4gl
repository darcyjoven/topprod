# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp610.4gl
# Descriptions...: 料件(ima26*)及明細庫存量(img10)重計作業
# Date & Author..: 93/04/20 By Roger
# Modify.........: By Melody 更新盤點檔(pia08)現有庫存 97/06/20
# Modify.........: No.MOD-4C0119 04/12/17 By Mandy 檢示整支程式除了需預設g_success='Y'之外,並將程式處理過程有異常的地方應改變g_success的值='N'
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-540025 05/04/12 By Carrier 雙單位內容修改
# Modify.........: No.MOD-550134 05/05/18 By Mandy 庫存重計作業碰到非月底盤點重計確實是有問題
# Modify.........: No.FUN-570100 05/08/09 By Rosayu 修改aimp610不更新盤點pia_file,新增aimp612料件庫存明細重計作業(含盤點),共用aimp610,依原aimp610處理更新pia_file,tlf_file
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: MOD-590100 05/10/24 By pengu  重計庫存量img10時，若參考的上期年度期別大於等於
                                   #             現行年度期別時，應擋掉不可執行
# Modify.........: No.MOD-590345 05/11/21 By pengu 在計算異動量時會照成小數誤差
# Modify.........: NO.FUN-5C0001 06/01/03 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570122 06/02/17 Yiting 背景執行作業
# Modify.........: No.FUN-640204 06/04/19 Claire ime05,ime06 update img23,img24
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.MOD-650088 06/05/19 BY Claire w_tlf026->xx.tlf905 因當w_tlf026='physical'會無法更新 
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: NO.TQC-670013 06/06/22 By Claire 補上 # Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-690064 06/11/16 By pengu 在撈tlff_file資料的sql會用tlff220做為條件，應改用tlff11
# Modify.........: No.FUN-710025 07/01/17 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740015 07/04/09 By pengu 修改計算MPS/MRP可用庫存數量的SQL限制條件
# Modify.........: No.TQC-740326 07/04/27 By sherry 進行語言轉換結束候，會自動帶著下一個語言轉換的對話框。
# Modify.........: No.MOD-760092 07/06/22 By pengu 在update盤點資料時為更新單據號碼欄位(tlf026/tlf036)
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-8A0086 08/10/17 By zhaijie錯誤匯總加g_success='Y'
# Modify.........: No.MOD-910006 09/01/06 By chenyu 更新數量之前要根據對應單位進行截位
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.MOD-920340 09/02/25 By claire 串imgs11值給錯 
# Modify.........: No.TQC-920086 09/02/25 By claire tlfs12應改tlfs111為日期計算基準
# Modify.........: No.TQC-920092 09/02/27 By claire mark MOD-910006
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.TQC-A60046 10/06/13 By chenmoyan prep imgs_1報錯
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:MOD-A90133 10/09/20 By Summer 若有進行批序號管理會造成imgs或imks異常 
# Modify.........: No:CHI-870048 10/11/26 By Summer 未考慮多單位的盤點資料處理
# Modify.........: No:MOD-B20066 11/02/16 By sabrina 背景執行時要多傳參數以辨別是執行aimp610
# Modify.........: No:MOD-B90208 11/09/26 By johung 修正截止時間沒有顯示
# Modify.........: No:MOD-BA0050 11/10/07 By johung 修正SQL img_file LEFT OUTER JOIN imk_file，img_file應是imgs_file
# Modify.........: No:FUN-BB0086 12/02/02 By tanxc 增加數量欄位小數取位  
# Modify.........: No:CHI-C40027 12/09/14 By batr pias_file重新計算
# Modify.........: No:FUN-CA0151 12/11/01 By bart ICD庫存重計
# Modify.........: No.TQC-CB0082 12/11/26 By qirl 增加開窗
# Modify.........: No.FUN-CB0121 12/11/30 By bart 效能調整
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件

DATABASE ds    #TQC-670013 
 
GLOBALS "../../config/top.global"
 
    DEFINE g_wc,g_sql	        string,                 #No.FUN-580092 HCN
           g_yy,g_mm		LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#          bal26,bal261,bal262	LIKE ima_file.ima26,    #MOD-530179    #FUN-A20044
           bal26,bal261,bal262  LIKE type_file.num15_3,                #FUN-A20044 
           g_img10              LIKE img_file.img10,    #FUN-540025
           g_stime,g_etime      LIKE type_file.chr8,    #No.FUN-690026 VARCHAR(8)
           g_item_t             LIKE img_file.img01,
           g_d1,g_date	        LIKE type_file.dat,     #No.FUN-690026 DATE
           g_argv0              LIKE type_file.chr1,    #FUN-570100    #No.FUN-690026 VARCHAR(1)
           show                 LIKE type_file.chr1     #NO.FUN-5C0001 #No.FUN-690026 VARCHAR(1)
    DEFINE   g_chr              LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
    DEFINE g_msg           STRING                                                      
    DEFINE g_change_lang   LIKE type_file.chr1          #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
 
MAIN
   DEFINE l_flag  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_cnt   LIKE type_file.num5  #No.FUN-810036
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv0 = ARG_VAL(1)       # 1:不更新盤點 pia_file, tlf_file, 2:更新盤點p
   LET g_wc=ARG_VAL(2)
   LET g_yy=ARG_VAL(3)
   LET g_mm=ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #No.FUN-570122 ----end----
 
   #FUN-570100
   #LET g_argv0 = ARG_VAL(1)       # 1:不更新盤點 pia_file, tlf_file, 2:更新盤點p
 
   IF g_argv0 = '1' THEN
      LET g_prog = 'aimp610'
   ELSE
      LET g_prog = 'aimp612'
   END IF
   #FUN-570100(end)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
WHILE TRUE
    LET g_success = 'Y' #MOD-4C0119
    LET show = 'Y'    #NO.FUN-5C0001 ADD
      IF g_bgjob = 'N' THEN
         CALL p610_i()
         IF cl_sure(21,21) THEN
             IF (g_yy*12+g_mm)>=(g_sma.sma51*12+g_sma.sma52) THEN
                 CALL s_errmsg('','','','aim-929',1)
                 CONTINUE WHILE
             END IF
             CALL cl_wait()
             BEGIN WORK     #No.FUN-710025
             LET g_success = 'Y'           #FUN-8A0086
             CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_d1,g_date
             CALL aimp610()
             #No.FUN-540025  --begin
             IF g_sma.sma115 = 'Y' THEN
                 CALL p610_imgg()  #FUN-540025
             END IF
             #No.FUN-540025  --end    
             #-----No.FUN-810036-----
             IF g_success = "Y" THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM ima_file
                 WHERE (ima918='Y' OR ima921='Y')
                IF l_cnt > 0 THEN 
                   CALL p610_imgs()
                END IF
             END IF
             #-----No.FUN-810036 END-----
             #FUN-CA0151---begin
             IF g_success = "Y" THEN
                IF s_industry('icd') THEN 
                   CALL p610_idc()
                END IF 
             END IF 
             #FUN-CA0151---end
             CALL s_showmsg()      #No.FUN-710025
             IF g_success='Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
             ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
             END IF
             IF l_flag THEN
                 CONTINUE WHILE
             ELSE
                 CLOSE WINDOW p610_w  #NO.FUN-570122
                 EXIT WHILE
             END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_d1,g_date
         CALL aimp610()
         IF g_sma.sma115 = 'Y' THEN
            CALL p610_imgg()
         END IF
         #-----No.FUN-810036-----
         IF g_success = "Y" THEN
            SELECT COUNT(*) INTO l_cnt
              FROM ima_file
             WHERE (ima918='Y' OR ima921='Y')
            IF l_cnt > 0 THEN 
               CALL p610_imgs()
            END IF
         END IF
         #FUN-CA0151---begin
         IF g_success = "Y" THEN
            IF s_industry('icd') THEN 
               CALL p610_idc()
            END IF 
         END IF 
         #FUN-CA0151---end
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN

 
FUNCTION p610_i()
   DEFINE lc_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(500)
 
   OPEN WINDOW aimp610_w WITH FORM "aim/42f/aimp610" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=g_sma.sma53

WHILE TRUE
   CONSTRUCT BY NAME g_wc ON img01,img02,img03,img04,ima23,ima08
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 

#----TQC-CB0082---ADD---STAR--
        ON ACTION controlp
           CASE
              WHEN INFIELD(img01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_img01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO img01
                 NEXT FIELD img01
              WHEN INFIELD(img02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_img021"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO img02
                 NEXT FIELD img02
              WHEN INFIELD(img03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_img03"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO img03
                 NEXT FIELD img03
              WHEN INFIELD(img04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_img041"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO img04
                 NEXT FIELD img04
              WHEN INFIELD(ima23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.arg1 = g_plant
                 LET g_qryparam.form = "q_ima232"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima23
                 NEXT FIELD ima23
              OTHERWISE EXIT CASE
           END CASE
#----TQC-CB0082---ADD---END----
       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
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
       #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimp610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
  #INPUT BY NAME g_yy,g_mm WITHOUT DEFAULTS
   INPUT BY NAME g_yy,g_mm,show,g_bgjob WITHOUT DEFAULTS  #NO.FUN-5C0001
 
      AFTER FIELD g_yy
         IF g_yy IS NULL THEN NEXT FIELD g_yy END IF
      AFTER FIELD g_mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF g_mm IS NULL THEN NEXT FIELD g_mm END IF
 
      #No.FUN-610104 --start--
      ON CHANGE g_bgjob
         IF g_bgjob = "Y" THEN
            LET show = "N"
            DISPLAY BY NAME show
            CALL cl_set_comp_entry("show",FALSE)
         ELSE
            CALL cl_set_comp_entry("show",TRUE)
         END IF
      #No.FUN-610104 ---end---
 
      AFTER FIELD g_bgjob
         IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
            NEXT FIELD g_bgjob
         END IF
 
   #-------MOD-590100判斷是否大於現行年月
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0 CLOSE WINDOW aimp610_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
            EXIT PROGRAM
               
         END IF
         IF NOT cl_null(g_yy) AND NOT cl_null(g_mm) THEN
            IF (g_yy*12+g_mm)>=(g_sma.sma51*12+g_sma.sma52) THEN
               CALL cl_err('','aim-929',1)
        #       CONTINUE WHILE
               NEXT FIELD g_yy
            END IF
         END IF
 
   #---end
           
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aimp610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aimp610"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp610','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                 "'",g_argv0 CLIPPED,"'",         #MOD-B20066 add
                 " '",g_wc CLIPPED,"'",
                 " '",g_yy CLIPPED,"'",
                 " '",g_mm CLIPPED,"'",
                 " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aimp610',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
  EXIT WHILE
END WHILE
END FUNCTION


 
FUNCTION aimp610()
   DEFINE l_name        LIKE type_file.chr20,  #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
          l_sql        STRING,     #NO.FUN-910082
          l_rowid	LIKE type_file.row_id, #chr18,  #No.FUN-690026 FUN-A70120
          l_sw          LIKE type_file.num10,  #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_cnt1        LIKE type_file.num10,  #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_sw_tot      LIKE type_file.num10,  #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_count       LIKE type_file.num10,  #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_bal,l_pia30 LIKE pia_file.pia30,   #MOD-530179
          l_pia50       LIKE pia_file.pia50,   #MOD-530179
          l_pia01       LIKE pia_file.pia01, #No.MOD-760092 add
          l_imgg09      LIKE imgg_file.imgg09, #FUN-540025
          l_imgg10      LIKE imgg_file.imgg10, #FUN-540025
          w_tlf026      LIKE tlf_file.tlf026,
          l_ime05       LIKE ime_file.ime05,   #FUN-640204
          l_ime06       LIKE ime_file.ime06,   #FUN-640204
          g_count       LIKE type_file.num5,   #No.FUN-690026 SMALLINT
          xx		RECORD LIKE tlf_file.*,
          l_tlf10       LIKE tlf_file.tlf10,   #No.MOD-590345 add
          sr            RECORD
                        img01     LIKE img_file.img01,
                        img02     LIKE img_file.img02,
                        img03     LIKE img_file.img03,
                        img04     LIKE img_file.img04,
                        imk09     LIKE imk_file.imk09
                        END RECORD
   #No.MOD-910006 add --begin
   DEFINE l_img09       LIKE img_file.img09
   DEFINE l_ima25       LIKE ima_file.ima25
   DEFINE l_gfe03       LIKE gfe_file.gfe03
   #No.MOD-910006 add --end

     #FUN-CB0121---begin
     LET l_sql = " SELECT rowid,tlf_file.* FROM tlf_file ",
                 "  WHERE tlf01 = ? ",
                 "    AND tlf06 > ? ",
                 "    AND ( tlf907 <> 0 ) AND tlf902 = ? ",
                 "    AND tlf903 = ? ",
                 "    AND tlf904 = ? ",
                 "  ORDER BY tlf06,tlf08 "
     DECLARE p610_c2 CURSOR FROM l_sql

     LET l_sql = " UPDATE tlf_file SET tlf02 = ? ,  tlf021 = ? , tlf022 = ? ,",
                 "                     tlf023 = ? , tlf026 = ? , tlf03 = ? ,",
                 "                     tlf031 = ? , tlf032 = ? , tlf033 = ? ,",
                 "                     tlf036 = ? , tlf10 = ? , tlf12 = ? ,",
                 "                     tlf907 = ? ",
                 "  WHERE rowid = ? "  

     PREPARE upd_tlf FROM l_sql

     LET l_sql = " UPDATE pia_file SET pia08=? WHERE pia01=? "
     PREPARE upd_pia FROM l_sql

     LET l_sql = " UPDATE img_file SET img10=? ,",
                 "                     img23=? ,",
                 "                     img24=? ",
                 "  WHERE img01=? AND img02=? ",
                 "    AND img03=? AND img04=? "
     PREPARE upd_img FROM l_sql
     #FUN-CB0121---end
 
     LET g_stime=TIME
     LET g_item_t=NULL
     LET g_count=0
     LET l_sql="SELECT img01,img02,img03,img04,imk09",
               "  FROM img_file,ima_file, OUTER imk_file ",
               " WHERE ",g_wc CLIPPED," AND img01=ima01",
               "   AND img_file.img01=imk_file.imk01 AND img_file.img02=imk_file.imk02",
                "   AND img_file.img03=imk_file.imk03 AND img_file.img04=imk_file.imk04",
               "   AND imk_file.imk05=",g_yy," AND imk_file.imk06=",g_mm,
               " ORDER BY img01,img02,img03,img04"
 
    #NO.FUN-5C0001 START-----
     IF show = 'N' THEN
         LET l_count = 1
         LET g_sql="SELECT COUNT(*) ",
                   "  FROM img_file,ima_file, OUTER imk_file ",
                   " WHERE ",g_wc CLIPPED," AND img01=ima01",
                   "   AND img_file.img01=imk_file.imk01 AND img_file.img02=imk_file.imk02",
                    "   AND img_file.img03=imk_file.imk03 AND img_file.img04=imk_file.imk04",
                   "   AND imk_file.imk05='",g_yy,"'",
                   "   AND imk_file.imk06='",g_mm,"'"
 
         PREPARE aimp610_show_p FROM g_sql
         IF STATUS THEN
            CALL cl_err('prep:',STATUS,1)
         END IF
         DECLARE aimp610_show_c CURSOR FOR aimp610_show_p
         IF STATUS THEN
            CALL cl_err('declare p610_show_c:',STATUS,1)
         END IF
         FOREACH aimp610_show_c INTO l_sw_tot
         END FOREACH
         IF l_sw_tot>0 THEN
             IF l_sw_tot > 10 THEN
                LET l_sw = l_sw_tot /10
                CALL cl_progress_bar(10)
             ELSE
                CALL cl_progress_bar(l_sw_tot)
             END IF
          END IF
     END IF
     #NO.MOD-5C0001 END-----------------
 
     PREPARE aimp610_prepare1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prep:',STATUS,1)
       #EXIT PROGRAM
         LET g_success = 'N' #MOD-4C0119
         #NO.MOD-5C0001 start--
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
         #NO.MOD-5C0001 END--
         RETURN              #MOD-4C0119
     END IF
 
     DECLARE aimp610_curs1 CURSOR FOR aimp610_prepare1
     IF STATUS THEN
         CALL cl_err('declare p610_curs1:',STATUS,1)
       #EXIT PROGRAM
         LET g_success = 'N' #MOD-4C0119
         #NO.MOD-5C0001 start--
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
         #NO.MOD-5C0001 END--
         RETURN              #MOD-4C0119
     END IF
     CALL s_showmsg_init()     #No.FUN-710025
     FOREACH aimp610_curs1 INTO sr.*
       IF STATUS THEN
       #No.FUN-710025--Begin--
       #  CALL cl_err('foreach: ',STATUS,1)
          CALL s_errmsg('','','foreach: ',STATUS,1)
       #No.FUN-710025--End--
         #EXIT PROGRAM
           LET g_success = 'N' #MOD-4C0119
         #NO.MOD-5C0001 start--
         IF show = 'N' THEN
             CALL cl_close_progress_bar()
         END IF
         #NO.MOD-5C0001 END--
           RETURN              #MOD-4C0119
       END IF
       #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710025--End-
 
       LET l_cnt1 = l_cnt1 + 1  #NO.FUN-5C0001 ADD
       IF sr.img01 != g_item_t THEN
          SELECT SUM(img10*img21) INTO bal26 FROM img_file
         #---------------No.MOD-740015 modify
          #WHERE img01 = g_item_t AND img23 = 'Y' AND img24 = 'Y'
           WHERE img01 = g_item_t AND img24 = 'Y'
         #---------------No.MOD-740015 end
          SELECT SUM(img10*img21) INTO bal261 FROM img_file
           WHERE img01 = g_item_t AND img23 = 'N'
          SELECT SUM(img10*img21) INTO bal262 FROM img_file
           WHERE img01 = g_item_t AND img23 = 'Y'
          IF bal26  IS NULL THEN LET bal26  = 0 END IF
          IF bal261 IS NULL THEN LET bal261 = 0 END IF
          IF bal262 IS NULL THEN LET bal262 = 0 END IF
          #TQC-920092-begin-mark
          ##No.MOD-910006 add --begin
          #SELECT ima25 INTO l_ima25 FROM ima_file
          # WHERE ima01 = g_item_t
          #SELECT gfe03 INTO l_gfe03 FROM gfe_file
          # WHERE gfe01 = l_ima25 AND gfeacti = 'Y'
          #IF NOT cl_null(l_gfe03) THEN
          #   LET bal26  = cl_digcut(bal26,l_gfe03)
          #   LET bal261 = cl_digcut(bal261,l_gfe03)
          #   LET bal262 = cl_digcut(bal262,l_gfe03)
          #END IF
          #No.MOD-910006 add --end
          #TQC-920092-end-mark
#No.FUN-A20044 --mark---start
#          UPDATE ima_file SET 
#                 ima26=bal26,ima261=bal261,ima262=bal262
#           WHERE ima01 = g_item_t
#         #No.+035 010329 by plum modi 判斷status-> sqlca.sqlcode
#         #IF STATUS THEN
#          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd ima:',SQLCA.SQLCODE,1)
#         #No.FUN-710025--Begin--
#         #   CALL cl_err3("upd","ima_file",g_item_t,"",STATUS,"","upd ima:",1)   #NO.FUN-640266 #No.FUN-660156 
#             CALL s_errmsg('ima01',g_item_t,'upd ima:',SQLCA.SQLCODE,1)
#         #No.FUN-710025--End--
#             LET g_success = 'N' #MOD-4C0119
#             RETURN              #MOD-4C0119
#          END IF
#         #No.+035..end
#No.FUN-A20044 ---mark----end 
       END IF
       LET g_item_t=sr.img01
       LET g_count=g_count+1
       #NO.FUN-570122  ---start---
         #NO.FUN-5C0001 START--------
       IF show = 'Y' OR g_bgjob THEN
       #IF show = 'Y' THEN
           MESSAGE sr.img01,sr.img04,g_count
           CALL ui.Interface.refresh()
       END IF
         #NO.FUN-5C0001 END-----------
       #NO.FUN-570122 END----------
       IF cl_null(sr.imk09) THEN LET sr.imk09=0 END IF
       ####---庫存異動
       #CHI-C80041---begin
       #DECLARE p610_c2 CURSOR FOR
       #  SELECT rowid,tlf_file.* FROM tlf_file
       #   WHERE tlf01 = sr.img01
       #     AND tlf06 > g_date
       #     AND ( tlf907 <> 0 ) AND tlf902 = sr.img02
       #     AND tlf903 = sr.img03 AND tlf904 = sr.img04
       #   ORDER BY tlf06,tlf08
       #CHI-C80041---end
       LET l_bal = sr.imk09
       #FOREACH p610_c2 INTO l_rowid,xx.*  #CHI-C80041
       FOREACH p610_c2 USING sr.img01,g_date,sr.img02,sr.img03,sr.img04 INTO l_rowid,xx.*  #FUN-CB0121
         IF STATUS THEN
            CALL s_errmsg('','','foreach2:',STATUS,1)
             LET g_success = 'N' #MOD-4C0119
             IF show = 'N' THEN
                  CALL cl_close_progress_bar()
             END IF
              EXIT FOREACH        #No.FUN-710025
         END IF
         IF xx.tlf10 IS NULL THEN LET xx.tlf10=0 END IF
         IF xx.tlf12 IS NULL OR xx.tlf12=0 THEN LET xx.tlf12=1 END IF
        IF g_argv0 = '2' then
           IF xx.tlf13='aimp880' THEN
               LET l_pia30=NULL #MOD-550134
               LET l_pia50=NULL #MOD-550134
               SELECT pia01,pia30,pia50 INTO l_pia01,l_pia30,l_pia50 FROM pia_file     #No.MOD-760092 add pia01
               WHERE pia02=sr.img01 AND pia03=sr.img02
                 AND pia04=sr.img03 AND pia05=sr.img04
                 AND (pia01=xx.tlf026 OR pia01=xx.tlf036)
              IF STATUS THEN
                 IF xx.tlf024 IS NOT NULL AND xx.tlf024 != 0
                    THEN LET l_pia30=xx.tlf024
                    ELSE LET l_pia30=xx.tlf034
                 END IF
              ELSE
                  IF NOT cl_null(l_pia50) THEN LET l_pia30 = l_pia50 END IF #MOD-550134
              END IF
## No.3003 modify 1999/01/22
              IF xx.tlf024 IS NOT NULL AND xx.tlf024 != 0 THEN
                 LET w_tlf026=xx.tlf026
              ELSE
                 LET w_tlf026=xx.tlf036
              END IF
##-------------------------
              #IF NOT cl_null(l_pia50) THEN LET l_pia30 = l_pia50 END IF #MOD-550134 MARK
              IF l_pia30 IS NULL THEN LET l_pia30=0 END IF
              LET xx.tlf10=l_bal-l_pia30
              #{BugNo:6465
              IF xx.tlf10 >0 THEN
                  #出庫(盤虧)
                  LET xx.tlf02=50 LET xx.tlf021=sr.img02
                                  LET xx.tlf022=sr.img03
                                  LET xx.tlf023=sr.img04
                                  LET xx.tlf026=l_pia01       #No.MOD-760092 add
                  LET xx.tlf03=0  LET xx.tlf031=NULL
                                  LET xx.tlf032=NULL
                                  LET xx.tlf033=NULL
                                  LET xx.tlf036='Physical'    #No.MOD-760092 add
                  LET xx.tlf907=-1
              END IF
              IF xx.tlf10 <0 THEN
                  #入庫(盤盈)
                  LET xx.tlf10 = xx.tlf10 *(-1) #讓tlf10的值變成正
                  LET xx.tlf02= 0 LET xx.tlf021=NULL
                                  LET xx.tlf022=NULL
                                  LET xx.tlf023=NULL
                                  LET xx.tlf026='Physical'    #No.MOD-760092 add
                  LET xx.tlf03=50 LET xx.tlf031=sr.img02
                                  LET xx.tlf032=sr.img03
                                  LET xx.tlf033=sr.img04
                                  LET xx.tlf036=l_pia01       #No.MOD-760092 add
                  LET xx.tlf907=1
              END IF
              #BugNo:6465}
 
              #UPDATE tlf_file SET *=xx.* WHERE rowid=l_rowid  #CHI-C80041
              EXECUTE upd_tlf USING xx.tlf02,xx.tlf021,xx.tlf022,xx.tlf023,xx.tlf026,xx.tlf03,xx.tlf031,  #FUN-CB0121
                                    xx.tlf032,xx.tlf033,xx.tlf036,xx.tlf10,xx.tlf12,xx.tlf907,l_rowid   #FUN-CB0121
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('rowid',l_rowid,'upd tlf:',SQLCA.SQLCODE,1)
                  LET g_success = 'N' #MOD-4C0119
                   IF show = 'N' THEN
                       CALL cl_close_progress_bar()
                   END IF
                  RETURN              #MOD-4C0119
              END IF
              #UPDATE pia_file SET pia08=l_bal WHERE pia01=xx.tlf905 #MOD-650088  #FUN-CB0121
              EXECUTE upd_pia USING l_bal,xx.tlf905  #FUN-CB0121
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('pia01',xx.tlf905,'upd pia:',SQLCA.SQLCODE,1)
                  LET g_success = 'N' #MOD-4C0119
                  IF show = 'N' THEN
                     CALL cl_close_progress_bar()
                  END IF
                  RETURN              #MOD-4C0119
              END IF
           END IF
        END IF
  
           #BugNo:6465
         IF xx.tlf031=sr.img02 AND xx.tlf032=sr.img03 AND xx.tlf033=sr.img04
            AND xx.tlf13 != 'apmt1071'
            THEN LET xx.tlf10  = xx.tlf10 *  1
            ELSE LET xx.tlf10  = xx.tlf10 * -1
         END IF
       #----No.MOD-590345
         LET l_tlf10 =  xx.tlf10*xx.tlf12
         #TQC-920092-begin-mark
         ##No.MOD-910006 add --begin
         #SELECT img09 INTO l_img09 FROM img_file
         # WHERE img01 = sr.img01 AND img02 = sr.img02
         #   AND img03 = sr.img03 AND img04 = sr.img04
         #SELECT gfe03 INTO l_gfe03 FROM gfe_file
         # WHERE gfe01 = l_img09 AND gfeacti = 'Y'
         #IF NOT cl_null(l_gfe03) THEN
         #   LET l_tlf10 = cl_digcut(l_tlf10,l_gfe03)
         #END IF
         ##No.MOD-910006 add --end
         #TQC-920092-end-mark
       # LET l_bal = l_bal + xx.tlf10*xx.tlf12
         LET l_bal = l_bal + l_tlf10
       #---No.MOD-590345 end
 
       END FOREACH
       IF STATUS THEN
       #No.FUN-710025--Begin--
       #   CALL cl_err('foreach p610_c2:',STATUS,1)
           CALL s_errmsg('','','foreach p610_c2:',STATUS,1)
       #No.FUN-710025--End--
            LET g_success = 'N' #MOD-4C0119
            #NO.MOD-5C0001 start--
            IF show = 'N' THEN
                 CALL cl_close_progress_bar()
            END IF
            #NO.MOD-5C0001 END--
            RETURN              #MOD-4C0119
       END IF
       #FUN-640204-begin
        SELECT ime05,ime06 INTO l_ime05,l_ime06 FROM ime_file
         WHERE ime01=sr.img02 AND ime02=sr.img03
	AND imeacti='Y'  #FUN-D40103 add
       #FUN-640204-end
       #FUN-CB0121---begin 
       #UPDATE img_file SET img10=l_bal
       #                   ,img23=l_ime05   #FUN-640204
       #                   ,img24=l_ime06   #FUN-640204
       # WHERE img01=sr.img01 AND img02=sr.img02
       #   AND img03=sr.img03 AND img04=sr.img04
       #FUN-CB0121---end     
       EXECUTE upd_img USING l_bal,l_ime05,l_ime06,sr.img01,sr.img02,sr.img03,sr.img04 #FUN-CB0121 
      #No.+035 010329 by plum modi 判斷status-> sqlca.sqlcode
      #IF STATUS THEN CALL cl_err('upd img:',STATUS,1) END IF
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('upd img:',SQLCA.SQLCODE,1)
       #No.FUN-710025--Begin--
       #  CALL cl_err3("upd","img_file",sr.img01,sr.img02,STATUS,"","upd img",1)   #NO.FUN-640266  #No.FUN-660156
          LET g_showmsg = sr.img01,"/",sr.img02,"/",sr.img03,"/",sr.img04
          CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd img:',STATUS,1)
       #No.FUN-710025--End--
           LET g_success = 'N' #MOD-4C0119
            #NO.MOD-5C0001 start--
            IF show = 'N' THEN
                 CALL cl_close_progress_bar()
            END IF
            #NO.MOD-5C0001 END--
           RETURN              #MOD-4C0119
       END IF
     #NO.---FUN-5C0001 START--
     IF show = 'N' THEN
          IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才呼
                  CALL cl_progressing(" ")
                  LET l_count = l_count + 1
             END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
     END IF
     #NO.---FUN-5C0001 END----
     END FOREACH
     #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
    #No.FUN-710025--End--
 
    #No.+062 010411 by plum
     IF STATUS THEN
     #No.FUN-710025--Begin--
     #   CALL cl_err('foreach p610_curs1:',STATUS,1)
         CALL s_errmsg('','','foreach p610_curs1:',STATUS,1)
     #No.FUN-710025--End--
         LET g_success = 'N' #MOD-4C0119
         RETURN              #MOD-4C0119
     END IF
    #No.+062..end
    #更新最後一筆img_file
     SELECT SUM(img10*img21) INTO bal26 FROM img_file
     #---------------No.MOD-740015 modify
     #WHERE img01 = g_item_t AND img23 = 'Y' AND img24 = 'Y'
      WHERE img01 = g_item_t AND img24 = 'Y'
     #---------------No.MOD-740015 end
     SELECT SUM(img10*img21) INTO bal261 FROM img_file
      WHERE img01 = g_item_t AND img23 = 'N'
     SELECT SUM(img10*img21) INTO bal262 FROM img_file
      WHERE img01 = g_item_t AND img23 = 'Y'
     IF bal26  IS NULL THEN LET bal26  = 0 END IF
     IF bal261 IS NULL THEN LET bal261 = 0 END IF
     IF bal262 IS NULL THEN LET bal262 = 0 END IF

#No.FUN-A20044 ---mark---start
#     IF NOT cl_null(g_item_t) THEN
#          UPDATE ima_file SET 
#                 ima26=bal26,ima261=bal261,ima262=bal262
#      WHERE ima01 = g_item_t
#        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
##           CALL cl_err('upd ima:',SQLCA.SQLCODE,1)
#           CALL cl_err3("upd","ima_file",g_item_t,"",STATUS,"","upd ima",1)   #NO.FUN-640266
#            LET g_success = 'N' #MOD-4C0119
#            RETURN              #MOD-4C0119
#        END IF
         LET g_etime=TIME   #MOD-B90208 remark
#     END IF
#No.FUN-A20044 ---mark----end 

 #No.MOD-580322--begin                                                          
     LET g_msg = cl_getmsg('aim-994',g_lang),g_stime,'  ',cl_getmsg('aim-992',g_lang),g_etime
     #NO.FUN-570122  ---Start---
     IF g_bgjob = 'N' THEN
         MESSAGE g_msg                                                              
    END IF 
END FUNCTION
 
FUNCTION p610_imgg()
   DEFINE l_flag   LIKE imgg_file.imgg00
   DEFINE lsb_wc   base.StringBuffer
   DEFINE ls_wc    STRING
   DEFINE l_ima906 LIKE ima_file.ima906
   DEFINE l_bal    LIKE imgg_file.imgg10
   DEFINE l_tlff10 LIKE tlff_file.tlff10  #MOD-590345
   DEFINE l_piaa01 LIKE piaa_file.piaa01  #No:CHI-870048 add
   DEFINE l_piaa30 LIKE piaa_file.piaa30  #No:CHI-870048 add
   DEFINE l_piaa50 LIKE piaa_file.piaa50  #No:CHI-870048 add
   DEFINE l_tlff   RECORD LIKE tlff_file.*
   DEFINE l_rowid  LIKE type_file.row_id  #chr18   FUN-A70120
   DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
   DEFINE l_name   LIKE type_file.chr20   #No.FUN-690026 VARCHAR(20)
   DEFINE sr       RECORD
                   imgg01   LIKE imgg_file.imgg01,
                   imgg02   LIKE imgg_file.imgg02,
                   imgg03   LIKE imgg_file.imgg03,
                   imgg04   LIKE imgg_file.imgg04,
                   imgg09   LIKE imgg_file.imgg09,
                   imkk09   LIKE imkk_file.imkk09
                   END RECORD
 
     #IF g_sma.sma115 = 'N' THEN RETURN END IF   #No.FUN-540025
     LET ls_wc=g_wc CLIPPED
     LET lsb_wc=base.StringBuffer.create()
     CALL lsb_wc.append(ls_wc.trim())
     CALL lsb_wc.replace("img","imgg",0)
     LET ls_wc=lsb_wc.toString()
 
     CALL cl_outnam('acop610') RETURNING l_name
     START REPORT p610_rep TO l_name

     #FUN-CB0121---begin
     LET l_sql=" SELECT rowid,tlff_file.* FROM tlff_file ",
               "  WHERE tlff01 = ? ",
               "    AND tlff902 = ? ",
               "    AND tlff903 = ? ",
               "    AND tlff904 = ? ",
               "    AND tlff11 = ? ",
               "    AND tlff06  > ? ",
               "    AND tlff907 <> 0 ",
               "  ORDER BY tlff06,tlff08 "
     DECLARE p610_imgg_2 CURSOR FROM l_sql

     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','declare p610_imgg_2',SQLCA.sqlcode,1)
        LET g_success='N' RETURN
     END IF

     LET l_sql = " UPDATE tlff_file SET tlff02 = ? ,  tlff021 = ? , tlff022 = ? ,",
                 "                      tlff023 = ? , tlff026 = ? , tlff03 = ? ,",
                 "                      tlff031 = ? , tlff032 = ? , tlff033 = ? ,",
                 "                      tlff036 = ? , tlff10 = ? , tlff12 = ? ,",
                 "                      tlff907 = ? ",
                 "  WHERE rowid = ? "            
     PREPARE upd_tlff FROM l_sql

     LET l_sql = " UPDATE piaa_file SET piaa08=? WHERE piaa01=? AND piaa09=? "
     PREPARE upd_piaa FROM l_sql
      
     LET l_sql = " UPDATE imgg_file SET imgg10=? ",
                 "  WHERE imgg01=? AND imgg02=? ",
                 "    AND imgg03=? AND imgg04=? ",
                 "    AND imgg09=? "
     PREPARE upd_imgg FROM l_sql
     #FUN-CB0121---end
 
     LET l_sql="SELECT imgg01,imgg02,imgg03,imgg04,imgg09,imkk_file.imkk09",
               "  FROM imgg_file,ima_file, OUTER imkk_file ",
               " WHERE ",ls_wc.trim(),
               "   AND imgg01=ima01  AND imgg_file.imgg01=imkk_file.imkk01 ",
               "   AND imgg_file.imgg02=imkk_file.imkk02 AND imgg_file.imgg03=imkk_file.imkk03 ",
               "   AND imgg_file.imgg04=imkk_file.imkk04 AND imgg_file.imgg09=imkk_file.imkk10 ",
               "   AND imkk_file.imkk05=",g_yy,
               "   AND imkk_file.imkk06=",g_mm,
               "   AND ima906 <> '1'",
               " ORDER BY imgg01,imgg02,imgg03,imgg04,imgg09"
 
     PREPARE aimp610_imgg_1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prep imgg_1:',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE aimp610_imgg_curs1 CURSOR FOR aimp610_imgg_1  
     IF STATUS THEN
        CALL cl_err('declare p610_imgg_curs1:',STATUS,1)
        LET g_success = 'N'
        RETURN            
     END IF
 
     FOREACH aimp610_imgg_curs1 INTO sr.*
        IF STATUS THEN
           CALL s_errmsg('','','foreach imgg_1:',STATUS,1)
           LET g_success = 'N'
           RETURN
        END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
        SELECT ima906 INTO l_ima906 FROM ima_file
         WHERE ima01=sr.imgg01
        IF l_ima906 = '1' THEN CONTINUE FOREACH END IF
        IF cl_null(l_ima906) THEN
           LET g_msg=cl_getmsg('aim-996',g_lang)
           OUTPUT TO REPORT p610_rep(sr.imgg01,g_msg)
           CONTINUE FOREACH
        END IF
        IF cl_null(sr.imkk09) THEN LET sr.imkk09=0 END IF
        LET l_bal=sr.imkk09
        #FUN-CB0121---begin
        #DECLARE p610_imgg_2 CURSOR FOR
        #  SELECT rowid,tlff_file.* FROM tlff_file
        #   WHERE tlff01  = sr.imgg01
        #     AND tlff902 = sr.imgg02
        #     AND tlff903 = sr.imgg03
        #     AND tlff904 = sr.imgg04
        #    #-------No.TQC-690064 modify
        #    #AND tlff220 = sr.imgg09
        #     AND tlff11 = sr.imgg09
        #    #-------No.TQC-690064 end
        #     AND tlff06  > g_date
        #     AND tlff907 <> 0
        #   ORDER BY tlff06,tlff08
        #IF SQLCA.sqlcode THEN
        #   CALL s_errmsg('','','declare p610_imgg_2',SQLCA.sqlcode,1)
        #   LET g_success='N' RETURN
        #END IF
        #FUN-CB0121---end
 
        #FOREACH p610_imgg_2 INTO l_rowid,l_tlff.*  #FUN-CB0121
        FOREACH p610_imgg_2 USING sr.imgg01,sr.imgg02,sr.imgg03,sr.imgg04,sr.imgg09,g_date INTO l_rowid,l_tlff.*  #FUN-CB0121
           IF STATUS THEN
              CALL s_errmsg('','','foreach imgg_2:',STATUS,1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           IF l_tlff.tlff10 IS NULL THEN LET l_tlff.tlff10=0 END IF
           IF l_tlff.tlff12 IS NULL OR l_tlff.tlff12=0 THEN
              LET l_tlff.tlff12=1
           END IF
       #---------------------------No:CHI-870048 add------------------------------
        IF g_argv0 = '2' THEN
           IF l_tlff.tlff13='aimp880' THEN
               LET l_piaa30=NULL 
               LET l_piaa50=NULL 
               SELECT piaa01,piaa30,piaa50 INTO l_piaa01,l_piaa30,l_piaa50 FROM piaa_file 
               WHERE piaa02=sr.imgg01 AND piaa03=sr.imgg02
                 AND piaa04=sr.imgg03 AND piaa05=sr.imgg04
                 AND piaa09=sr.imgg09
                 AND (piaa01=l_tlff.tlff026 OR piaa01=l_tlff.tlff036)
              IF STATUS THEN
                 IF l_tlff.tlff024 IS NOT NULL AND l_tlff.tlff024 != 0
                    THEN LET l_piaa30=l_tlff.tlff024
                    ELSE LET l_piaa30=l_tlff.tlff034
                 END IF
              ELSE
                  IF NOT cl_null(l_piaa50) THEN LET l_piaa30 = l_piaa50 END IF 
              END IF
              IF l_piaa30 IS NULL THEN LET l_piaa30=0 END IF
              LET l_tlff.tlff10=l_bal-l_piaa30
              IF l_tlff.tlff10 >0 THEN
                  #出庫(盤虧)
                  LET l_tlff.tlff02=50 LET l_tlff.tlff021=sr.imgg02
                                       LET l_tlff.tlff022=sr.imgg03
                                       LET l_tlff.tlff023=sr.imgg04
                                       LET l_tlff.tlff026=l_piaa01      
                  LET l_tlff.tlff03=0  LET l_tlff.tlff031=NULL
                                       LET l_tlff.tlff032=NULL
                                       LET l_tlff.tlff033=NULL
                                       LET l_tlff.tlff036='Physical'   
                  LET l_tlff.tlff907=-1
              END IF
              IF l_tlff.tlff10 <0 THEN
                  #入庫(盤盈)
                  LET l_tlff.tlff10 = l_tlff.tlff10 *(-1) #讓tlf10的值變成正
                  LET l_tlff.tlff02= 0 LET l_tlff.tlff021=NULL
                                       LET l_tlff.tlff022=NULL
                                       LET l_tlff.tlff023=NULL
                                       LET l_tlff.tlff026='Physical'    
                  LET l_tlff.tlff03=50 LET l_tlff.tlff031=sr.imgg02
                                       LET l_tlff.tlff032=sr.imgg03
                                       LET l_tlff.tlff033=sr.imgg04
                                       LET l_tlff.tlff036=l_piaa01
                  LET l_tlff.tlff907=1
              END IF
 
              #UPDATE tlff_file SET *=l_tlff.* WHERE ROWID=l_rowid  #FUN-CB0121
              EXECUTE upd_tlff USING l_tlff.tlff02,l_tlff.tlff021,l_tlff.tlff022,l_tlff.tlff023,l_tlff.tlff026,l_tlff.tlff03,l_tlff.tlff031,  #FUN-CB0121
                                     l_tlff.tlff032,l_tlff.tlff033,l_tlff.tlff036,l_tlff.tlff10,l_tlff.tlff12,l_tlff.tlff907,l_rowid   #FUN-CB0121
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('ROWID',l_rowid,'upd tlff:',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  RETURN             
              END IF
              LET l_bal = s_digqty(l_bal,sr.imgg09)   #No.FUN-BB0086
              #UPDATE piaa_file SET piaa08=l_bal WHERE piaa01=l_tlff.tlff905  #FUN-CB0121
              #                                    AND piaa09=sr.imgg09       #FUN-CB0121
              EXECUTE upd_piaa USING l_bal,l_tlff.tlff905,sr.imgg09           #FUN-CB0121
              IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('piaa01',l_tlff.tlff905,'upd piaa:',SQLCA.SQLCODE,1)
                  LET g_success = 'N' 
                  RETURN     
              END IF
           END IF
        END IF
       #-----------------------------No:CHI-870048 end----------------------------
           IF l_tlff.tlff031=sr.imgg02 AND l_tlff.tlff032=sr.imgg03 AND
              l_tlff.tlff033=sr.imgg04 AND l_tlff.tlff13 != 'apmt1071'
              THEN LET l_tlff.tlff10  = l_tlff.tlff10 *  1
              ELSE LET l_tlff.tlff10  = l_tlff.tlff10 * -1
           END IF
 
       #-------MOD-590345 add
           LET l_tlff10 =  l_tlff.tlff10{*l_tlff.tlff12}
           #LET l_bal = l_bal + l_tlff.tlff10{*l_tlff.tlff12}
           LET l_bal = l_bal + l_tlff10
       #--------MOD-590345 end
 
        END FOREACH
        IF cl_null(l_bal) THEN LET l_bal=0 END IF
        #FUN-CB0121---begin
        #UPDATE imgg_file SET imgg10=l_bal
        # WHERE imgg01=sr.imgg01 AND imgg02=sr.imgg02
        #   AND imgg03=sr.imgg03 AND imgg04=sr.imgg04
        #   AND imgg09=sr.imgg09
        #FUN-CB0121---end   
        EXECUTE upd_imgg USING l_bal,sr.imgg01,sr.imgg02,sr.imgg03,sr.imgg04,sr.imgg09  #FUN-CB0121   
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('upd imgg:',SQLCA.SQLCODE,1)
        #No.FUN-710025--Begin--
        #  CALL cl_err3("upd","imgg_file",sr.imgg01,sr.imgg02,STATUS,"","upd imgg",1)   #NO.FUN-640266
           LET g_showmsg = sr.imgg01,"/",sr.imgg02,"/",sr.imgg03,"/",sr.imgg04,"/",sr.imgg09
           CALL s_errmsg('imgg01,imgg02,imgg03,imgg04,imgg09',g_showmsg,'upd imgg:',SQLCA.SQLCODE,1)
           LET g_success = 'N'
        #  RETURN
           CONTINUE FOREACH
        #No.FUN-710025--End--
        END IF
     END FOREACH
#No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
#No.FUN-710025--End--
 
     FINISH REPORT p610_rep
END FUNCTION
 
REPORT p610_rep(p_item,p_msg)
  DEFINE p_item      LIKE ima_file.ima01
  DEFINE p_msg       LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
  DEFINE l_ima02     LIKE ima_file.ima02
  DEFINE l_ima021    LIKE ima_file.ima021
  DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
  ORDER EXTERNAL BY p_item
  FORMAT
   PAGE HEADER
      PRINT g_x[31],g_x[32],g_x[33],g_x[34]
      PRINT g_dash1
      LET l_last_sw ='n'
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
       WHERE ima01=p_item
      PRINT COLUMN g_c[31],p_item;
      PRINT COLUMN g_c[32],p_msg
{
   ON LAST ROW
       PRINT g_dash[1,g_len] CLIPPED
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
}
END REPORT
#FUN-540025  --end
 
#-----No.FUN-810036-----
FUNCTION p610_imgs()
   DEFINE l_ima918 LIKE ima_file.ima918
   DEFINE l_ima921 LIKE ima_file.ima921
   DEFINE l_bal    LIKE imgs_file.imgs08
   DEFINE l_tlfs13 LIKE tlfs_file.tlfs13
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_sql    LIKE type_file.chr1000
   DEFINE sr       RECORD
                   imgs01   LIKE imgs_file.imgs01,
                   imgs02   LIKE imgs_file.imgs02,
                   imgs03   LIKE imgs_file.imgs03,
                   imgs04   LIKE imgs_file.imgs04,
                   imgs05   LIKE imgs_file.imgs05,
                   imgs06   LIKE imgs_file.imgs06,
                   imgs11   LIKE imgs_file.imgs11,
                   imks09   LIKE imks_file.imks09
                   END RECORD
   DEFINE l_pias30 LIKE pias_file.pias30  #CHI-C40027
   DEFINE l_pias50 LIKE pias_file.pias50  #CHI-C40027
   DEFINE l_rowid  LIKE type_file.row_id  #CHI-C40027

   #FUN-CB0121---begin
   LET l_sql=" SELECT ROWID,tlfs_file.* FROM tlfs_file ",
             "  WHERE tlfs01 = ? ",
             "    AND tlfs02 = ? ",
             "    AND tlfs03 = ? ",
             "    AND tlfs04 = ? ",
             "    AND tlfs05 = ? ",
             "    AND tlfs06 = ? ",
             "    AND tlfs15 = ? ",
             "    AND tlfs111 = ? ",
             "    AND tlfs09 <> 0 ",
             "  ORDER BY tlfs111 "
   DECLARE p610_imgs_2 CURSOR FROM l_sql 
   
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','declare p610_imgs_2',SQLCA.sqlcode,1)
      LET g_success='N' RETURN
   END IF

   LET l_sql = " UPDATE tlfs_file SET tlfs13 = ? , tlfs09 = ? ",
               "  WHERE rowid = ? "            
   PREPARE upd_tlfs FROM l_sql

   LET l_sql = " UPDATE pias_file SET pias09=? WHERE pias01=? AND pias06=? AND pias07=? "
   PREPARE upd_pias FROM l_sql
   
   LET l_sql = " UPDATE imgs_file SET imgs08=? ",
               "  WHERE imgs01=? AND imgs02=? ",
               "    AND imgs03=? AND imgs04=? ",
               "    AND imgs05=? AND imgs06=? ",
               "    AND imgs11=?  "
   PREPARE upd_imgs FROM l_sql
   #FUN-CB0121---end
   
   LET l_sql="SELECT imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
             "       imgs11,imks_file.imks09",
            #MOD-A90133 mod --start--
            #"  FROM imgs_file,ima_file, OUTER imks_file ",
#TQC-A60046 --Begin
#            " WHERE imgs01=ima01  AND imgs01=imks_file.imks01 ",
#            "   AND imgs02=imks_file.imks02 AND imgs03=imks_file.imks03 ",
#            "   AND imgs04=imks_file.imks04 AND imgs05=imks_file.imks10 ",
#            "   AND imgs06=imks_file.imks11 AND imgs11=imks_file.imks12 ",
            #" WHERE imgs01=ima01  AND imgs_file.imgs01=imks_file.imks01 ",
            #"   AND imgs_file.imgs02=imks_file.imks02 AND imgs_file.imgs03=imks_file.imks03 ",
            #"   AND imgs_file.imgs04=imks_file.imks04 AND imgs_file.imgs05=imks_file.imks10 ",
            #"   AND imgs_file.imgs06=imks_file.imks11 AND imgs_file.imgs11=imks_file.imks12 ",
#TQC-A60046 --End
            #"  FROM imgs_file,ima_file,img_file LEFT OUTER JOIN imks_file ON ",   #MOD-BA0050 mark
             "  FROM img_file,ima_file,imgs_file LEFT OUTER JOIN imks_file ON ",   #MOD-BA0050
             "       imgs01=imks_file.imks01 ",
             "   AND imgs02=imks_file.imks02 AND imgs03=imks_file.imks03 ",
             "   AND imgs04=imks_file.imks04 AND imgs05=imks_file.imks10 ",
             "   AND imgs06=imks_file.imks11 AND imgs11=imks_file.imks12 ",
             " WHERE ",g_wc CLIPPED,
             "   AND img01 = ima01 ",
             "   AND img02 = imgs02 ",
             "   AND img03 = imgs03 ",
             "   AND img04 = imgs04 ",
             "   AND imgs01=ima01 ",
            #MOD-A90133 mod --end--
             "   AND imks_file.imks05=",g_yy,
             "   AND imks_file.imks06=",g_mm,
             "   AND (ima918='Y' OR ima921='Y')",
             " ORDER BY imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,imgs11"
 
   PREPARE aimp610_imgs_1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prep imgs_1:',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE aimp610_imgs_curs1 CURSOR FOR aimp610_imgs_1  
   IF STATUS THEN
      CALL cl_err('DECLARE p610_imgs_curs1:',STATUS,1)
      LET g_success = 'N'
      RETURN            
   END IF
 
   FOREACH aimp610_imgs_curs1 INTO sr.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach imgs_1:',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      IF g_success='N' THEN                                                                                                        
         LET g_totsuccess='N'                                                                                                      
         LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
 
      IF cl_null(sr.imks09) THEN
         LET sr.imks09 = 0
      END IF
 
      LET l_bal = sr.imks09
      #FUN-CB0121---begin
      #DECLARE p610_imgs_2 CURSOR FOR
      #  SELECT tlfs_file.* FROM tlfs_file
      #   WHERE tlfs01 = sr.imgs01
      #     AND tlfs02 = sr.imgs02
      #     AND tlfs03 = sr.imgs03
      #     AND tlfs04 = sr.imgs04
      #     AND tlfs05 = sr.imgs05
      #     AND tlfs06 = sr.imgs06
      #     AND tlfs15 = sr.imgs11   #MOD-920340 
      #    #AND tlfs11 = sr.imgs11   #MOD-920340 mark
      #     AND tlfs111 > g_date     #TQC-920086
      #    #AND tlfs12 > g_date      #TQC-920086 mark 
      #     AND tlfs09 <> 0
      #   ORDER BY tlfs111           #TQC-920086
      #  #ORDER BY tlfs12            #TQC-920086 mark 
      #
      #IF SQLCA.sqlcode THEN
      #   CALL s_errmsg('','','declare p610_imgs_2',SQLCA.sqlcode,1)
      #   LET g_success='N' RETURN
      #END IF
      #FUN-CB0121---end
      #FOREACH p610_imgs_2 INTO l_tlfs.*  #FUN-CB0121
      FOREACH p610_imgs_2 USING sr.imgs01,sr.imgs02,sr.imgs03,sr.imgs04,sr.imgs05,sr.imgs06,sr.imgs11,g_date INTO l_rowid,l_tlfs.*  #FUN-CB0121
         IF STATUS THEN
            CALL s_errmsg('','','foreach imgs_2:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         IF l_tlfs.tlfs13 IS NULL THEN
            LET l_tlfs.tlfs13=0
         END IF

#CHI-C40027---begin
         IF g_argv0 = '2' THEN
            IF l_tlfs.tlfs08='aimp880' THEN
               LET l_pias30=NULL 
               LET l_pias50=NULL 
               SELECT pias30,pias50 INTO l_pias30,l_pias50 FROM pias_file 
               WHERE pias01=l_tlfs.tlfs10
                 AND pias06=l_tlfs.tlfs05
                 AND pias07=l_tlfs.tlfs06
               IF STATUS THEN

               ELSE
                  IF NOT cl_null(l_pias50) THEN LET l_pias30 = l_pias50 END IF 
                
                  IF l_pias30 IS NULL THEN LET l_pias30=0 END IF
                  LET l_tlfs.tlfs13=l_bal-l_pias30
              
                  IF l_tlfs.tlfs13 >0 THEN
                     #出庫(盤虧)
                     LET l_tlfs.tlfs09 = -1
                  END IF
                  IF l_tlfs.tlfs13 <0 THEN
                     #入庫(盤盈)
                     LET l_tlfs.tlfs13 = l_tlfs.tlfs13 *(-1) #讓tlf10的值變成正
                     LET l_tlfs.tlfs09 = 1
                  END IF
 
                  #UPDATE tlfs_file SET *=l_tlfs.* WHERE ROWID=l_rowid  #FUN-CB0121
                  EXECUTE upd_tlfs USING l_tlfs.tlfs13,l_tlfs.tlfs09,l_rowid  #FUN-CB0121
                  IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                     CALL s_errmsg('ROWID',l_rowid,'upd tlfs:',SQLCA.SQLCODE,1)
                     LET g_success = 'N'
                     RETURN             
                  END IF
               
               
                  #UPDATE pias_file SET pias09=l_bal WHERE pias01=l_tlfs.tlfs10  #FUN-CB0121
                  #                                    AND pias06=l_tlfs.tlfs05  #FUN-CB0121
                  #                                    AND pias07=l_tlfs.tlfs06  #FUN-CB0121
                  EXECUTE upd_pias USING l_bal,l_tlfs.tlfs10,l_tlfs.tlfs05,l_tlfs.tlfs06  #FUN-CB0121
                  IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                     CALL s_errmsg('pias01',l_tlfs.tlfs10,'upd pias:',SQLCA.SQLCODE,1)
                     LET g_success = 'N' 
                     RETURN     
                  END IF
               END IF
            END IF
         END IF
#CHI-C40027---end 
 
         LET l_tlfs.tlfs13  = l_tlfs.tlfs13 * l_tlfs.tlfs09
 
         LET l_bal = l_bal + l_tlfs.tlfs13
 
      END FOREACH
 
      IF cl_null(l_bal) THEN LET l_bal=0 END IF
 
      UPDATE imgs_file SET imgs08=l_bal
       WHERE imgs01=sr.imgs01
         AND imgs02=sr.imgs02
         AND imgs03=sr.imgs03
         AND imgs04=sr.imgs04
         AND imgs05=sr.imgs05
         AND imgs06=sr.imgs06
         AND imgs11=sr.imgs11
 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = sr.imgs01,"/",sr.imgs02,"/",sr.imgs03,"/",sr.imgs04,"/",sr.imgs05,"/",sr.imgs06,"/",sr.imgs11
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,imgs11',g_showmsg,'upd imgs:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
   END FOREACH
 
   IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
END FUNCTION
#-----No.FUN-810036 END-----
#FUN-CA0151---begin
FUNCTION p610_idc()
   DEFINE l_bal    LIKE idc_file.idc08
   DEFINE l_idd   RECORD LIKE idd_file.*
   DEFINE l_sql    LIKE type_file.chr1000
   DEFINE sr       RECORD
                   idc01   LIKE idc_file.idc01,
                   idc02   LIKE idc_file.idc02,
                   idc03   LIKE idc_file.idc03,
                   idc04   LIKE idc_file.idc04,
                   idc05   LIKE idc_file.idc05,
                   idc06   LIKE idc_file.idc06,
                   idx09   LIKE idx_file.idx09
                   END RECORD
   #FUN-CB0121---begin
   LET l_sql=" SELECT idd12,idd13 FROM idd_file ",
             "  WHERE idd01 = ? ",
             "    AND idd02 = ? ",
             "    AND idd03 = ? ",
             "    AND idd04 = ? ",
             "    AND idd05 = ? ",
             "    AND idd06 = ? ",
             "    AND idd08 > ? ",
             "    AND idd12 IN ('-1','1','5','6') ",
             "  ORDER BY idd08 "
   DECLARE p610_idc_2 CURSOR FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','declare p610_idc_2',SQLCA.sqlcode,1)
      LET g_success='N' RETURN
   END IF

   LET l_sql=" UPDATE idc_file SET idc08=? ",
             "  WHERE idc01=? ",
             "    AND idc02=? ",
             "    AND idc03=? ",
             "    AND idc04=? ",
             "    AND idc05=? ",
             "    AND idc06=? "
   PREPARE upd_idc FROM l_sql
   #FUN-CB0121---end
   
   LET l_sql="SELECT idc01,idc02,idc03,idc04,idc05,idc06,",
             "       idx09",
             "  FROM img_file,ima_file,idc_file LEFT OUTER JOIN idx_file ON ", 
             "       idc01=idx01 ",
             "   AND idc02=idx02 AND idc03=idx03 ",
             "   AND idc04=idx04 AND idc05=idx10 ",
             "   AND idc06=idx11 ",
             " WHERE ",g_wc CLIPPED,
             "   AND img01 = ima01 ",
             "   AND img02 = idc02 ",
             "   AND img03 = idc03 ",
             "   AND img04 = idc04 ",
             "   AND idc01=ima01 ",
             "   AND idx05=",g_yy,
             "   AND idx06=",g_mm,
             " ORDER BY idc01,idc02,idc03,idc04,idc05,idc06"
 
   PREPARE aimp610_idc_1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prep idc_1:',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE aimp610_idc_curs1 CURSOR FOR aimp610_idc_1  
   IF STATUS THEN
      CALL cl_err('DECLARE p610_idc_curs1:',STATUS,1)
      LET g_success = 'N'
      RETURN            
   END IF
 
   FOREACH aimp610_idc_curs1 INTO sr.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach idc_1:',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      IF g_success='N' THEN                                                                                                        
         LET g_totsuccess='N'                                                                                                      
         LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
 
      IF cl_null(sr.idx09) THEN
         LET sr.idx09 = 0
      END IF
 
      LET l_bal = sr.idx09
      #FUN-CB0121---begin
      #DECLARE p610_idc_2 CURSOR FOR
      #  SELECT idd_file.* FROM idd_file
      #   WHERE idd01 = sr.idc01
      #     AND idd02 = sr.idc02
      #     AND idd03 = sr.idc03
      #     AND idd04 = sr.idc04
      #     AND idd05 = sr.idc05
      #     AND idd06 = sr.idc06
      #     AND idd08 > g_date     
      #     AND idd12 IN ('-1','1','5','6')
      #   ORDER BY idd08  
      #
      #IF SQLCA.sqlcode THEN
      #   CALL s_errmsg('','','declare p610_idc_2',SQLCA.sqlcode,1)
      #   LET g_success='N' RETURN
      #END IF
      #
      #FOREACH p610_idc_2 INTO l_idd.*
      #FUN-CB0121---end
      FOREACH p610_idc_2 USING sr.idc01,sr.idc02,sr.idc03,sr.idc04,sr.idc05,sr.idc06,g_date INTO l_idd.idd12,l_idd.idd13   #FUN-CB0121
         IF STATUS THEN
            CALL s_errmsg('','','foreach idc_2:',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
 
         IF l_idd.idd13 IS NULL THEN
            LET l_idd.idd13=0
         END IF
         
         IF l_idd.idd12 = '-1' OR l_idd.idd12 = '5' THEN 
            LET l_idd.idd13  = l_idd.idd13 * -1
         END IF
 
         LET l_bal = l_bal + l_idd.idd13
 
      END FOREACH
 
      IF cl_null(l_bal) THEN LET l_bal=0 END IF
      #FUN-CB0121---begin
      #UPDATE idc_file SET idc08=l_bal
      # WHERE idc01=sr.idc01
      #   AND idc02=sr.idc02
      #   AND idc03=sr.idc03
      #   AND idc04=sr.idc04
      #   AND idc05=sr.idc05
      #   AND idc06=sr.idc06
      #FUN-CB0121---end
      EXECUTE upd_idc USING l_bal,sr.idc01,sr.idc02,sr.idc03,sr.idc04,sr.idc05,sr.idc06  #FUN-CB0121
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = sr.idc01,"/",sr.idc02,"/",sr.idc03,"/",sr.idc04,"/",sr.idc05,"/",sr.idc06
         CALL s_errmsg('idc01,idc02,idc03,idc04,idc05,idc06',g_showmsg,'upd idc:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
   END FOREACH
 
   IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
END FUNCTION
#FUN-CA0151---end
 
