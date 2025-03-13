# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: gglq940.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 2003/12/08 By Lynn Fu
# Modify.........: No.FUN-510007 05/01/18 By Nicola 報表架構修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.TQC-730049 07/03/13 By Smapmin 修改SQL語法
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740053 07/04/12 By Xufeng  (接下頁)/(結束)位置調整
# Modify.........: No.TQC-720034 07/05/17 By Jackho 報表項目打印修正報表項目打印修正
# Modify.........: No.FUN-780031 07/08/29 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-850030 08/05/08 By dxfwo   報表查詢化
# Modify.........: No.MOD-8C0259 09/01/05 By wujie   金額應該根絕借貸做加減，而不是簡單的相加
# Modify.........: No.MOD-920216 09/02/17 By chenl   擴大字段
# Modify.........: No.MOD-940091 09/04/13 By chenl   調整取值邏輯
# Modify.........: No.MOD-940281 09/04/22 By liuxqa 二次查詢時，打印等按鈕顯示在右邊欄位。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-9B0016 09/11/04 By liuxqa 标准SQL修改。
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
              title   LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(20)   #輸入報表名稱
              y1      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #輸入起始年度
              m1      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #Begin 期別
              y2      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #輸入截止年度
              m2      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   #End   期別
              b       LIKE aaa_file.aaa01,    #帳別
              c       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #異動額及餘額為0者是否列印
              d       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #金額單位
              o       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)    #轉換幣別否
              r       LIKE azi_file.azi01,    #總帳幣別
              p       LIKE azi_file.azi01,    #轉換幣別
              q       LIKE azj_file.azj03,    #匯率
              more    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)    #Input more condition(Y/N)
          END RECORD,
          bdate,edate          LIKE type_file.dat,     #NO FUN-690009   DATE
          l_za05               LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          g_bookno             LIKE aah_file.aah00,    #帳別
          g_unit               LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE    g_i                  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE    g_aaa03              LIKE  aaa_file.aaa03
DEFINE    g_before_input_done  LIKE type_file.num5     #NO FUN-690009   SMALLINT
DEFINE    p_cmd                LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE    g_msg                LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(100)
DEFINE    l_table              STRING  #No.FUN-780031
DEFINE    g_str                STRING  #No.FUN-780031
DEFINE    g_sql                STRING  #No.FUN-780031
#No.FUN-850030  --Begin
DEFINE   g_yy2      LIKE type_file.num5
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_nml      DYNAMIC ARRAY OF RECORD
                   #nml02  LIKE nml_file.nml02,   #No.MOD-920216 mark
                    nml02  LIKE type_file.chr50,  #No.MOD-920216 
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE aah_file.aah04,
                    tia08b LIKE aah_file.aah04
                    END RECORD
DEFINE   g_pr_ar    DYNAMIC ARRAY OF RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                   #nml02  LIKE nml_file.nml02,    #No.MOD-920216 mark
                    nml02  LIKE type_file.chr50,   #No.MOD-920216
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE tia_file.tia08,
                    tia08b LIKE tia_file.tia08
                    END RECORD
DEFINE   g_pr       RECORD
                    type   LIKE type_file.chr1,
                    nml01  LIKE nml_file.nml01,
                   #nml02  LIKE nml_file.nml02,     #No.MOD-920216 mark
                    nml02  LIKE type_file.chr50,    #No.MOD-920216
                    nml03  LIKE nml_file.nml03,
                    nml05  LIKE nml_file.nml05,
                    tia08a LIKE tia_file.tia08,
                    tia08b LIKE tia_file.tia08
                    END RECORD
#No.FUN-850030   --End
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #-----TQC-610056---------
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
   LET tm.y2 = ARG_VAL(10)
   LET tm.m1 = ARG_VAL(11)
   LET tm.m2 = ARG_VAL(12)
   LET tm.b = ARG_VAL(13)
   LET tm.c = ARG_VAL(14)
   LET tm.d = ARG_VAL(15)
   LET tm.o = ARG_VAL(16)
   LET tm.r = ARG_VAL(17)
   LET tm.p = ARG_VAL(18)
   LET tm.q = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
   #-----END TQC-610056-----
 
   #No.FUN-850030  --Begin
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   LET g_rlang  = g_lang
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   OPEN WINDOW q940_w AT 5,10
        WITH FORM "ggl/42f/gglq940" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL q940_tm()                          # Input print condition
   ELSE
      CALL q940()                             # Read data and create out-file
   END IF
 
   CALL q940_menu()                                                            
   CLOSE WINDOW q940_w 
   #No.FUN-850030  --End  
 
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
 
END MAIN
 
FUNCTION q940_menu()
   WHILE TRUE
      CALL q940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q940_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q940_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q940_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_sw           LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #重要欄位是否空白
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   CALL s_dsmark(tm.b)  #No.FUN-850030
   LET p_row = 4 LET p_col = 4
   OPEN WINDOW q940_w1 AT p_row,p_col
     WITH FORM "ggl/42f/gglr940"  ATTRIBUTE (STYLE = g_win_style CLIPPED)              #No.FUN-580092 HCN
 
#   CALL cl_ui_init()  #No.MOD-940281 mark
   CALL cl_ui_locale("gglr940")  #No.MOD-940281 mod 
   CALL s_shwact(0,0,tm.b)  #No.FUN-850030
   CALL cl_opmsg('p')
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  #No.FUN-850030
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)   #No.FUN-660124
   END IF
   INITIALIZE tm.* TO NULL            # Default condition
 
   LET tm.title = g_x[1]
   LET tm.b = g_bookno
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,tm.b,tm.d,tm.c,tm.o,
                    tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         BEFORE INPUT
            CALL q940_set_entry(p_cmd)
            CALL q940_set_no_entry(p_cmd)
         #No.FUN-580031 --start--
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
         AFTER FIELD y1
            IF NOT cl_null(tm.y1) THEN
               IF tm.y1 = 0 THEN
                  NEXT FIELD y1
               END IF
               LET tm.y2=tm.y1
               LET g_yy2= tm.y1 - 1  #No.FUN-850030
            END IF
 
         AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#            IF tm.m1 <1 OR tm.m1 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD m1
#            END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#            IF tm.m2 <1 OR tm.m2 > 13 THEN
#               CALL cl_err('','agl-013',0)
#               NEXT FIELD m2
#            END IF
#No.TQC-720032 -- end --
 
 
            IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
               CALL cl_err('','9011',0)
               NEXT FIELD m1
            END IF
 
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
               #No.FUN-670004--begin
	            CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               #No.FUN-670004--end
            SELECT aaa01 FROM  aaa_file WHERE aaa01 = tm.b AND aaaacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('','agl-095',0)   #No.FUN-660124
                  CALL cl_err3("sel","aaa_file",tm.b,"","agl-095","","",0)   #No.FUN-660124
                  NEXT FIELD b
               END IF
	    END IF
 
         BEFORE FIELD o
            CALL q940_set_entry(p_cmd)
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
               DISPLAY BY NAME tm.q,tm.r
            END IF
            CALL q940_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
#              CALL cl_err(tm.p,'mfg3008',0)   #No.FUN-660124
               CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0)   #No.FUN-660124
               NEXT FIELD p
            END IF
 
         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
 
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
 
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
 
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY tm.p TO p
                  NEXT FIELD p
            END CASE
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
     #-----TQC-610056---------
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='gglq940'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglq940','9031',1)
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'" ,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.title CLIPPED,"'" ,
                        " '",tm.y1 CLIPPED,"'" ,
                        " '",tm.y2 CLIPPED,"'" ,
                        " '",tm.m1 CLIPPED,"'" ,
                        " '",tm.m2 CLIPPED,"'" ,
                        " '",tm.b CLIPPED,"'" ,
                        " '",tm.c CLIPPED,"'" ,
                        " '",tm.d CLIPPED,"'" ,
                        " '",tm.o CLIPPED,"'" ,
                        " '",tm.r CLIPPED,"'" ,
                        " '",tm.p CLIPPED,"'" ,
                        " '",tm.q CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('gglq940',g_time,l_cmd)    # Execute cmd at later tim
        END IF
        CLOSE WINDOW q940_w1
        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     #-----END TQC-610056-----
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW q940_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL q940()
 
      ERROR ""
      EXIT WHILE   #No.FUN-850030
   END WHILE
 
   CLOSE WINDOW q940_w1
 
END FUNCTION
 
FUNCTION q940()
DEFINE l_name    LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)    # External(Disk) file name
DEFINE l_chr     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
DEFINE l_sql     LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(1000)  # RDSQL STATEMENT
#No.FUN-850030  --Begin 
DEFINE sr        RECORD
                 type   LIKE type_file.chr1,
                 nml01  LIKE nml_file.nml01,
                #nml02  LIKE nml_file.nml02,   #No.MOD-920216 mark
                 nml02  LIKE type_file.chr50,  #No.MOD-920216
                 nml03  LIKE nml_file.nml03,
                 nml05  LIKE nml_file.nml05,
                 tia08a LIKE tia_file.tia08,
                 tia08b LIKE tia_file.tia08
                 END RECORD
DEFINE l_i       LIKE type_file.num10
#No.FUN-850030  --End   
DEFINE l_tmp     LIKE type_file.num5 
DEFINE l_tib08   LIKE tib_file.tib08 
#No.MOD-8C0259 --begin                                                          
DEFINE l_nml03   LIKE nml_file.nml03                                            
#No.MOD-8C0259 --end
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_prog = 'gglr940'
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr940'
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang
 
   SELECT azi04 INTO t_azi04,t_azi05
     FROM azi_file WHERE azi01 = tm.p  #No.FUN-850030
 
   IF tm.d != '1' THEN
      LET t_azi04 = 0     #No.CHI-6A0004
      LET t_azi05 = 0
   END IF
   DROP TABLE x
#No.MOD-8C0259 --begin
   DROP TABLE y
   SELECT * FROM tia_file 
    WHERE tia_file.tia05 = tm.b
      AND tia_file.tia01*13+tia_file.tia02 >= tm.y1*13+tm.m1
      AND tia_file.tia03*13+tia_file.tia04 <= tm.y2*13+tm.m2
     #No.MOD-940091--begin-- modify 
     #AND tia_file.tia08 > tia_file.tia081  #No.MOD-940091 mark
      AND (    (tia_file.tia08>0 AND tia_file.tia08 > tia_file.tia081)
            OR (tia_file.tia08<0 AND tia_file.tia08 < tia_file.tia081)
          )
     #No.MOD-940091---end--- modify 
     INTO TEMP y
   UPDATE y SET tia08 =tia08*(-1),tia081 =tia081*(-1) WHERE tia07='2'
#No.MOD-8C0259 --end
 
 LET l_sql = "SELECT nml01,nml02,nml03,nml05,SUM(tia08-tia081) tia08a",
#No.MOD-8C0259 --begin
#            "  FROM nml_file,OUTER tia_file ",
             #"  FROM nml_file,y ",           #NO.TQC-9B0016 mark  
             "  FROM nml_file LEFT OUTER JOIN y ON nml01 = y.tia09 ",     #NO.TQC-9B0016 mod            
             #" WHERE y.tia09(+) = nml01",                                #No.TQC-9B0016 mark
#            " WHERE tia_file.tia09 = nml_file.nml01",
#            "   AND tia_file.tia05 = '",tm.b,"'",
#            "   AND tia_file.tia01*13+tia_file.tia02 >= ",tm.y1*13+tm.m1,
#            "   AND tia_file.tia03*13+tia_file.tia04 <= ",tm.y2*13+tm.m2,
#            "   AND tia_file.tia08 > tia_file.tia081 ",
#No.MOD-8C0259 --end
#No.MOD-8C0259 --end
               " GROUP BY nml01,nml02,nml03,nml05 INTO TEMP x"
#              " ORDER BY nml01,nml02,nml03,nml05 INTO TEMP x"
 
   PREPARE gglq940_gentemp FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare',STATUS,1)
      RETURN
   END IF
 
   EXECUTE gglq940_gentemp
   IF STATUS THEN
      CALL cl_err('execute',STATUS,1)
      RETURN
   END IF
 
   DECLARE gglq940_curs CURSOR FOR SELECT * FROM x
   IF STATUS THEN
      CALL cl_err('declare',STATUS,0)
      RETURN
   END IF
 
   CALL cl_outnam('gglr940') RETURNING l_name
   START REPORT q940_rep TO l_name
   LET g_pageno = 0
 
   #No.FUN-850030  --Begin
   LET g_rec_b = 1
   CALL g_nml.clear()
   #No.FUN-850030  --End  
   LET g_rec_b = 1
   FOREACH gglq940_curs INTO sr.nml01,sr.nml02,sr.nml03,sr.nml05,sr.tia08a
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #tia08a
      IF sr.tia08a IS NULL THEN LET sr.tia08a = 0 END IF
      LET l_tib08 = 0
#No.MOD-8C0259 --begin
      DROP TABLE z
      SELECT * FROM tib_file
       WHERE tib09 = sr.nml01
         AND tib03 = tm.b
         AND tib01*13+tib02 >= tm.y1*13+tm.m1
         AND tib01*13+tib02 <= tm.y2*13+tm.m2
        INTO TEMP z 
      UPDATE z SET tib08 =tib08*(-1) WHERE tib05 ='2'
#     SELECT SUM(tib08) INTO l_tib08 FROM tib_file
#        WHERE tib09 = sr.nml01
#          AND tib03 = tm.b
#          AND tib01*13+tib02 >= tm.y1*13+tm.m1
#          AND tib01*13+tib02 <= tm.y2*13+tm.m2
      SELECT SUM(tib08) INTO l_tib08 FROM z
      SELECT nml03 INTO l_nml03 FROM nml_file WHERE nml01 =sr.nml01
      IF l_nml03 MATCHES '*0' THEN 
         LET l_tib08 =l_tib08*(-1) 
         LET sr.tia08a =sr.tia08a*(-1)
      END IF
#No.MOD-8C0259 --end
      IF l_tib08 IS NULL THEN LET l_tib08 = 0 END IF
      LET sr.tia08a = sr.tia08a + l_tib08
      IF cl_null(sr.tia08a) THEN LET sr.tia08a = 0 END IF
 
      #tia08b
      LET g_yy2= tm.y1 - 1
#No.MOD-8C0259 --begin
      DROP TABLE y
      SELECT * FROM tia_file
       WHERE tia09 = sr.nml01
         AND tia05 = tm.b
         AND tia01*13+tia02 >= g_yy2*13+tm.m1
         AND tia03*13+tia04 <= g_yy2*13+tm.m2
        #No.MOD-940091--begin-- modify
        #AND tia08 > tia081    #No.MOD-940091 mark  
         AND ((tia08>0 AND tia08 > tia081) OR (tia08<0 AND tia08 < tia081))
        #No.MOD-940091---end--- modify 
        INTO TEMP y
      UPDATE y SET tia08 =tia08*(-1),tia081 =tia081*(-1) WHERE tia07='2'
      SELECT SUM(tia08-tia081) INTO sr.tia08b
        FROM y
#       FROM tia_file
#      WHERE tia09 = sr.nml01
#        AND tia05 = tm.b
#        AND tia01*13+tia02 >= g_yy2*13+tm.m1
#        AND tia03*13+tia04 <= g_yy2*13+tm.m2
#        AND tia08 > tia081
#No.MOD-8C0259 --end
      IF sr.tia08b IS NULL THEN LET sr.tia08b = 0 END IF
      LET l_tib08 = 0
#No.MOD-8C0259 --begin
      DROP TABLE z
      SELECT * FROM tib_file
       WHERE tib09 = sr.nml01
         AND tib03 = tm.b
         AND tib01*13+tib02 >= g_yy2*13+tm.m1
         AND tib01*13+tib02 <= g_yy2*13+tm.m2
        INTO TEMP z 
      UPDATE z SET tib08 =tib08*(-1) WHERE tib05 ='2'
#     SELECT SUM(tib08) INTO l_tib08 FROM tib_file
#      WHERE tib09 = sr.nml01
#        AND tib03 = tm.b
#        AND tib01*13+tib02 >= g_yy2*13+tm.m1
#        AND tib01*13+tib02 <= g_yy2*13+tm.m2
      SELECT SUM(tib08) INTO l_tib08 FROM z
      IF l_nml03 MATCHES '*0' THEN 
         LET l_tib08 =l_tib08*(-1) 
         LET sr.tia08b =sr.tia08b*(-1)
      END IF
#No.MOD-8C0259 --end
      IF l_tib08 IS NULL THEN LET l_tib08 = 0 END IF
      LET sr.tia08b = sr.tia08b + l_tib08
      IF cl_null(sr.tia08b) THEN LET sr.tia08b = 0 END IF
 
      LET sr.type = sr.nml03[1,1]
 
      IF tm.c = 'N' AND sr.tia08a = 0 AND sr.tia08b = 0 THEN
         CONTINUE FOREACH
      END IF
 
      OUTPUT TO REPORT q940_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT q940_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   FOR l_i = 1 TO g_rec_b
       LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02
       LET g_nml[l_i].nml05 = g_pr_ar[l_i].nml05
       LET g_nml[l_i].tia08a= g_pr_ar[l_i].tia08a
       LET g_nml[l_i].tia08b= g_pr_ar[l_i].tia08b
   END FOR
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
 
END FUNCTION
 
REPORT q940_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
   DEFINE l_amt        LIKE nme_file.nme08
   DEFINE l_amt2       LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1   LIKE nme_file.nme08
   DEFINE l_count_out1  LIKE nme_file.nme08
   DEFINE l_cash2      LIKE nme_file.nme08
   DEFINE cash_in2     LIKE nme_file.nme08
   DEFINE cash_out2    LIKE nme_file.nme08
   DEFINE l_count2     LIKE nme_file.nme08
   DEFINE l_count_in2   LIKE nme_file.nme08
   DEFINE l_count_out2  LIKE nme_file.nme08
   DEFINE p_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_flag       LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_unit       LIKE zaa_file.zaa08   #NO FUN-690009   VARCHAR(40)
   #No.FUN-850030  --Begin
   DEFINE sr           RECORD
                       type   LIKE type_file.chr1,
                       nml01  LIKE nml_file.nml01,
                      #nml02  LIKE nml_file.nml02,   #No.MOD-920216 mark
                       nml02  LIKE type_file.chr50,  #No.MOD-920216
                       nml03  LIKE nml_file.nml03,
                       nml05  LIKE nml_file.nml05,
                       tia08a LIKE tia_file.tia08,
                       tia08b LIKE tia_file.tia08
                       END RECORD
   #No.FUN-850030  --End  
   DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.type,sr.nml03,sr.nml01
 
   FORMAT
      PAGE HEADER
         CASE tm.d
            WHEN '1'
               LET l_unit = g_x[19]
            WHEN '2'
               LET l_unit = g_x[20]
            WHEN '3'
               LET l_unit = g_x[21]
            OTHERWISE
               LET l_unit = ' '
         END CASE
 
      BEFORE GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type  = sr.type
         LET g_pr_ar[g_rec_b].nml01 = sr.nml01
         LET g_pr_ar[g_rec_b].nml03 = sr.nml03
         CASE sr.type
            WHEN '1'
               LET g_pr_ar[g_rec_b].nml02 = g_x[9]
               LET g_rec_b = g_rec_b + 1
            WHEN '2'
               LET g_pr_ar[g_rec_b].nml02 = g_x[11]
               LET g_rec_b = g_rec_b + 1
            WHEN '3'
               LET g_pr_ar[g_rec_b].nml02 = g_x[13]
               LET g_rec_b = g_rec_b + 1
            WHEN '4'
               LET g_pr_ar[g_rec_b].nml02 = g_x[15]
               LET g_rec_b = g_rec_b + 1
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON EVERY ROW
         LET sr.tia08a = sr.tia08a * tm.q / g_unit
         LET sr.tia08b = sr.tia08b * tm.q / g_unit
         LET g_pr_ar[g_rec_b].* = sr.*
         LET g_rec_b = g_rec_b + 1
 
      AFTER GROUP OF sr.nml03
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
         LET cash_in1 = GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'
 
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
 
         IF sr.nml03 <> '40' THEN
            CASE 
              WHEN sr.nml03='1' OR sr.nml03='3'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[18]
              WHEN sr.nml03='2'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[17]
              OTHERWISE
                   LET g_pr_ar[g_rec_b].nml02 = g_x[sr.nml03 MOD 10 + 17]
            END CASE
            IF sr.nml03[2,2] = '0' THEN
               LET cash_in1 = cash_in1 * tm.q / g_unit
               LET cash_in2 = cash_in2 * tm.q / g_unit
               LET g_pr_ar[g_rec_b].tia08a = cash_in1
               LET g_pr_ar[g_rec_b].tia08b = cash_in2
            ELSE
               LET cash_out1 = cash_out1 * tm.q / g_unit
               LET cash_out2 = cash_out2 * tm.q / g_unit
               LET g_pr_ar[g_rec_b].tia08a = cash_out1
               LET g_pr_ar[g_rec_b].tia08b = cash_out2
            END IF
            LET g_rec_b = g_rec_b + 1
         END IF
 
      AFTER GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
 
         LET cash_in1 = GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
 
         CASE sr.type
            WHEN '1'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[10]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            WHEN '2'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[12]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            WHEN '3'
               LET l_cash1 = (cash_in1 - cash_out1) * tm.q / g_unit
               LET l_cash2 = (cash_in2 - cash_out2) * tm.q / g_unit
               LET g_pr_ar[g_rec_b].nml02 = g_x[14]
               LET g_pr_ar[g_rec_b].tia08a= l_cash1
               LET g_pr_ar[g_rec_b].tia08b= l_cash2
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON LAST ROW
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
 
         LET l_count_in1 = SUM(sr.tia08a) WHERE sr.nml03[2,2] = '0'
         LET l_count_out1= SUM(sr.tia08a) WHERE sr.nml03[2,2] = '1'
         LET l_count_in2 = SUM(sr.tia08b) WHERE sr.nml03[2,2] = '0'
         LET l_count_out2= SUM(sr.tia08b) WHERE sr.nml03[2,2] = '1'
         IF cl_null(l_count_in1) THEN LET l_count_in1 = 0 END IF
         IF cl_null(l_count_out1) THEN LET l_count_out1 = 0 END IF
         IF cl_null(l_count_in2) THEN LET l_count_in2 = 0 END IF
         IF cl_null(l_count_out2) THEN LET l_count_out2 = 0 END IF
 
         LET l_count1 = l_count_in1 - l_count_out1
         LET l_count2 = l_count_in2 - l_count_out2
         LET l_count1 = l_count1 * tm.q / g_unit
         LET l_count2 = l_count2 * tm.q / g_unit
 
         LET g_pr_ar[g_rec_b].nml02 = g_x[16]
         LET g_pr_ar[g_rec_b].tia08a= l_count1
         LET g_pr_ar[g_rec_b].tia08b= l_count2
          
END REPORT
 
FUNCTION q940_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   CALL cl_set_comp_entry("p,q",TRUE)
 
END FUNCTION
 
FUNCTION q940_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
 
   IF tm.o = 'N' THEN
      CALL cl_set_comp_entry("p,q",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
 
FUNCTION q940_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY tm.p TO FORMONLY.azi01
   DISPLAY tm.y1 TO FORMONLY.yy
   DISPLAY tm.m1 TO FORMONLY.mm1
   DISPLAY tm.m2 TO FORMONLY.mm2
   DISPLAY tm.d  TO FORMONLY.unit
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.* ATTRIBUTE(COUNT=g_rec_b)
      #BEFORE DISPLAY
      #   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      #  LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q940_out()
  DEFINE l_i   LIKE type_file.num10
   LET g_prog = 'gglq940'
   LET g_sql = " type.type_file.chr1,", 
               " nml01.nml_file.nml01,",
              #" nml02.nml_file.nml02,",     #No.MOD-920216 mark
               " nml02.type_file.chr50,",    #No.MOD-920216
               " nml03.nml_file.nml03,",
               " nml05.nml_file.nml05,",
               " tia08a.tia_file.tia08,",
               " tia08b.tia_file.tia08 "
   LET l_table = cl_prt_temptable('gglq940',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?         ) " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL cl_del_data(l_table)
 
   FOR l_i = 1 TO g_rec_b 
       EXECUTE insert_prep USING g_pr_ar[l_i].*
   END FOR
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",
               t_azi04,";",t_azi05
   CALL cl_prt_cs3('gglq940','gglq940',g_sql,g_str)
   #No.FUN-780031  --End
END FUNCTION
