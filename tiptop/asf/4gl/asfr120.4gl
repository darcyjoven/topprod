# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr120.4gl
# Descriptions...: 預計停產料品狀況表
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580222 05/08/22 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-580214 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-610092 06/05/25 By Joe  增加庫存單位欄位
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0036 06/11/13 By rainy 停產要多判斷生效日(ima1401)
# Modify.........: No.FUN-750129 07/06/21 By Carrier 報表轉Crystal Report格式
# Modify.........: No.MOD-7C0231 08/03/04 By Pengu 調整533行在判斷array筆數是否大於允許最大筆數的程式段
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940139 09/04/23 By mike 701行where 條件里的tm.yy,tm.mm 并不存在，應該是g_yy,g_mm
# Modify.........: No.FUN-940083 09/05/14 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.CHI-B60093 11/06/30 By JoHung 畫面加上成本計算類別
#                                                   依成本計算類別取得該料的成本平均
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-CC0068 12/12/11 By qirl 增加規格顯示
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_a         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          g_b         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          g_yy,g_mm   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          g_type      LIKE type_file.chr1,          #CHI-B60093 add
          g_bmb03     LIKE bmb_file.bmb03,
#         g_totcost   LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
          g_totcost   LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044 
          g_bma DYNAMIC ARRAY OF RECORD
                cnt     LIKE type_file.num5,        #No.FUN-680121 SMALLINT
                bma01   LIKE bma_file.bma01,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021  #-TQC-CC0068--add-
                END RECORD,
          g_bma_t DYNAMIC ARRAY OF RECORD
                cnt     LIKE type_file.num5,        #No.FUN-680121 SMALLINT
                bma01   LIKE bma_file.bma01,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021  #-TQC-CC0068--add-
                END RECORD,
    g_bma_pageno    LIKE type_file.num5,          #No.FUN-680121 SMALLINT#目前單身頁數
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
#       l_time    LIKE type_file.chr8    	        #No.FUN-6A0090
    l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_count         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_chr1          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_chr2          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
    g_yld           LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
DEFINE   g_i        LIKE type_file.num5           #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE l_table      STRING  #No.FUN-750129
DEFINE g_str        STRING  #No.FUN-750129
DEFINE g_sql        STRING  #No.FUN-750129
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #No.FUN-750129  --Begin
   LET g_sql = " bmb03.bmb_file.bmb03,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ima25.ima_file.ima25,",
               " need.oeb_file.oeb12,",
               " supply.oeb_file.oeb12,",
#              " ima262.ima_file.ima262,",    #NO.FUN-A20044
               "avl_stk.type_file.num15_3,",  #NO.FUN-A20044
               " rem.oeb_file.oeb12,",
               " ccc23.ccc_file.ccc23,",
               " cost.ccc_file.ccc22,",
               " bma01_1.bma_file.bma01,",
               " no_1.oea_file.oea01,",
               " bma01_2.bma_file.bma01,",
               " no_2.oea_file.oea01,",
               " bma01_3.bma_file.bma01,",
               " no_3.oea_file.oea01"                               
   LET l_table = cl_prt_temptable('asfr120',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?  )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_type = ARG_VAL(7)     #CHI-B60093 add
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL asfr120_tm(4,10)                 # Input print condition
   ELSE
      CALL asfr120()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr120_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_za05         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(1100)
 
   LET p_row = 4 LET p_col = 25
   OPEN WINDOW asfr120_w AT p_row,p_col WITH FORM "asf/42f/asfr120"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_chr2 = ' '
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #CHI-B60093 add
   LET g_type = g_ccz.ccz28                                     #CHI-B60093 add

   WHILE TRUE
     #-->存放Phase out 的主件
      DROP TABLE r120_file
     #No.FUN-680121-BEGIN
       CREATE TEMP TABLE r120_file(
        bma01  LIKE type_file.chr1000);
      create unique index r120_02 on r120_file(bma01);
     #No.FUN-680121-END
      CALL r120_b()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF cl_sure(0,0) THEN CALL asfr120() END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW asfr120_w
 
END FUNCTION
 
FUNCTION r120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680121 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否        #No.FUN-680121 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_insert        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可新增否
    l_update        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可更改否 (含取消)
    l_possible      LIKE type_file.num5,          #No.FUN-680121 SMALLINT#用來設定判斷重複的可能性
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_pt            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_i,l_j,l_k     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_m             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    CALL g_bma.clear()
    CALL g_bma_t.clear()
    #-->輸入單頭
    LET g_a = 'Y' LET g_b = 'Y'
    LET g_yy = YEAR(g_today) LET g_mm = MONTH(g_today)
 
    WHILE TRUE
#     INPUT BY NAME g_a,g_b,g_yy,g_mm WITHOUT DEFAULTS          #CHI-B60093 mark
      INPUT BY NAME g_a,g_b,g_yy,g_mm,g_type WITHOUT DEFAULTS   #CHI-B60093
        ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         EXIT WHILE
      END IF
 
      WHILE TRUE
 
        #-->輸入單身
        CALL cl_opmsg('b')
        LET l_ac_t = 0
        LET g_rec_b = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bma WITHOUT DEFAULTS FROM s_bma.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_bma_t[l_ac].* = g_bma[l_ac].*          # 900423
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET p_cmd='a'  #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bma[l_ac].* TO NULL      #900423
            LET g_bma_t[l_ac].* = g_bma[l_ac].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt
 
        BEFORE FIELD cnt                          #default 項次
            IF g_bma[l_ac].cnt IS NULL OR g_bma[l_ac].cnt = 0 THEN
               LET l_pt = 'N'
               LET g_bma[l_ac].cnt = 1
               FOR l_i = 1 TO g_bma.getLength()
                   IF cl_null(g_bma[l_i].cnt)  OR l_i = l_ac THEN
                      CONTINUE FOR
                   ELSE
                      IF g_bma[l_i].cnt >= g_bma[l_ac].cnt THEN
                         LET g_bma[l_ac].cnt = g_bma[l_i].cnt
                         LET l_pt = 'Y'
                      END IF
                   END IF
               END FOR
               IF l_pt = 'Y' THEN
                  LET g_bma[l_ac].cnt = g_bma[l_ac].cnt + 1
               END IF
            END IF
 
        AFTER FIELD bma01
            #--->讀取品名規格
            SELECT ima02 INTO g_bma[l_ac].ima02 FROM ima_file
                            WHERE ima01 = g_bma[l_ac].bma01
            #---TQC-CC0068--add---star--
            SELECT ima021 INTO g_bma[l_ac].ima021 FROM ima_file
                            WHERE ima01 = g_bma[l_ac].bma01
            #---TQC-CC0068--add---end---
            IF SQLCA.sqlcode THEN
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               LET g_bma[l_ac].ima02 = g_bma_t[l_ac].ima02
               LET g_bma[l_ac].ima021 = g_bma_t[l_ac].ima021               #---TQC-CC0068--add
#              CALL cl_err('','mfg3403',0)   #No.FUN-660128
               CALL cl_err3("sel","ima_file",g_bma[l_ac].bma01,"","mfg3403","","",0)    #No.FUN-660128
               NEXT FIELD bma01
            END IF
            #--->檢查是否存在於BOM 單頭檔
            SELECT COUNT(*) INTO l_cnt FROM bma_file
                            WHERE bma01 = g_bma[l_ac].bma01
            IF l_cnt = 0 THEN
               CALL cl_err('','mfg3399',0)
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               NEXT FIELD bma01
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bma[l_ac].bma01 > 0 THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
            END IF
 
        AFTER ROW
            IF g_bma[l_ac].bma01 IS NULL THEN
               INITIALIZE g_bma[l_ac].* TO NULL
            END IF
 
        ON ACTION CONTROLO
           IF l_ac>1 THEN
              LET g_bma[l_ac].*=g_bma[l_ac-1].*
           END IF
 
        ON ACTION clear_detail
            CALL g_bma.clear()
            EXIT INPUT
 
#       ON ACTION CONTROLN
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bma01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_ima'
                   LET g_qryparam.default1 = g_bma[l_ac].bma01
                   CALL cl_create_qry() RETURNING g_bma[l_ac].bma01
#                   CALL FGL_DIALOG_SETBUFFER( g_bma[l_ac].bma01 )
                    DISPLAY BY NAME g_bma[l_ac].bma01      #No.MOD-490371
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
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
     END INPUT
 
     FOR l_m = 1 TO g_bma.getLength()
        IF g_bma[l_m].bma01 IS NULL THEN
           CONTINUE FOR
        END IF
        INSERT INTO r120_file VALUES(g_bma[l_m].bma01)
     END FOR
     EXIT WHILE
   END WHILE
   EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION r120_pre()
 DEFINE  l_cmd  LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1100)
 
     #-->存放where use  料號
      DROP TABLE r120_tmp
  #No.FUN-680121-BEGIN
#    CREATE TEMP TABLE r120_tmpi(  #No.FUN-750129
     CREATE TEMP TABLE r120_tmp(   #No.FUN-750129
        bmb03  LIKE type_file.chr1000,
        bma01  LIKE type_file.chr1000);
  #No.FUN-680121-END   
     create unique index r120_01 on r120_tmp(bmb03,bma01);
 
      LET l_cmd= "SELECT bmb03,bma01 FROM r120_tmp WHERE bmb03 = ? "
      PREPARE r120_pretmp  FROM l_cmd
      DECLARE r120_tempcur CURSOR for r120_pretmp
 
     #-->取當他人的取替代料
      LET l_cmd= "SELECT bmd08 FROM bmd_file ",
                 " WHERE bmd01= ? ",
                 "   AND bmdacti = 'Y'"                                           #CHI-910021
      PREPARE r120_prebmd FROM l_cmd
      DECLARE r120_bmdcur CURSOR for r120_prebmd
 
     #-->確定是否有上階料
      LET l_cmd= "SELECT COUNT(*) FROM bmb_file,ima_file",
                 " WHERE bmb03= ? AND bmb01 = ima01"
      PREPARE r120_prebmb FROM l_cmd
      DECLARE r120_bmbcur CURSOR for r120_prebmb
 
     #-->取PR 資料
      LET l_cmd= "SELECT pml01,pml02 FROM pml_file,pmk_file ",
                 " WHERE pmk01=pml01 AND pmk18!='X' ",
                 "   AND pml04 = ? ",
                 "   AND pml20 > pml21 AND pml16 <='2' ",
                 "   AND pml011 !='SUB'  "
      PREPARE r120_prepr  FROM l_cmd
      DECLARE r120_prcur CURSOR for r120_prepr
 
     #-->取PO 資料
      LET l_cmd= "SELECT pmn01,pmn02 FROM pmn_file,pmm_file ",
                 " WHERE pmm01=pmn01 AND pmm18!='X' ",
                 "   AND pmn04 = ? ",
                 "   AND pmn20 > pmn50 AND pmn16 <='2' ",
                 "   AND pmn011 !='SUB'   "
      PREPARE r120_prepo FROM l_cmd
      DECLARE r120_pocur CURSOR for r120_prepo
 
     #-->取WO 資料
      LET l_cmd= "SELECT sfb01 FROM sfb_file ",
                 " WHERE sfb05 = ? AND sfb04 <'8' ",
                 " AND sfb08 > (sfb09+sfb11+sfb12) AND sfb87!='X' "
      PREPARE r120_prewo FROM l_cmd
      DECLARE r120_wocur CURSOR for r120_prewo
END FUNCTION
 
FUNCTION asfr120()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
          l_i,l_j   LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_ima910   LIKE ima_file.ima910         #FUN-550112
#No.FUN-750129  --Begin
   DEFINE l_bmb03      LIKE bmb_file.bmb03,
          t_bmb03      LIKE bmb_file.bmb03,
          l_ccc23      LIKE ccc_file.ccc23,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima25      LIKE ima_file.ima25,          ##NO.FUN-610092
          l_ima53      LIKE ima_file.ima53,
          l_ima531     LIKE ima_file.ima531,
          g_use        DYNAMIC ARRAY OF RECORD
		       bma01  LIKE bma_file.bma01
                       END RECORD,
          g_supply     DYNAMIC ARRAY OF RECORD
		       no     LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(15)
                       END RECORD,
#         l_ima262     LIKE ima_file.ima262,    ###GP5.2  #NO.FUN-A20044
          l_avl_stk    LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
          l_seq,l_seq3 LIKE type_file.num5,          #No.FUN-680121 SMALLINT    
          l_mod,l_max,l_line LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_supply,l_prqty,l_poqty,l_woqty,l_iqcqty,l_fqcqty LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_oebqty,l_sfaqty LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_rem,l_need      LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_no         LIKE bmb_file.bmb03,             #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          l_item       LIKE type_file.num5,             #No.FUN-680121 SMALLINT
          l_cost       LIKE ccc_file.ccc22,
          l_n1         LIKE type_file.num15_3,          ###GP5.2  #NO.FUN-A20044
          l_n2         LIKE type_file.num15_3,          ###GP5.2  #NO.FUN-A20044
          l_n3         LIKE type_file.num15_3           ###GP5.2  #NO.FUN-A20044 

 
#No.FUN-750129  --End
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   CALL r120_pre()
   LET g_totcost = 0
   
   #No.FUN-750129  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   DROP TABLE asfr120_tmp;
   CREATE TEMP TABLE asfr120_tmp(
   bmb03  LIKE bmb_file.bmb03);
   #CALL cl_outnam('asfr120') RETURNING l_name
   #START REPORT asfr120_rep TO l_name
   #No.FUN-750129  --End
 
#No.CHI-6A0004--------Begin--------------
#      SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#        FROM azi_file
#       WHERE azi01=g_aza.aza17
#No.CHI-6A0004-------End----------------
      #--->展開下階資料
      FOR l_i = 1 TO g_bma.getLength()
         IF g_bma[l_i].bma01 IS NULL OR g_bma[l_i].bma01 = ' ' THEN
              CONTINUE FOR
         END IF
         #FUN-550112
         LET l_ima910=''
         SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=g_bma[l_i].bma01
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #--
         CALL r120_bom(0,g_bma[l_i].bma01,l_ima910)  #FUN-550112
      END FOR
   #No.FUN-750129  --Begin
   #FINISH REPORT asfr120_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    DECLARE asfr120_curs1 CURSOR FOR
     SELECT UNIQUE bmb03
       FROM asfr120_tmp      
    FOREACH asfr120_curs1 INTO t_bmb03
       IF STATUS THEN CALL cl_err('asfr120_curs1',STATUS,1) EXIT FOREACH END IF
       #-->取單價(1.成本 2.最近採購 3.市價)
#      SELECT ccc23 INTO l_ccc23 FROM ccc_file                         #CHI-B60093 mark
       SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_file                    #CHI-B60093
        WHERE ccc01 = t_bmb03 AND ccc02 = g_yy AND ccc03 = g_mm
#         AND ccc07 = '1'                              #No.FUN-840041  #CHI-B60093 mark
          AND ccc07 = g_type                                           #CHI-B60093
        GROUP BY ccc01                                                 #CHI-B60093
       IF SQLCA.sqlcode THEN LET l_ccc23 =0  END IF
       IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
       IF l_ccc23 = 0 THEN
          SELECT ima53,ima531 INTO l_ima53,l_ima531
            FROM ima_file WHERE ima01 = t_bmb03
          IF  cl_null(l_ima53) THEN LET l_ima53 =0 END IF
          IF  cl_null(l_ima531) THEN LET l_ima531 =0 END IF
          LET l_ccc23 = l_ima53
          IF l_ccc23 = 0 THEN LET l_ccc23 = l_ima531  END IF
       END IF
 
       CALL g_use.clear()
       CALL g_supply.clear()
       #-->取where use
       LET l_seq = 1
       FOREACH r120_tempcur USING t_bmb03 INTO l_bmb03,g_use[l_seq].bma01
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_tempcur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_seq = l_seq + 1
       END FOREACH
       IF l_seq > 1 THEN LET l_seq = l_seq - 1 END IF
 
       #-->取相關供給資料(pr/po/wo)
       LET l_seq3 = 1
       FOREACH r120_prcur USING t_bmb03 INTO l_no,l_item
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_prcur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no ,'-',l_item using '<<<'
         LET l_seq3 = l_seq3 + 1
       END FOREACH
 
       FOREACH r120_pocur USING t_bmb03 INTO l_no,l_item
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_pocur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no ,'-',l_item using '<<<'
         LET l_seq3 = l_seq3 + 1
       END FOREACH
 
       FOREACH r120_wocur USING t_bmb03 INTO l_no
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_wocur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no
         LET l_seq3 = l_seq3 + 1
       END FOREACH
       IF l_seq3 > 1 THEN LET l_seq3 = l_seq3 -1 END IF
 
       #-->總需求(訂單)
        SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO l_oebqty
          FROM oeb_file, oea_file
          WHERE oeb04 = t_bmb03 AND oeb01 = oea01 AND oea00<>'0'
           AND oeb70 = 'N' AND oeb12 > oeb24
           AND oeaconf != 'X' #01/08/08 mandy
        IF cl_null(l_oebqty) THEN LET l_oebqty =0 END IF
       #-->總需求(工單備料量)
        SELECT SUM((sfa05-sfa06)*sfa13) INTO l_sfaqty
          FROM sfb_file,sfa_file
          WHERE sfa03 = t_bmb03 AND sfb01 = sfa01
            AND sfb04 !='8' AND (sfa05 > sfa06) AND sfb87!='X'
        IF cl_null(l_sfaqty) THEN LET l_sfaqty =0 END IF
       #-->總需求(工單備料量)
        LET l_need = l_oebqty + l_sfaqty
 
       #-->總供給(請購量)
        SELECT SUM((pml20-pml21)*pml09) INTO l_prqty
          FROM pml_file, pmk_file
         WHERE pml04 = t_bmb03 AND pml01 = pmk01 AND pmk18 !='X'
           AND pml20 > pml21 AND pml16 <='2' AND pml011 !='SUB'
        IF cl_null(l_prqty) THEN LET l_prqty = 0 END IF
       #-->採購量
       #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO l_poqty #FUN-940083
        SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_poqty #FUN-940083  
          FROM pmn_file, pmm_file
         WHERE pmn04 = t_bmb03 AND pmn01 = pmm01 AND pmm18 !='X'
           AND pmn20 > pmn50 AND pmn16 <='2' AND pmn011 !='SUB'
        IF cl_null(l_poqty) THEN LET l_poqty = 0 END IF
       #-->工單在製量
        SELECT SUM(sfb08-sfb09-sfb10-sfb11-sfb12) INTO l_woqty
          FROM sfb_file
         WHERE sfb05 = t_bmb03 AND sfb04 <'8'
           AND sfb08 > (sfb09+sfb11+sfb12) AND sfb87!='X'
        IF cl_null(l_woqty) THEN LET l_woqty = 0 END IF
       #-->IQC 在驗量
        SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_iqcqty
          FROM rvb_file, rva_file, pmn_file
         WHERE rvb05 = t_bmb03 AND rvb01=rva01 AND rvaconf <> 'X'
           AND rvb04 = pmn01 AND rvb03 = pmn02
           AND rvb07 > (rvb29+rvb30)
           AND rvaconf='Y'
        IF cl_null(l_iqcqty) THEN LET l_iqcqty = 0 END IF
       #-->FQC 在驗量
        SELECT SUM(qcf22-qcf091) INTO l_fqcqty
          FROM qcf_file,sfb_file
         WHERE sfb05 = t_bmb03 AND sfb01=qcf02 AND qcf22 > 0
           AND qcf14 <> 'X' AND sfb87!='X'
        IF cl_null(l_fqcqty) THEN LET l_fqcqty = 0 END IF
 
       #-->總供給
        LET l_supply =l_prqty+l_poqty+l_woqty+l_iqcqty+l_fqcqty
 
#       SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01 = t_bmb03 #NO.FUN-A20044
        CALL s_getstock(t_bmb03,g_plant) RETURNING  l_n1,l_n2,l_n3    ###GP5.2  #NO.FUN-A20044  
        LET  l_avl_stk = l_n3                                           #NO.FUN-A20044
#       IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF               #NO.FUN-A20044
        IF cl_null(l_avl_stk) THEN  LET l_avl_stk = 0 END IF            #NO.FUN-A20044
#       LET l_rem  = (l_supply + l_ima262) - l_need                     #NO.FUN-A20044
        LET l_rem  = (l_supply + l_avl_stk) - l_need                    #NO.FUN-A20044
        LET l_cost = l_rem * l_ccc23
 
        LET l_ima02 = ''
        LET l_ima021= ''
        SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file ##NO.FUN-610092
         WHERE ima01 = t_bmb03
        
        IF l_seq > l_seq3 THEN
            LET l_max = l_seq ELSE LET l_max = l_seq3
        END IF
        LET l_mod =(l_max-3) MOD 3
        IF l_mod != 0 THEN
           LET l_line = ((l_max-3) / 3 ) + 1
        ELSE
           LET l_line = (l_max-3) /3
        END IF
        IF l_line > 0 THEN
           FOR l_i = 0 TO l_line
                LET l_j = l_i * 3 + 1
                EXECUTE insert_prep 
#                       USING t_bmb03,l_ima02,l_ima021,l_ima25,l_need,l_supply,l_ima262,l_rem,  #NO.FUN-A20044
                        USING t_bmb03,l_ima02,l_ima021,l_ima25,l_need,l_supply,l_avl_stk,l_rem, #NO.FUN-A20044       
                              l_ccc23,l_cost,g_use[l_j].bma01,g_supply[l_j].no,
                              g_use[l_j+1].bma01,g_supply[l_j+1].no,
                              g_use[l_j+2].bma01,g_supply[l_j+2].no
           END FOR
        ELSE
           EXECUTE insert_prep 
#                  USING t_bmb03,l_ima02,l_ima021,l_ima25,l_need,l_supply,l_ima262,l_rem,  #NO.FUN-A20044
                   USING t_bmb03,l_ima02,l_ima021,l_ima25,l_need,l_supply,l_avl_stk,l_rem, #NO.FUN-A20044
                         l_ccc23,l_cost,'','','','','',''
        END IF
       
   END FOREACH    
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = '',";",g_azi03,";",g_azi04,";",g_azi05
   CALL cl_prt_cs3('asfr120','asfr120',g_sql,g_str)
   #No.FUN-750129  --End
END FUNCTION
 
FUNCTION r120_bom(p_level,p_key,p_key2)  #FUN-550112
DEFINE p_level  LIKE type_file.num5,     #No.FUN-680121 SMALLINT#階層
       p_key    LIKE bma_file.bma01,     #料件
       p_key2	LIKE ima_file.ima910,    #FUN-550112
       sr DYNAMIC ARRAY OF RECORD
		bmb02  LIKE bmb_file.bmb02,              #項次
		bmb03  LIKE bmb_file.bmb03,              #元件
		bma01  LIKE bma_file.bma01,
                level  LIKE type_file.num5          #No.FUN-680121 SMALLINT
       END RECORD,
       l_ima53     LIKE ima_file.ima53,
       l_ima531    LIKE ima_file.ima531,
       l_ccc23     LIKE ccc_file.ccc23,
       b_seq       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       arrno       LIKE type_file.num10,         #No.FUN-680121 INTEGER
       l_tot,l_i   LIKE type_file.num10,         #No.FUN-680121 INTEGER
       l_times     LIKE type_file.num10,         #No.FUN-680121 INTEGER
       l_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
       l_total     LIKE sfa_file.sfa25
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno   = 600
    LET l_times = 1
    LET b_seq   = 0
    WHILE TRUE
        LET l_cmd=
    	   "SELECT bmb02,bmb03,bma01,0",
           "  FROM bmb_file,OUTER bma_file",
           " WHERE bmb01='", p_key,"' ",
           "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
           "   AND bmb02 > '",b_seq,"'",
           "   AND  bma_file.bma01 = bmb_file.bmb03  ",
           "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ",
           "   AND (bmb05 >'",g_today, "' OR bmb05 IS NULL)",
           " ORDER BY 1"
 
       PREPARE bom_pre FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
       DECLARE bom_cur CURSOR FOR bom_pre
 
       LET l_ac = 1
       FOREACH bom_cur INTO sr[l_ac].*
          IF SQLCA.sqlcode THEN
             CALL cl_err('bom_cur',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          #FUN-8B0035--BEGIN--
          LET l_ima910[l_ac]=''
          SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
          IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
          #FUN-8B0035--END--
          LET l_ac = l_ac + 1			# 但BUFFER不宜太大
          IF l_ac > arrno THEN EXIT FOREACH END IF
       END FOREACH
       LET l_tot=l_ac-1
       FOR l_i = 1 TO l_tot
           IF sr[l_i].bma01 IS NOT NULL AND sr[l_i].bma01 != ' ' THEN
               #CALL r120_bom(p_level,sr[l_i].bmb03,' ')  #FUN-550112 #FUN-8B0035
                CALL r120_bom(p_level,sr[l_i].bmb03,l_ima910[l_i])  #FUN-550112 #FUN-8B0035
           ELSE
              #-->取單價(1.成本 2.最近採購 3.市價)
              SELECT ccc23 INTO l_ccc23 FROM ccc_file
              #WHERE ccc01 = sr[l_i].bmb03 AND ccc02 = tm.yy AND ccc03 = tm.mm #TQC-940139 
               WHERE ccc01 = sr[l_i].bmb03 AND ccc02 = g_yy AND ccc03 = g_mm   #TQC-940139     
                 AND ccc07 = '1'                              #No.FUN-840041
               IF SQLCA.sqlcode THEN LET l_ccc23 =0  END IF
               IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
               IF l_ccc23 = 0 THEN
                  SELECT ima53,ima531 INTO l_ima53,l_ima531
                    FROM ima_file WHERE ima01 = sr[l_i].bmb03
                  IF  cl_null(l_ima53) THEN LET l_ima53 =0 END IF
                  IF  cl_null(l_ima531) THEN LET l_ima531 =0 END IF
                  LET l_ccc23 = l_ima53
                  IF l_ccc23 = 0 THEN LET l_ccc23 = l_ima531  END IF
               END IF
               CALL r120_usebom(0,sr[l_i].bmb03,' ')  #FUN-550112
               #No.FUN-750129  --Begin
               #OUTPUT TO REPORT asfr120_rep(sr[l_i].bmb03,l_ccc23)
               INSERT INTO asfr120_tmp VALUES(sr[l_i].bmb03)
               #No.FUN-750129  --End
           END IF
      END FOR
      # BOM單身已讀完
      IF l_tot < arrno OR l_tot=0 THEN
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_tot].bmb02
         LET l_times=l_times+1
      END IF
  END WHILE
END FUNCTION
 
FUNCTION r120_usebom(p_level,p_key,p_key2)            #FUN-550112
   DEFINE p_level	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_key		LIKE bma_file.bma01,          #元件料件編號
          p_key2	LIKE ima_file.ima910,         #FUN-550112
          l_bmd08       LIKE bmd_file.bmd08,
          l_ima140      LIKE ima_file.ima140,
          l_ima1401     LIKE ima_file.ima1401,        #FUN-6A0036停產生效日
          l_ac,i	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          arrno	        LIKE type_file.num5,          #No.FUN-680121 SMALLINT#BUFFER SIZE (可存筆數)
          b_seq		LIKE bmb_file.bmb02,          #滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt,l_count LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr DYNAMIC ARRAY OF RECORD        #每階存放資料
              bmb01 LIKE bmb_file.bmb01,    #主件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03     #元件料號
          END RECORD,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1100)
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
          
    END IF
    IF p_level = 0 THEN LET g_bmb03 = p_key END IF
    LET p_level = p_level + 1
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb01,bmb02,bmb03",
            " FROM bmb_file",
            " WHERE bmb03='", p_key,"' ",
            "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
            "   AND bmb02 >",b_seq,
            "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ",
            "   AND (bmb05  >'",g_today, "' OR bmb05 IS NULL)"
 
        PREPARE r120_preuse FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('r120_preuse',SQLCA.sqlcode,1)
        END IF
        DECLARE r120_use CURSOR for r120_preuse
        LET l_ac = 1
        FOREACH r120_use INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            IF SQLCA.sqlcode THEN
               CALL cl_err('r120_use',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF    #No.MOD-7C0231 modify
         END FOREACH
 
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            LET l_cnt = 0
            #-->找是否有上階料號,且階數未超過
            OPEN r120_bmbcur USING sr[i].bmb01
            FETCH r120_bmbcur INTO l_cnt
            IF l_cnt > 0 THEN
               CALL r120_usebom(p_level,sr[i].bmb01,' ')  #FUN-550112
            ELSE
               SELECT count(*) INTO l_count FROM r120_file
                WHERE bma01 = sr[i].bmb01
               IF cl_null(l_count) THEN LET l_count = 0 END IF
               IF l_count = 0 THEN
                  SELECT ima140,ima1401 INTO l_ima140,l_ima1401 FROM ima_file  #FUN-6A0036 add ima1401
                   WHERE ima01 = sr[i].bmb01
                  IF SQLCA.sqlcode THEN LET l_ima140 = 'N' END IF
                  IF cl_null(l_ima140) THEN LET l_ima140 = 'N' END IF
                  #IF g_a = 'N' AND l_ima140 = 'N' THEN      #FUN-6A0036
                  IF g_a = 'N' AND                           #FUN-6A0036
                    (l_ima140 = 'N'  OR (l_ima140='Y' AND l_ima1401 > g_today)) THEN   #FUN-6A0036
                     INSERT INTO r120_tmp VALUES(g_bmb03,sr[i].bmb01)
                  END IF
                  IF g_a = 'Y' THEN
                     INSERT INTO r120_tmp VALUES(g_bmb03,sr[i].bmb01)
                  END IF
               END IF
               #-->當他人的取替代料
                IF g_b = 'Y' THEN
                   FOREACH r120_bmdcur USING sr[i].bmb03 INTO l_bmd08
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('r120_bmdcur',SQLCA.sqlcode,0)
                        EXIT FOREACH
                     END IF
                     INSERT INTO r120_tmp VALUES(g_bmb03,l_bmd08)
                   END FOREACH
                END IF
            END IF
         END FOR
        IF (l_ac - 1) < arrno OR l_ac=1 THEN         # BOM單身已讀完 #No.MOD-7C0231 modify
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
#No.FUN-750129  --Begin
{ 
REPORT asfr120_rep(sr,l_ccc23)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_bmb03      LIKE bmb_file.bmb03,
          l_ccc23      LIKE ccc_file.ccc23,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima25      LIKE ima_file.ima25,          ##NO.FUN-610092
          l_str1       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
          l_str2       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
          sr RECORD
		bmb03  LIKE bmb_file.bmb03           #元件
           END RECORD,
          g_use DYNAMIC ARRAY OF RECORD
		bma01  LIKE bma_file.bma01
                END RECORD,
          g_supply DYNAMIC ARRAY OF RECORD
		no     LIKE oea_file.oea01           #No.FUN-680121 VARCHAR(15)
                END RECORD,
          l_ima262     LIKE ima_file.ima262,
          l_seq,l_seq2,l_seq3        LIKE type_file.num5,          #No.FUN-680121 SMALLINT    
          l_mod,l_max,l_i,l_j,l_line LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_supply,l_prqty,l_poqty,l_woqty,l_iqcqty,l_fqcqty LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_oebqty,l_sfaqty LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_rem,l_need      LIKE oeb_file.oeb12,        #No.FUN-680121 DEC(15,3)
          l_no         LIKE bmb_file.bmb03,             #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          l_item       LIKE type_file.num5,             #No.FUN-680121 SMALLINT
          l_cost       LIKE ccc_file.ccc22,
          l_cnt        LIKE type_file.num5              #No.FUN-680121 SMALLINT
 
   OUTPUT  TOP MARGIN g_top_margin
           LEFT MARGIN g_left_margin
           BOTTOM MARGIN g_bottom_margin
           PAGE LENGTH g_page_line
 
   ORDER BY sr.bmb03
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[42],  ##NO.FUN-610092
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   AFTER GROUP OF sr.bmb03
      CALL g_use.clear()
      CALL g_supply.clear()
      #-->取where use
       LET l_seq = 1
       FOREACH r120_tempcur USING sr.bmb03 INTO l_bmb03,g_use[l_seq].bma01
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_tempcur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET l_seq = l_seq + 1
       END FOREACH
       IF l_seq > 1 THEN LET l_seq = l_seq - 1 END IF
 
      #-->取相關供給資料(pr/po/wo)
       LET l_seq3 = 1
       FOREACH r120_prcur USING sr.bmb03 INTO l_no,l_item
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_prcur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no ,'-',l_item using '<<<'
         LET l_seq3 = l_seq3 + 1
       END FOREACH
 
       FOREACH r120_pocur USING sr.bmb03 INTO l_no,l_item
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_pocur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no ,'-',l_item using '<<<'
         LET l_seq3 = l_seq3 + 1
       END FOREACH
 
       FOREACH r120_wocur USING sr.bmb03 INTO l_no
         IF SQLCA.sqlcode THEN
            CALL cl_err('r120_wocur',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         LET g_supply[l_seq3].no = l_no
         LET l_seq3 = l_seq3 + 1
       END FOREACH
       IF l_seq3 > 1 THEN LET l_seq3 = l_seq3 -1 END IF
 
       #-->總需求(訂單)
        SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO l_oebqty
          FROM oeb_file, oea_file
          WHERE oeb04 = sr.bmb03 AND oeb01 = oea01 AND oea00<>'0'
           AND oeb70 = 'N' AND oeb12 > oeb24
           AND oeaconf != 'X' #01/08/08 mandy
        IF cl_null(l_oebqty) THEN LET l_oebqty =0 END IF
       #-->總需求(工單備料量)
        SELECT SUM((sfa05-sfa06)*sfa13) INTO l_sfaqty
          FROM sfb_file,sfa_file
          WHERE sfa03 = sr.bmb03 AND sfb01 = sfa01
            AND sfb04 !='8' AND (sfa05 > sfa06) AND sfb87!='X'
        IF cl_null(l_sfaqty) THEN LET l_sfaqty =0 END IF
       #-->總需求(工單備料量)
        LET l_need = l_oebqty + l_sfaqty
 
       #-->總供給(請購量)
        SELECT SUM((pml20-pml21)*pml09) INTO l_prqty
          FROM pml_file, pmk_file
         WHERE pml04 = sr.bmb03 AND pml01 = pmk01 AND pmk18 !='X'
           AND pml20 > pml21 AND pml16 <='2' AND pml011 !='SUB'
        IF cl_null(l_prqty) THEN LET l_prqty = 0 END IF
       #-->採購量
       #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO l_poqty #FUN-940083
        SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_poqty #FUN-940083     
          FROM pmn_file, pmm_file
         WHERE pmn04 = sr.bmb03 AND pmn01 = pmm01 AND pmm18 !='X'
           AND pmn20 > pmn50 AND pmn16 <='2' AND pmn011 !='SUB'
        IF cl_null(l_poqty) THEN LET l_poqty = 0 END IF
       #-->工單在製量
        SELECT SUM(sfb08-sfb09-sfb10-sfb11-sfb12) INTO l_woqty
          FROM sfb_file
         WHERE sfb05 = sr.bmb03 AND sfb04 <'8'
           AND sfb08 > (sfb09+sfb11+sfb12) AND sfb87!='X'
        IF cl_null(l_woqty) THEN LET l_woqty = 0 END IF
       #-->IQC 在驗量
        SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_iqcqty
          FROM rvb_file, rva_file, pmn_file
         WHERE rvb05 = sr.bmb03 AND rvb01=rva01 AND rvaconf <> 'X'
           AND rvb04 = pmn01 AND rvb03 = pmn02
           AND rvb07 > (rvb29+rvb30)
           AND rvaconf='Y'
        IF cl_null(l_iqcqty) THEN LET l_iqcqty = 0 END IF
       #-->FQC 在驗量
        SELECT SUM(qcf22-qcf091) INTO l_fqcqty
          FROM qcf_file,sfb_file
         WHERE sfb05 = sr.bmb03 AND sfb01=qcf02 AND qcf22 > 0
           AND qcf14 <> 'X' AND sfb87!='X'
        IF cl_null(l_fqcqty) THEN LET l_fqcqty = 0 END IF
 
       #-->總供給
        LET l_supply =l_prqty+l_poqty+l_woqty+l_iqcqty+l_fqcqty
 
        SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01 = sr.bmb03
        IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF
 
        LET l_rem  = (l_supply + l_ima262) - l_need
        LET l_cost = l_rem * l_ccc23
 
        LET g_totcost = g_totcost + l_cost
        LET l_ima02 = ''
        LET l_ima021= ''
     ## SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file               ##NO.FUN-610092
        SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25 FROM ima_file ##NO.FUN-610092
         WHERE ima01 = sr.bmb03
        PRINT COLUMN g_c[31],sr.bmb03 CLIPPED,
              COLUMN g_c[32],l_ima02,
              COLUMN g_c[33],l_ima021,
              COLUMN g_c[42],l_ima25,   ##NO.FUN-610092
              COLUMN g_c[34],l_need   USING '-------------&',' ',   #總需求
              COLUMN g_c[35],l_supply USING '-------------&',' ',   #總供給
              COLUMN g_c[36],l_ima262 USING '-------------&',' ',   #現有庫存 #No:7071
              COLUMN g_c[37],l_rem    USING '-------------&',' ',   #ATP      #No:7071
              COLUMN g_c[38],cl_numfor(l_ccc23,38,g_azi03),         #單價
              COLUMN g_c[39],cl_numfor(l_cost,39,g_azi04);          #金額
 
        #-->用途/相關供給
        LET l_str1 = g_use[1].bma01,' ',g_use[2].bma01,' ',g_use[3].bma01
        LET l_str2 = g_supply[1].no,' ',g_supply[2].no,' ',g_supply[3].no
        PRINT COLUMN g_c[40],l_str1 CLIPPED,
              COLUMN g_c[41],l_str2 CLIPPED
 
        IF l_seq > 3 OR l_seq3 > 3 THEN
           IF l_seq > l_seq3 THEN
               LET l_max = l_seq ELSE LET l_max = l_seq3
           END IF
           LET l_mod =(l_max-3) MOD 3
           IF l_mod != 0 THEN
                LET l_line = ((l_max-3) / 3 ) + 1
           ELSE LET l_line = (l_max-3) /3
           END IF
           FOR l_i = 1 TO l_line
             LET l_j = l_i * 3 + 1
             LET l_str1 = g_use[l_j].bma01,' ',g_use[l_j+1].bma01,' ',
                          g_use[l_j+2].bma01
             LET l_str2 = g_supply[l_j].no,' ',g_supply[l_j+1].no,' ',
                          g_supply[l_j+2].no
             PRINT COLUMN g_c[40],l_str1 CLIPPED,
                   COLUMN g_c[41],l_str2 CLIPPED
           END FOR
        END IF
 
   ON LAST ROW
      PRINT ' '
      PRINT COLUMN g_c[38],g_x[09] CLIPPED,
            COLUMN g_c[39],cl_numfor(g_totcost,39,g_azi05)
      PRINT g_dash
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.MOD-580214
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.MOD-580214
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750129
#Patch....NO.TQC-610037 <001> #
