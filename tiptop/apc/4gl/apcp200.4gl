# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apcp200.4gl
# Descriptions...: POS UPLOAD
# Date & Author..: No.FUN-A40006 10/04/01 By huangrh
# Modify.........: No.FUN-A40006 10/06/21 By Cockroach pass no.
# Modify.........: No.FUN-A90040 10/10/11 By suncx 新增日結檔上傳，修改銷退單上傳相關邏輯
# Modify.........: No.FUN-AC0002 10/10/16 By suncx 接口整合
# Modify.........: No:FUN-B10011 11/01/07 By wangxin 公告欄隱藏
# Modify.........: No:TQC-B20181 11/03/03 By wangxin 將銷售單于銷退單合併為銷售銷退單
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B40017 11/04/11 By wangxin 銷售銷退邏輯調整，任意一個不成功都顯示不成功
# Modify.........: No:MOD-B80035 11/08/10 By huangtao 背景作業執行
# Modify.........: No:FUN-B80069 11/08/10 By huangtao 背景作業避免佔用License
# Modify.........: No:FUN-B90048 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No:FUN-C50086 12/05/22 By pauline 補過 FUN-B90024 修改範圍 
# Modify.........: No:FUN-C50090 12/07/10 By baogc 代碼調整
# Modify.........: No:FUN-C80045 12/08/16 By nanbing 增加ryz10控管
# Modify.........: No:FUN-CA0091 12/10/26 By baogc 添加上傳批量提交筆數
# Modify.........: No:FUN-CA0160 12/11/08 By baogc 添加卡、券上傳欄位
# Modify.........: No:FUN-CB0007 12/11/14 By shiwuying 增加进程判断
# Modify.........: No:FUN-CB0103 12/11/22 By baogc POS上傳邏輯調整

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_argv1      LIKE tqb_file.tqb01
DEFINE g_key        LIKE type_file.chr1000
DEFINE g_errn       LIKE type_file.chr10
DEFINE l_time       LIKE type_file.chr10
DEFINE l_date       DATE 
DEFINE g_no         LIKE type_file.chr18

DEFINE p_row,p_col             LIKE type_file.num5
DEFINE g_forupd_sql            STRING
DEFINE g_before_input_done     LIKE type_file.num5
DEFINE g_change_lang           LIKE type_file.chr1
#DEFINE g_wc_dd                 LIKE type_file.chr1000
#DEFINE g_wc_td                 LIKE type_file.chr1000
#DEFINE g_wc_th                 LIKE type_file.chr1000
#DEFINE g_wc_xs                 LIKE type_file.chr1000
#DEFINE g_wc_gg                 LIKE type_file.chr1000
DEFINE tm           RECORD
         transdb    LIKE type_file.chr10,  #傳輸DB
         transplant STRING,                #指定營運中心
         dd         LIKE type_file.chr1,   #客戶訂單 
         ddno       STRING,                #指定單號
         td         LIKE type_file.chr1,   #訂金單
         tdno       STRING,                #指定單號         
         xsxt       LIKE type_file.chr1,   #銷售銷退單
         xsxtno     STRING,                #指定單號
         rj         LIKE type_file.chr1,   #日結檔
         rjno       STRING,                #指定單號 #FUN-CA0091 Add ,
         card       LIKE type_file.chr1,   #卡異動單 #FUN-CA0160 Add
         cardno     STRING,                #指定單號 #FUN-CA0160 Add
         coupon     LIKE type_file.chr1,   #券異動單 #FUN-CA0160 Add
         couponno   STRING,                #指定單號 #FUN-CA0160 Add
         transnum   LIKE type_file.num10   #上传批量提交筆數 #FUN-CA0091 Add
                    END RECORD         
DEFINE tm_t         RECORD
         transdb    LIKE type_file.chr10,  #傳輸DB
         transplant STRING,                #指定營運中心
         dd         LIKE type_file.chr1,   #客戶訂單 
         ddno       STRING,                #指定單號
         td         LIKE type_file.chr1,   #訂金單
         tdno       STRING,                #指定單號         
         xsxt       LIKE type_file.chr1,   #銷售銷退單
         xsxtno     STRING,                #指定單號
         rj         LIKE type_file.chr1,   #日結檔
         rjno       STRING,                #指定單號 #FUN-CA0091 Add ,
         card       LIKE type_file.chr1,   #卡異動單 #FUN-CA0160 Add
         cardno     STRING,                #指定單號 #FUN-CA0160 Add
         coupon     LIKE type_file.chr1,   #券異動單 #FUN-CA0160 Add
         couponno   STRING,                #指定單號 #FUN-CA0160 Add
         transnum   LIKE type_file.num10   #上传批量提交筆數 #FUN-CA0091 Add
                    END RECORD
DEFINE g_posstr     STRING               # 指定傳輸的table
DEFINE g_plantstr   STRING               # 指定機構
DEFINE g_posdbs     LIKE ryg_file.ryg00  # 指定傳輸DB
DEFINE g_pno        STRING
DEFINE g_ryz10      LIKE ryz_file.ryz10   #FUN-C80045 add
DEFINE g_ryg03      LIKE ryg_file.ryg03   #FUN-C80045 add
DEFINE g_transnum   LIKE type_file.num10  #FUN-CA0091 Add
DEFINE g_numstr     LIKE type_file.chr10  #FUN-CA0091 Add
DEFINE g_msg        STRING                #FUN-CB0007

MAIN
   DEFINE p_apname  STRING                #FUN-CB0007
   DEFINE l_flag    LIKE type_file.chr1

   IF FGL_GETENV("FGLGUI")<>"0" THEN
      OPTIONS
      INPUT NO WRAP
   END IF 
   DEFER INTERRUPT

   LET g_posstr   = ARG_VAL(1)
   LET g_plantstr = ARG_VAL(2)
   LET g_posdbs   = ARG_VAL(3)
   LET g_transnum = ARG_VAL(4)  #FUN-CA0091 Add
   LET g_bgjob    = ARG_VAL(5)  #FUN-CA0091 Mod

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF

   IF g_aza.aza88 <> 'Y' THEN
       CALL cl_err('','apc-120',1)
       EXIT PROGRAM
   END IF
   #FUN-C80045 add
   SELECT ryz10 INTO g_ryz10 FROM ryz_file
   IF g_ryz10 = 'Y' THEN
      SELECT ryg03 INTO g_ryg03 FROM ryg_file 
       WHERE ryg03 = g_plant
      IF cl_null(g_ryg03) THEN
         CALL cl_err('','apc1030',1)
         EXIT PROGRAM
      END IF
   END IF     
   #FUN-C80045 add
  #FUN-CB0007 Begin---
   LET p_apname = cl_used_ap_hostname()
   IF NOT s_chk_process_pos(p_apname,'apcp200',g_ryz10) THEN
      IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
         IF cl_confirm('apc-207') THEN
           #LET g_msg =  "apcq070 'apcp200'"
            LET g_msg =  "apcq070 "
            CALL cl_cmdrun(g_msg)
         END IF
      END IF
      EXIT PROGRAM
   END IF
  #FUN-CB0007 End-----

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p200_i()
         IF g_bgjob='Y' THEN
            CLOSE WINDOW p200_w
            CALL p200_p()
            EXIT WHILE
         END IF

         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p200_p()
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF NOT l_flag THEN
               CLOSE WINDOW p200_w
               EXIT WHILE
            ELSE
               MESSAGE 'UPLOAD SUCCESS'
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p200(g_posstr,g_plantstr,g_posdbs,g_pno,g_transnum) #FUN-CA0091 Add g_transnum
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p200_i()
DEFINE li_result  LIKE type_file.num5          
DEFINE lc_cmd     LIKE type_file.chr1000             
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_ryg00    LIKE ryg_file.ryg00
DEFINE gst_pplant base.stringtokenizer
DEFINE gs_pplant  LIKE azw_file.azw01
DEFINE l_n        LIKE type_file.num5
DEFINE l_ryg03    LIKE ryg_file.ryg03  #FUN-C80045 add
DEFINE l_ryz06    LIKE ryz_file.ryz06 #FUN-CA0091 Add
   
   LET p_row = 2 LET p_col = 8
   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "apc/42f/apcp200"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   SELECT DISTINCT ryg00 INTO l_ryg00 FROM ryg_file
   DISPLAY l_ryg00 to FORMONLY.transdb

   WHILE TRUE
      CALL cl_opmsg('w')
      MESSAGE ""
   
      LET tm.transdb  = l_ryg00 
      LET tm.dd     = 'Y' #FUN-CA0091 Mod 
      LET tm.td     = 'Y' #FUN-CA0091 Mod
      LET tm.xsxt   = 'Y' #FUN-CA0091 Mod
      LET tm.rj     = 'Y' #FUN-CA0091 Mod
      LET tm.card   = 'Y' #FUN-CA0160 Add
      LET tm.coupon = 'Y' #FUN-CA0160 Add
      LET g_bgjob  = 'N'
      SELECT ryz11 INTO tm.transnum FROM ryz_file #FUN-CA0091 Add

      INPUT tm.transplant,tm.dd,tm.ddno,
            tm.td,tm.tdno,
            tm.xsxt,tm.xsxtno,
           #tm.rj,tm.rjno,tm.transnum,g_bgjob #FUN-CA0091 Add tm.transnum  #FUN-CA0160 Mark
           #FUN-CA0160 Add Begin ---
            tm.rj,tm.rjno,
            tm.card,tm.cardno,
            tm.coupon,tm.couponno,
            tm.transnum,g_bgjob 
           #FUN-CA0160 Add End -----
         WITHOUT DEFAULTS FROM transplant,dd,ddno,
                               td,tdno,
                               xsxt,xsxtno,
                              #rj,rjno,transnum,bgjob #FUN-CA0091 Add transnum #FUN-CA0160 Mark
                              #FUN-CA0160 Add Begin ---
                               rj,rjno,
                               card,cardno,
                               coupon,couponno,
                               transnum,bgjob
                              #FUN-CA0160 Add End -----
         BEFORE INPUT
            CALL p200_set_entry()
            CALL p200_set_no_entry()

         AFTER FIELD transplant
            IF NOT cl_null(tm.transplant) THEN
               IF tm.transplant != tm_t.transplant OR tm_t.transplant IS NULL THEN
                  LET gst_pplant = base.stringtokenizer.create(tm.transplant,"|;")
                  WHILE gst_pplant.hasmoretokens()
                     LET gs_pplant = gst_pplant.nexttoken()
                     SELECT COUNT(*) INTO l_n FROM ryg_file
                      WHERE ryg01=gs_pplant AND rygacti='Y'
                     IF l_n=0 OR l_n IS NULL THEN
                        CALL cl_err(gs_pplant,'apc-119',0)  #該機構不在當前POS傳輸營運中心資料檔中，請重新錄入
                        DISPLAY tm.transplant TO transplant
                        NEXT FIELD transplant
                     END IF
                     #FUN-C80045 add sta
                     IF g_ryz10 = 'Y' THEN
                        SELECT ryg03 INTO l_ryg03 FROM ryg_file
                         WHERE ryg01=gs_pplant 
                        IF l_ryg03 IS NULL OR l_ryg03 <> g_ryg03 THEN
                           CALL cl_err(gs_pplant,'apc1035',0)
                           DISPLAY tm.transplant TO transplant
                           NEXT FIELD transplant
                        END IF
                     END IF
                     #FUN-C80045 add end
                  END WHILE
               END IF
            END IF
         
         ON CHANGE dd
            IF tm.dd= 'Y' THEN
               CALL cl_set_comp_entry("ddno",TRUE)
            ELSE
               CALL cl_set_comp_entry("ddno",FALSE)
               LET tm.ddno=tm_t.ddno
               DISPLAY tm.ddno TO ddno
            END IF

         ON CHANGE td
            IF tm.td= 'Y' THEN
               CALL cl_set_comp_entry("tdno",TRUE)
            ELSE
               CALL cl_set_comp_entry("tdno",FALSE)
               LET tm.tdno=tm_t.tdno
               DISPLAY tm.tdno TO tdno
            END IF

         ON CHANGE xsxt
            IF tm.xsxt= 'Y' THEN
               CALL cl_set_comp_entry("xsxtno",TRUE)
            ELSE
               CALL cl_set_comp_entry("xsxtno",FALSE)
               LET tm.xsxtno =tm_t.xsxtno
               DISPLAY tm.xsxtno TO xsxtno
            END IF

         ON CHANGE rj
            IF tm.rj= 'Y' THEN
               CALL cl_set_comp_entry("rjno",TRUE)
            ELSE
               CALL cl_set_comp_entry("rjno",FALSE)
               LET tm.rjno = tm_t.rjno
               DISPLAY tm.rjno TO rjno
            END IF

        #FUN-CA0160 Add Begin ---
         ON CHANGE card
            IF tm.card= 'Y' THEN
               CALL cl_set_comp_entry("cardno",TRUE)
            ELSE
               CALL cl_set_comp_entry("cardno",FALSE)
               LET tm.cardno = tm_t.cardno
               DISPLAY tm.cardno TO cardno
            END IF

         ON CHANGE coupon 
            IF tm.coupon= 'Y' THEN
               CALL cl_set_comp_entry("couponno",TRUE)
            ELSE
               CALL cl_set_comp_entry("couponno",FALSE)
               LET tm.couponno = tm_t.couponno
               DISPLAY tm.couponno TO couponno
            END IF
        #FUN-CA0160 Add End -----

        #FUN-CA0091 Add Begin ---
         AFTER FIELD transnum
            IF NOT cl_null(tm.transnum) THEN
               IF tm.transnum < 0 THEN
                  CALL cl_err('','axm-179',0)
                  NEXT FIELD transnum
               END IF
               SELECT ryz06 INTO l_ryz06 FROM ryz_file
               IF tm.transnum > 1 AND l_ryz06 = '5' THEN
                  CALL cl_err('','apc1050',0)
                  NEXT FIELD transnum
               END IF
            END IF
        #FUN-CA0091 Add End -----

         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF    

         ON ACTION controlp
            CASE
               WHEN INFIELD(transplant) #指定傳輸營運中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ryg01"
                  #FUN-C80045 add sta   
                  IF g_ryz10 = 'Y' THEN
                     LET g_qryparam.where = "  ryg01 IN (SELECT ryg01 FROM ryg_file WHERE ryg03 ='",g_ryg03,"') "
                  END IF
                  #FUN-C80045 add end   
                  LET g_qryparam.default1 = tm.transplant
                  CALL cl_create_qry() RETURNING tm.transplant
                  DISPLAY tm.transplant TO transplant
                  NEXT FIELD transplant

               OTHERWISE EXIT CASE
            END CASE


         ON ACTION  selectall
            CALL p200_selectall()
            CONTINUE INPUT

         ON ACTION cancelall
            CALL p200_cancelall()
            CONTINUE INPUT

         ON ACTION CONTROLR
              CALL cl_show_req_fields()

         ON ACTION CONTROLG
            call cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about         
            CALL cl_about()      

         ON ACTION help          
            CALL cl_show_help() 

         ON ACTION exit      #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
       
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "apcp200"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('apcp200','9031',1) 
         ELSE
            CALL p200_get_str()
            LET lc_cmd = lc_cmd CLIPPED,
            " '",g_posstr CLIPPED,"'",
            " '",g_plantstr CLIPPED,"'",
            " '",g_posdbs CLIPPED,"'",
            " '",g_numstr CLIPPED,"'", #FUN-CA0091 Add
            " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('apcp200',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p200_p()
DEFINE l_success LIKE type_file.chr1
#DEFINE l_plant   LIKE azw_file.azw01 #FUN-C50090 Add #FUN-C80045 Mark

  #LET l_plant = g_plant  #記錄當前PLANT #FUN-C50090 Add #FUN-C80045 Mark

   CALL s_showmsg_init() #FUN-CB0103 Add

   IF tm.dd='Y' THEN
      CALL p200('oea_file',tm.transplant,tm.transdb,tm.ddno,tm.transnum) #FUN-CA0091 Add tm.transnum
   END IF
   IF tm.td='Y' THEN
      CALL p200('rxa_file',tm.transplant,tm.transdb,tm.tdno,tm.transnum) #FUN-CA0091 Add tm.transnum
   END IF
   IF tm.xsxt='Y' THEN
      CALL p200('oga_file|oha_file',tm.transplant,tm.transdb,tm.xsxtno,tm.transnum) #FUN-CA0091 Add tm.transnum
     #IF g_success = 'N' THEN
     #   LET l_success = 'N'
     #END IF 
     #CALL p200('oha_file',tm.transplant,tm.transdb,tm.xsxtno)  
     #IF l_success = 'N' THEN
     #   LET g_success = 'N'
     #END IF
   END IF   
   IF tm.rj='Y' THEN
      CALL p200('ome_file',tm.transplant,tm.transdb,tm.rjno,tm.transnum) #FUN-CA0091 Add tm.transnum
   END IF
  #FUN-CA0160 Add Begin ---
   IF tm.card='Y' THEN
      CALL p200('lps_file|lpu_file|lpv_file|lrw_file',tm.transplant,tm.transdb,tm.cardno,tm.transnum)
   END IF
   IF tm.coupon='Y' THEN
      CALL p200('rxe_file_2|rxe_file_3',tm.transplant,tm.transdb,tm.couponno,tm.transnum)
   END IF
  #FUN-CA0160 Add End -----

   CALL s_showmsg()

  #CALL p200_chk_database(l_plant) #切庫 - 切回原營運中心的庫 #FUN-C50090 Add #FUN-C80045 Mark
END FUNCTION

FUNCTION p200_set_entry()
  
END FUNCTION

FUNCTION p200_set_no_entry()
   
    IF tm.dd= 'N' THEN
       CALL cl_set_comp_entry("ddno",FALSE)
    END IF
    IF tm.td= 'N' THEN
       CALL cl_set_comp_entry("tdno",FALSE)
    END IF
    IF tm.xsxt= 'N' THEN
       CALL cl_set_comp_entry("xsxtno",FALSE)
    END IF
    IF tm.rj= 'N' THEN
       CALL cl_set_comp_entry("rjno",FALSE)
    END IF
    IF tm.card= 'N' THEN
       CALL cl_set_comp_entry("cardno",FALSE)
    END IF
    IF tm.coupon= 'N' THEN
       CALL cl_set_comp_entry("couponno",FALSE)
    END IF
END FUNCTION

FUNCTION p200_selectall()

    LET  tm.dd     = 'Y'
    LET  tm.td     = 'Y'
    LET  tm.xsxt   = 'Y'
    LET  tm.rj     = 'Y'
    LET  tm.card   = 'Y' #FUN-CA0160 Add
    LET  tm.coupon = 'Y' #FUN-CA0160 Add

    DISPLAY tm.dd TO FORMONLY.dd
    DISPLAY tm.td TO FORMONLY.td
    DISPLAY tm.xsxt TO FORMONLY.xsxt
    DISPLAY tm.rj TO FORMONLY.rj
    DISPLAY tm.card TO FORMONLY.card     #FUN-CA0160 Add
    DISPLAY tm.coupon TO FORMONLY.coupon #FUN-CA0160 Add
    CALL cl_set_comp_entry("ddno,tdno,xsxtno,rjno,cardno,couponno",TRUE) #FUN-CA0160 Add cardno,couponno
END FUNCTION

FUNCTION p200_cancelall()

    LET  tm.dd     = 'N'
    LET  tm.td     = 'N'
    LET  tm.xsxt   = 'N'
    LET  tm.rj     = 'N'
    LET  tm.card   = 'N' #FUN-CA0160 Add
    LET  tm.coupon = 'N' #FUN-CA0160 Add
    DISPLAY tm.dd TO FORMONLY.dd
    DISPLAY tm.td TO FORMONLY.td
    DISPLAY tm.xsxt TO FORMONLY.xsxt 
    DISPLAY tm.rj TO FORMONLY.rj
    DISPLAY tm.card TO FORMONLY.card     #FUN-CA0160 Add
    DISPLAY tm.coupon TO FORMONLY.coupon #FUN-CA0160 Add
    CALL cl_set_comp_entry("ddno,tdno,xsxtno,rjno,cardno,couponno",FALSE) #FUN-CA0160 Add cardno,couponno
END FUNCTION


FUNCTION p200_get_str()

   IF tm.dd = 'Y' THEN
      LET g_posstr = 'oea_file'
   END IF

   IF tm.td = 'Y' THEN
      IF cl_null(g_posstr) THEN
         LET g_posstr = 'rxa_file'
      ELSE
         LET g_posstr = g_posstr,'|','rxa_file'
      END IF
   END IF

   IF tm.xsxt = 'Y' THEN
      IF cl_null(g_posstr) THEN
         LET g_posstr = 'oga_file|oha_file'
      ELSE
         LET g_posstr = g_posstr,'|','oga_file|oha_file'
      END IF
   END IF

   IF tm.rj = 'Y' THEN
      IF cl_null(g_posstr) THEN
         LET g_posstr = 'ome_file'
      ELSE
         LET g_posstr = g_posstr,'|','ome_file'
      END IF
   END IF

  #FUN-CA0160 Add Begin ---
   IF tm.card = 'Y' THEN
      IF cl_null(g_posstr) THEN
         LET g_posstr = 'lps_file|lpu_file|lpv_file|lrw_file'
      ELSE
         LET g_posstr = g_posstr,'|','lps_file|lpu_file|lpv_file|lrw_file'
      END IF
   END IF

   IF tm.coupon = 'Y' THEN
      IF cl_null(g_posstr) THEN
         LET g_posstr = 'rxe_file_2|rxe_file_3'
      ELSE
         LET g_posstr = g_posstr,'|','rxe_file_2|rxe_file_3'
      END IF
   END IF
  #FUN-CA0160 Add End -----

   LET g_plantstr = tm.transplant
   LET g_posdbs = tm.transdb
   LET g_numstr = tm.transnum

END FUNCTION

#FUN-C50090

