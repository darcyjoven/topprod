# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimp600.4gl
# Descriptions...: 安全存量再订购点请购处理
# Input parameter: 
# Return code....: 
# Date & Author..: 
# Modify.........: No.FUN-C90100 12/12/11 xianghui 報表改善
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      STRING,
           ima08   LIKE ima_file.ima08,
           pmk04   LIKE pmk_file.pmk04, 
           pmk01   LIKE pmk_file.pmk01, 
           pmk12   LIKE pmk_file.pmk12, 
           pmk13   LIKE pmk_file.pmk13,
           summary_flag LIKE type_file.chr1,
           t1      LIKE type_file.dat,
           t2      LIKE type_file.dat,
           y	      LIKE type_file.num5,
           m	      LIKE type_file.num5,
           a       LIKE type_file.chr1, 
           b       LIKE type_file.chr1, 
           c       LIKE type_file.chr1, 
           d       LIKE type_file.chr1, 
           e       LIKE type_file.chr1, 
           f       LIKE type_file.chr1, 
           g       LIKE type_file.chr1,
           h       LIKE type_file.chr1 
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_sql,g_str,g_msg     STRING                #No.FUN-810073
DEFINE   l_table         STRING                #No.FUN-810073
DEFINE   g_bdate         LIKE type_file.dat
DEFINE   g_edate         LIKE type_file.dat  

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
   
   LET g_sql = "ima01.ima_file.ima01,",                   #料号
               "ima02.ima_file.ima02,",                   #品名
               "ima021.ima_file.ima021,",                 #规格
               "ima06.ima_file.ima06,",                   #分群码
               "ima67.ima_file.ima67,",                   #采购员
               "ima54.ima_file.ima54,",                   #主要供应商
               "pmc03.pmc_file.pmc03,",                   #名称
               "ima27.ima_file.ima27,",                   #安全存量
               "ima38.ima_file.ima38,",                   #补货点
               "ima45.ima_file.ima45,",                   #采购批量
               "ima46.ima_file.ima46,",                   #最少采购量
               "ima271.ima_file.ima271,",                 #最高存量
               "a.type_file.num15_3,",                    #请购量
               "b.type_file.num15_3,",                    #采购量
               "c.type_file.num15_3,",                    #在验量
               "d.type_file.num15_3,",                    #库存量
               "e.type_file.num15_3,",                    #期间用量
               "e1.type_file.num15_3,",                   #采购周期 
               "h.type_file.num15_3,",                    #工单在制量
               "qk.type_file.num15_3,",                   #缺口
               "zx.type_file.num15_3"                     #执行
#              "j.type_file.num15_3"                      #预出量   #add by zhangym 121011   #mark by lixh1 121030
   LET l_table = cl_prt_temptable('aimp600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'Y'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(10)    
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL aimp600_tm(0,0)
      ELSE CALL aimp600()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION aimp600_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE li_result      LIKE type_file.num5
DEFINE l_gen02	LIKE gen_file.gen02
DEFINE l_gen03	LIKE gen_file.gen03
DEFINE l_gem02	LIKE gem_file.gem02

   DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_t1,l_t2   LIKE type_file.dat,           #No.FUN-680122 DATE,    
          l_cmd             LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW aimp600_w AT p_row,p_col
        WITH FORM "aim/42f/aimp600" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.t1= g_today
   LET tm.t2= g_today
   LET tm.y   = YEAR(g_today) 
   LET tm.m   = MONTH(g_today) 
   LET tm.a   = 'Y'
   LET tm.b   = 'Y'
   LET tm.c   = 'Y'
   LET tm.d   = 'Y'
   LET tm.e   = 'N'
   LET tm.f   = 'Y'
   LET tm.g   = 'N'
   LET tm.h   = 'Y'
   LET tm.ima08 = 'P'
   LET tm.pmk04 = g_today
   LET tm.pmk12 = g_user
   LET tm.pmk13 = g_grup
   LET tm.summary_flag = '0'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima06,ima67,ima54
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION controlp                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
        END IF                                                              
        IF INFIELD(ima06) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_imz"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima06                       
           NEXT FIELD ima06                                    
        END IF                                                              
        IF INFIELD(ima54) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_pmc18"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima54                 
           NEXT FIELD ima54                
        END IF                                                              
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimp600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.ima08,tm.pmk04,tm.pmk01,tm.pmk12,tm.pmk13,tm.summary_flag,
                 tm.t1,tm.t2,tm.y,tm.m,
                 tm.a,tm.b,tm.c,tm.d,tm.e,tm.h,tm.f,tm.g         #add by lixh1 121030
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      AFTER FIELD ima08
            LET tm.pmk01 = ''
            DISPLAY BY NAME tm.pmk01
      AFTER FIELD pmk01
            IF tm.ima08 = 'P' THEN
               CALL s_check_no("apm",tm.pmk01,"","1","pmk_file","pmk01","")
               RETURNING li_result,tm.pmk01
            ELSE
               CALL s_check_no("asf",tm.pmk01,"","1","sfb_file","sfb01","")
               RETURNING li_result,tm.pmk01
            END IF
            DISPLAY BY NAME tm.pmk01
            IF (NOT li_result) THEN
               NEXT FIELD pmk01
            END IF
            LET tm.pmk01=tm.pmk01[1,g_doc_len]
       AFTER FIELD pmk12
         IF NOT cl_null(tm.pmk12) THEN
            SELECT gen02,gen03 INTO l_gen02,l_gen03
              FROM gen_file   WHERE gen01 = tm.pmk12
               AND genacti = 'Y'
            LET tm.pmk13 = l_gen03
            IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","gen_file",tm.pmk12,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME tm.pmk12
               NEXT FIELD pmk12
            END IF
         END IF

      AFTER FIELD pmk13
         IF NOT cl_null(tm.pmk13) THEN
            SELECT gem02 INTO l_gem02
              FROM gem_file  WHERE gem01 = tm.pmk13
               AND gemacti = 'Y'
            IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","gem_file",tm.pmk13,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME tm.pmk13
               NEXT FIELD pmk13
            END IF
         END IF

      AFTER FIELD t1
        IF cl_null(tm.t1) THEN NEXT FIELD t1 END IF
      AFTER FIELD t2
        IF cl_null(tm.t2) OR tm.t2<tm.t1 THEN NEXT FIELD t2 END IF
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmk01)
               IF tm.ima08 = 'P' THEN 
                  #LET g_t1=tm.pmk01[1,g_doc_len]       
                  CALL q_smy(FALSE,FALSE,tm.pmk01,'APM','1') RETURNING tm.pmk01
               ELSE
                  CALL q_smy(FALSE,FALSE,tm.pmk01,'asf','1') RETURNING tm.pmk01
               END IF
               DISPLAY BY NAME tm.pmk01
               NEXT FIELD pmk01
            WHEN INFIELD(pmk12) #請購員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = tm.pmk12
               CALL cl_create_qry() RETURNING tm.pmk12
               DISPLAY BY NAME tm.pmk12
               NEXT FIELD pmk12
            WHEN INFIELD(pmk13) #請購Dept
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = tm.pmk13
               CALL cl_create_qry() RETURNING tm.pmk13
               DISPLAY BY NAME tm.pmk13
               NEXT FIELD pmk13
            END CASE
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimp600_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF

   IF cl_null(tm.y) THEN LET tm.y = YEAR(g_today) END IF
   IF cl_null(tm.m) THEN LET tm.m = MONTH(g_today) END IF

#  CALL s_azn01(tm.y,tm.m) RETURNING g_bdate,g_edate     #add by zhangym 121011    #mark by lixh1 121030
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimp600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aimp600','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",                 #TQC-610051 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('aimp600',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimp600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimp600()
   ERROR ""
END WHILE
   CLOSE WINDOW aimp600_w
END FUNCTION
 
FUNCTION aimp600()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),        # External(Disk) file name
           l_sql     STRING,
          sr               RECORD 
               ima01	LIKE ima_file.ima01,                   #料号
               ima02	LIKE ima_file.ima02,                   #品名
               ima021	LIKE ima_file.ima021,                  #规格
               ima06	LIKE ima_file.ima06,                   #分群码
               ima67	LIKE ima_file.ima67,                   #采购员
               ima54	LIKE ima_file.ima54,                   #主要供应商
               pmc03	LIKE pmc_file.pmc03,                   #名称
               ima27	LIKE ima_file.ima27,                   #安全存量
               ima38	LIKE ima_file.ima38,                   #补货点
               ima45	LIKE ima_file.ima45,                   #采购批量
               ima46	LIKE ima_file.ima46,                   #最少采购量
               ima271	LIKE ima_file.ima271,                  #最高存量
               a	LIKE type_file.num15_3,                    #请购量
               b	LIKE type_file.num15_3,                    #采购量
               c	LIKE type_file.num15_3,                    #在验量
               d	LIKE type_file.num15_3,                    #库存量
               e	LIKE type_file.num15_3,                    #期间用量
               e1	LIKE type_file.num15_3,                    #采购周期 
               h	LIKE type_file.num15_3,                    #工单在制量
               qk	LIKE type_file.num15_3,                    #缺口
               zx	LIKE type_file.num15_3                     #执行 
#              j  LIKE type_file.num15_3                           #预出量     #mark by lixh1 121030
                        END RECORD,

          sr1               RECORD 
                        fl   LIKE type_file.chr50
                        END RECORD

     DEFINE     g_date     LIKE type_file.num5    #No.MOD-990086
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"   #lixh1 mark j 121030 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  
     LET g_date = tm.t2 - tm.t1 + 1
     IF g_date = 0 THEN LET g_date = 1 END IF
 
    #LET l_sql = "SELECT ima01,ima02,ima021,ima06,ima67,ima54,pmc03,ima27,ima38,decode(ima08,'M',ima56,ima45),decode(ima08,'M',ima561,ima46),ima271,",  #FUN-C90010 mark
     LET l_sql = "SELECT ima01,ima02,ima021,ima06,ima67,ima54,pmc03,ima27,ima38,",   #FUN-C90100
                 " (CASE WHEN ima08='M' THEN ima56 ELSE ima45 END),",           #FUN-C90100
                 " (CASE WHEN ima08='M' THEN ima561 ELSE ima46 END),ima271,",   #FUN-C90100
     #           "       0,0,0,0,0,ima27,0,0,0, 0 ",    #mark by lixh1 121030
                 "       0,0,0,0,0,ima27,0,0,0 ",       #by lixh1
                 "  FROM ima_file LEFT JOIN pmc_file ON pmc01 = ima54 ",
                 " WHERE imaacti = 'Y' ",
                 "   AND ima08 = '",tm.ima08,"'",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE aimp600_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE aimp600_curs1 CURSOR FOR aimp600_prepare1

     LET l_sql = "SELECT SUM(tlf10)/ ",g_date,                          #料件期间领出数量/总天数
                         " FROM tlf_file",
                         " WHERE tlf01 = ? ",
                         "   AND tlf907 = '-1' ",               #只取出庫
                         "   AND tlf06 BETWEEN '",tm.t1,"' AND '",tm.t2,"'",
                         "   AND tlf13 NOT LIKE 'aimt32*'"    #排除調撥動作
     PREPARE p600_tlf_p FROM l_sql

     LET l_sql = "SELECT SUM((pml20-pml21)*pml09) ",                     #已审核请购量
                 "  FROM pml_file, pmk_file ",
                 " WHERE pml04 = ? AND pml01 = pmk01 ",
                 "   AND pml20 > pml21 ",
                 "   AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W') ",
                 "   AND pml011 !='SUB'",
                 "   AND pmk18 = 'Y' "
     PREPARE p600_a FROM l_sql

     LET l_sql = "SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) ",         #已审核采购单
                 "  FROM pmn_file, pmm_file ",
                 " WHERE pmn04 = ? AND pmn01 = pmm01 ",
                 "   AND pmn20 > pmn50-pmn55-pmn58 ",
                 "   AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ",
                 "   AND pmn011 !='SUB' ",
                 "   AND pmm18 = 'Y' "
     PREPARE p600_b FROM l_sql

     LET l_sql = "SELECT SUM((rvb07-rvb29-rvb30)*pmn09) ",   #采购已检验未入库
                 "  FROM rvb_file, rva_file, pmn_file ",
                 " WHERE rvb05 = ?  AND rvb01=rva01 ",
                 "   AND rvb04 = pmn01 AND rvb03 = pmn02 ",
                 "   AND rvb07 > (rvb29+rvb30) ", 
                 "   AND rvaconf='Y' ",
                 "   AND rva10 != 'SUB' " 
     PREPARE p600_c FROM l_sql

     LET l_sql = "SELECT sum(img10) ",
                 "  FROM img_file ",
                 " WHERE img01 = ? "
     PREPARE p600_d FROM l_sql

     LET l_sql = "SELECT sum(sfb08 - sfb09) ",                #在制工单量
                 "  FROM sfb_file ",
                 " WHERE sfb05 = ? AND sfb87 = 'Y' AND sfb28 is null "
     PREPARE p600_h FROM l_sql
     
     FOREACH aimp600_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       IF cl_null(sr.ima27) THEN LET sr.ima27 = 0 END IF	       #安全存量
       IF cl_null(sr.ima38) THEN LET sr.ima38 = 0 END IF	       #补货点
       IF cl_null(sr.ima45) OR sr.ima45 = 0  THEN LET sr.ima45 = 1 END IF	       #采购批量
       IF cl_null(sr.ima46) THEN LET sr.ima46 = 0 END IF	       #最小采购量 
       IF cl_null(sr.ima271) THEN LET sr.ima271 = 0 END IF	       #最高存量

       IF tm.a = 'Y' THEN EXECUTE p600_a USING sr.ima01 INTO sr.a END IF 
       IF tm.b = 'Y' THEN EXECUTE p600_b USING sr.ima01 INTO sr.b END IF 
       IF tm.c = 'Y' THEN EXECUTE p600_c USING sr.ima01 INTO sr.c END IF 
       IF tm.d = 'Y' THEN EXECUTE p600_d USING sr.ima01 INTO sr.d END IF 
       IF tm.e = 'Y' THEN EXECUTE p600_tlf_p USING sr.ima01 INTO sr.e END IF
       IF tm.h = 'Y' THEN EXECUTE p600_h USING sr.ima01 INTO sr.h END IF
       IF cl_null(sr.a) THEN LET sr.a = 0 END IF
       IF cl_null(sr.b) THEN LET sr.b = 0 END IF
       IF cl_null(sr.c) THEN LET sr.c = 0 END IF
       IF cl_null(sr.d) THEN LET sr.d = 0 END IF
       IF cl_null(sr.h) THEN LET sr.h = 0 END IF
       IF cl_null(sr.e) THEN LET sr.e = 0 END IF
       IF cl_null(sr.e1) THEN LET sr.e1 = 0 END IF
       IF tm.e = 'Y' THEN LET sr.e = sr.e * sr.e1 END IF
       
       LET sr.qk = sr.a + sr.b + sr.c + sr.d + sr.h - sr.e - sr.ima27 
       IF tm.f = 'Y' THEN
          IF sr.qk >= 0 THEN CONTINUE FOREACH END IF
          #IF sr.ima38 = 0 OR ((sr.a+sr.b+sr.c+sr.d) <= sr.ima38 ) THEN #预计结存小余补货点或者补货点为0
          LET sr.zx = sr.qk* (-1)
          IF sr.zx < sr.ima46 THEN LET sr.zx = sr.ima46 END IF
          SELECT ceil(sr.zx/sr.ima45)*sr.ima45 INTO sr.zx FROM dual
          IF sr.zx > sr.ima271 AND sr.ima271 > 0  THEN  LET sr.zx = sr.ima271 END IF
       ELSE
          IF sr.qk >= 0 THEN 
             LET sr.zx = 0  
          ELSE
             LET sr.zx = sr.qk* (-1)
             IF sr.zx < sr.ima46 THEN LET sr.zx = sr.ima46 END IF
             SELECT ceil(sr.zx/sr.ima45)*sr.ima45 INTO sr.zx FROM dual
             IF sr.zx > sr.ima271 AND sr.ima271 > 0  THEN  LET sr.zx = sr.ima271 END IF
          END IF
       END IF
 
       EXECUTE insert_prep USING sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     END FOREACH
 
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

     CASE tm.summary_flag
        WHEN '0'  LET g_sql = g_sql," ORDER BY ima01"
        WHEN '1'  LET g_sql = g_sql," ORDER BY ima67"
        WHEN '2'  LET g_sql = g_sql," ORDER BY ima54"
        WHEN '3'  LET g_sql = g_sql," ORDER BY ima06"
     END CASE
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'ima01,ima06,ima67,ima54')
             RETURNING tm.wc
     ELSE
         LET tm.wc = ""
     END IF
     LET g_str = tm.wc
     LET l_name = 'aimp600'
     CALL cl_prt_cs3('aimp600',l_name,g_sql,g_str)   
     IF tm.g ='Y' THEN
        IF cl_confirm('aim-612') THEN
           IF tm.ima08 = 'P' THEN
              CALL ins_pmk() 
           ELSE
              CALL ins_sfb() 
           END IF
        END IF
     END IF
END FUNCTION

FUNCTION ins_sfb()
  DEFINE l_sfb	RECORD LIKE sfb_file.*
  DEFINE l_sql  STRING
  DEFINE li_result        LIKE type_file.num5 
  DEFINE l_item	LIKE ima_file.ima571
  DEFINE sr	RECORD 
                ima01	LIKE ima_file.ima01,
                zx	LIKE type_file.num15_3
                END RECORD
  DEFINE g_cnt,l_cnt	LIKE type_file.num5
  DEFINE l_ima910	LIKE ima_file.ima910
  DEFINE l_ima94	LIKE ima_file.ima94
  DEFINE l_ima59	LIKE ima_file.ima59
  DEFINE l_ima60	LIKE ima_file.ima60
  DEFINE l_ima61	LIKE ima_file.ima61
  DEFINE l_ima601	LIKE ima_file.ima601
  DEFINE l_sfb15	LIKE sfb_file.sfb15
  DEFINE l_time	        LIKE sfb_file.sfb13
  DEFINE l_slip,l_formid         LIKE smy_file.smyslip
  DEFINE l_smy57        LIKE smy_file.smy57
  DEFINE l_minopseq     LIKE type_file.num5
  DEFINE l_btflg	LIKE type_file.chr1
  DEFINE l_no		LIKE type_file.chr50

  LET l_sql = "SELECT ima01,zx FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 order by ima01"
  PREPARE aimp600_asfi301 FROM l_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
     LET g_success = 'N'
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
     EXIT PROGRAM 
  END IF
  DECLARE aimp600_curs_asfi301 CURSOR FOR aimp600_asfi301

 #LET l_sql = " SELECT '",g_user,"'||to_char(sysdate,'YYMMDD') FROM DUAL"  #FUN-C90100
  LET l_sql = " SELECT '",g_user,"'||CAST(sysdate AS 'YYMMDD') FROM DUAL"  #FUN-C90100
  PREPARE aimp600_no FROM l_sql
  EXECUTE aimp600_no INTO l_no

  CALL s_showmsg_init()
  FOREACH aimp600_curs_asfi301 INTO sr.*
     INITIALIZE l_sfb.* TO NULL
     LET l_sfb.sfb01 = tm.pmk01
     LET l_sfb.sfb81 = tm.pmk04
     LET l_sfb.sfb05 = sr.ima01
     LET l_sfb.sfb08 = sr.zx

     LET l_slip = s_get_doc_no(l_sfb.sfb01)   
     SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip

     CALL s_auto_assign_no("asf",l_sfb.sfb01,l_sfb.sfb81,"","","","","","")
          RETURNING li_result,l_sfb.sfb01
     IF (NOT li_result) THEN
        CALL s_errmsg('smyslip',l_sfb.sfb01,'s_auto_assign_no','asf-963',1)
        #ROLLBACK WORK
        CONTINUE FOREACH
        #LET g_success='N'
     END IF
     IF tm.ima08 = 'S' THEN
        LET l_sfb.sfb02 = '7' 
        LET l_sfb.sfb39 = '2'
     ELSE
        LET l_sfb.sfb02 = '1' 
        LET l_sfb.sfb39 = '1'
     END IF
     LET l_sfb.sfb04 = '1'
      #先不給"製程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
      SELECT ima35,ima36,ima571,nvl(ima59,0),nvl(ima60,0),nvl(ima61,0),nvl(ima601,1),ima94
        INTO l_sfb.sfb30,l_sfb.sfb31,l_item,l_ima59,l_ima60,l_ima61,l_ima601,l_ima94
        FROM ima_file
       WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
         #ROLLBACK WORK
         CONTINUE FOREACH 
         #LET g_success = 'N'
      END IF
      IF cl_null(l_item) THEN LET l_item=l_sfb.sfb05 END IF
      IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
      SELECT count(*) INTO l_cnt FROM bma_file  
       WHERE bma01=l_sfb.sfb05
         AND bma05 IS NOT NULL
         AND bma05 <=l_sfb.sfb81
         AND bma06 = l_ima910 
         AND bmaacti = 'Y'     
      IF l_cnt = 0 THEN   #FUN-A50066
         IF l_sfb.sfb02!='5' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='11' THEN 
            CALL s_errmsg('bom',l_sfb.sfb05,'select bom','mfg5071',1)
            #ROLLBACK WORK
            CONTINUE FOREACH
            #LET g_success = 'N'
         END IF  
      END IF

   #--(1)產生工單檔(sfb_file)---------------------------
      LET l_sfb.sfb071= l_sfb.sfb81
      LET l_sfb.sfb081= 0
      LET l_sfb.sfb09 = 0
      LET l_sfb.sfb10 = 0
      LET l_sfb.sfb11 = 0
      LET l_sfb.sfb111= 0
      LET l_sfb.sfb121= 0
      LET l_sfb.sfb122= 0
      LET l_sfb.sfb12 = 0
      LET l_sfb.sfb13 = tm.pmk04 

      LET l_sfb15 = l_sfb.sfb13+(l_ima59+l_ima60/l_ima601*l_sfb.sfb08+l_ima61) 
      SELECT COUNT(*) INTO l_time FROM sme_file
       WHERE sme01 BETWEEN l_sfb.sfb13 AND l_sfb15  AND sme02 = 'N'

      LET l_sfb.sfb15 =l_sfb15+l_time
      IF cl_null(l_sfb.sfb15) THEN LET l_sfb.sfb15 = l_sfb.sfb13 END IF
      LET l_sfb.sfb14 = '00:00'
      LET l_sfb.sfb16 = '00:00'
      LET l_sfb.sfb23 = 'Y'
      LET l_sfb.sfb24 = 'N'
      LET l_sfb.sfb251= l_sfb.sfb81
      LET l_sfb.sfb22 = ''
      LET l_sfb.sfb221= '' 
      LET l_sfb.sfb27 = ' '  
      LET l_sfb.sfb29 = 'Y'
      LET l_sfb.sfb82 = ''         #new[i].ven_no
      LET l_sfb.sfb85 = ' '   
      LET l_sfb.sfb86 = ' '  
      LET l_sfb.sfb87 = 'N'
      LET l_sfb.sfb91 = ' ' 
      LET l_sfb.sfb92 = NULL 
      LET l_sfb.sfb87 = 'N'  
      LET l_sfb.sfb41 = 'N'
      LET l_sfb.sfb44 = g_user 
      LET l_sfb.sfb919= ''   
      LET l_sfb.sfbmksg = 'N' 
      LET l_sfb.sfb43 = '0'   
      IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
         LET l_sfb.sfb99 = 'Y'
      ELSE
         LET l_sfb.sfb99 = 'N'
      END IF
      LET l_sfb.sfb85= ''
      LET l_sfb.sfb17 = NULL  
      LET l_sfb.sfb95= l_ima910
      LET l_sfb.sfb96 = l_no
      LET l_sfb.sfb98 = ''       #new[i].costcenter 
      LET l_sfb.sfbacti = 'Y'
      LET l_sfb.sfbuser = g_user
      LET l_sfb.sfbgrup = g_grup
      LET l_sfb.sfbdate = g_today
      LET l_sfb.sfb1002='N' #保稅核銷否
      LET l_sfb.sfbplant = g_plant
      LET l_sfb.sfblegal = g_legal
      #LET l_sfb.sfb93 = l_ima94
      LET l_sfb.sfb93 = l_smy57[1,1]
      LET l_sfb.sfb94 = l_smy57[2,2]
      LET l_sfb.sfboriu = g_user 
      LET l_sfb.sfborig = g_grup
      LET l_sfb.sfb51 = ''
      LET l_sfb.sfb07 = ''
      LET l_sfb.sfb97 = ''
      LET l_sfb.sfb104 = 'N' 
      IF l_sfb.sfb93='Y' THEN
         LET l_sfb.sfb06 = l_ima94
      END IF
      INSERT INTO sfb_file VALUES(l_sfb.*)
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
         #ROLLBACK WORK
         CONTINUE FOREACH
         #LET g_success='N'
      END IF
      IF l_sfb.sfb93='Y' THEN
         CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                       l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
            RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
      END IF
      IF l_sfb.sfb24 IS NOT NULL THEN
         UPDATE sfb_file
            SET sfb24= l_sfb.sfb24
          WHERE sfb01=l_sfb.sfb01
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('sfb05',l_sfb.sfb05,'update sfb',SQLCA.sqlcode,1)
            #ROLLBACK WORK
            CONTINUE FOREACH
            #LET g_success='N'
         END IF
      END IF

      #-->(2)產生備料檔
      LET l_minopseq=0
      CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq
      LET l_btflg = 'N'
      CASE
         WHEN l_sfb.sfb02='1' OR l_sfb.sfb02='7' #一般工單 or 委外工單 (保留原本asfp304的處理方式)
              LET l_minopseq = 0
              IF s_industry('slk') AND l_sfb.sfb02='1' AND NOT cl_null(l_sfb.sfb06) THEN
                 CALL s_cralc5(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                              l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,l_sfb.sfb06)
                    RETURNING g_cnt
               ELSE
                #CALL s_cralc4(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                        #FUN-C90100 mark
                 CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',                         #FUN-C90100
                               l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                               l_btflg,l_sfb.sfb95)
                 RETURNING g_cnt
               END IF                       #No.FUN-870117
            WHEN l_sfb.sfb02='13'     #預測工單展至尾階
               CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                             ' 1=1',l_sfb.sfb95)
               RETURNING g_cnt
            WHEN l_sfb.sfb02='15'     #試產性工單
               CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                             l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)
               RETURNING g_cnt
            OTHERWISE                 #一般工單展單階
               IF l_sfb.sfb02 = 11 THEN
                  LET l_btflg = 'N'
               ELSE
                  LET l_btflg = 'Y'
               END IF
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-C90100 add ''
                  RETURNING g_cnt
         END CASE
         IF g_cnt = 0 THEN
             CALL s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
             #ROLLBACK WORK
             CONTINUE FOREACH
             #LET g_success = 'N'
         END IF
         CALL s_errmsg('sfb01',l_sfb.sfb01,l_no,'aec-224',1)

         #判斷sfb02若為'5，11'時不產生子工單
         IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
             LET g_msg="asfp301 '",l_sfb.sfb01,"' '",  
                        l_sfb.sfb81,"' '99' 'N'"
             CALL cl_cmdrun_wait(g_msg)
         END IF
      END FOREACH
      CALL s_showmsg() 
  
END FUNCTION

FUNCTION ins_pmk()
DEFINE l_flag,l_i,li_result   LIKE type_file.num5 
DEFINE pmk	   RECORD LIKE pmk_file.*
DEFINE pml	   RECORD LIKE pml_file.*
DEFINE sr1         RECORD
                   fl	LIKE type_file.chr50
                   END RECORD
DEFINE l_sql	STRING
DEFINE l_no     string
DEFINE l_ima02	LIKE ima_file.ima02,
       l_ima44  LIKE ima_file.ima44,
       l_ima24  LIKE ima_file.ima24,
       l_ima25  LIKE ima_file.ima25,
       l_ima48  LIKE ima_file.ima48,
       l_ima49  LIKE ima_file.ima49,
       l_ima491 LIKE ima_file.ima491,
       l_ima913 LIKE ima_file.ima913,
       l_ima914 LIKE ima_file.ima914


     BEGIN WORK
     LET g_success = 'Y'

     CASE tm.summary_flag
          WHEN '0' 
                   LET l_sql = "SELECT 1 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 GROUP BY 1"
          WHEN '1' 
                   LET l_sql = "SELECT ima67 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 GROUP BY ima67"
          WHEN '2' 
                   LET l_sql = "SELECT ima54 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 GROUP BY ima54"
          WHEN '3' 
                   LET l_sql = "SELECT ima06 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 GROUP BY ima06"
     END CASE
     PREPARE aimp600_apmt420 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        LET g_success = 'N'
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE aimp600_curs_apmt420 CURSOR FOR aimp600_apmt420

     CASE tm.summary_flag
          WHEN '0' 
                   LET l_sql = "SELECT ima01,zx FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 AND 1 = ?  order by ima01"
          WHEN '1' 
                   LET l_sql = "SELECT ima01,zx FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 AND ima67 = ? order by ima01"
          WHEN '2' 
                   LET l_sql = "SELECT ima01,zx FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 AND ima54 = ? order by ima01"
          WHEN '3' 
                   LET l_sql = "SELECT ima01,zx FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," WHERE zx > 0 AND ima06 = ? order by ima01"
     END CASE
     PREPARE aimp600_pml FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        LET g_success = 'N'
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE aimp600_ins_pml CURSOR FOR aimp600_pml


       LET l_no = ''
       FOREACH aimp600_curs_apmt420 INTO sr1.*
          IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
          INITIALIZE pmk.* TO NULL
          CALL s_auto_assign_no('apm',tm.pmk01,tm.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,pmk.pmk01
          LET pmk.pmk02 = 'REG'
          LET pmk.pmk03 = '0'
          LET pmk.pmk04 = tm.pmk04
          LET pmk.pmk12 = tm.pmk12
          LET pmk.pmk13 = tm.pmk13
          LET pmk.pmk18 = 'N'
          LET pmk.pmk25 = '0'
          LET pmk.pmk27 = g_today
          LET pmk.pmk30 = 'Y'
          LET pmk.pmk40 = 0
          LET pmk.pmk401= 0
          LET pmk.pmk42 = 1
          LET pmk.pmk43 = 0
          LET pmk.pmk45 = 'Y'
          LET pmk.pmk46 = '1'
          SELECT smyapr,smysign INTO pmk.pmkmksg,pmk.pmksign
            FROM smy_file WHERE smyslip = tm.pmk01
          IF SQLCA.sqlcode OR cl_null(pmk.pmkmksg) THEN
             LET pmk.pmkmksg = 'N'
             LET pmk.pmksign = NULL
          END IF
          LET pmk.pmkdays = 0
          LET pmk.pmksseq = 0
          LET pmk.pmkprno = 0
          CALL signm_count(pmk.pmksign) RETURNING pmk.pmksmax       LET pmk.pmkacti ='Y'
          LET pmk.pmkuser = g_user
          LET pmk.pmkgrup = g_grup
          LET pmk.pmkdate = g_today
          LET pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
          LET pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
          LET pmk.pmkplant = g_plant      #No.FUN-980030 10/01/04
          LET pmk.pmklegal = g_legal      #No.FUN-980030 10/01/04
          LET pmk.pmk47 = g_plant
          LET pmk.pmk48 = TIME
          INSERT INTO pmk_file VALUES(pmk.*)
          LET l_no = l_no,' ',pmk.pmk01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","pmk_file",pmk.pmk01,"",SQLCA.sqlcode,"","",1)
             LET g_success='N'
             EXIT FOREACH
          END IF

          LET l_i = 1
          FOREACH aimp600_ins_pml USING sr1.fl INTO pml.pml04,pml.pml20
             IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

             SELECT ima02,ima44,ima24,ima25 ,ima48,ima49,ima491,ima913,ima914
               INTO l_ima02,l_ima44,l_ima24,l_ima25,l_ima48,l_ima49,l_ima491,l_ima913,l_ima914
               FROM ima_file
              WHERE ima01 = pml.pml04

             LET pml.pml01 = pmk.pmk01
             LET pml.pml011= pmk.pmk02
             LET pml.pml02 = l_i
             LET pml.pml03 = ''
             LET pml.pml041= l_ima02
             LET pml.pml05 = ''
             LET pml.pml06 = ''
             LET pml.pml07 = l_ima44
             LET pml.pml08 = l_ima25
             CALL s_umfchk(pml.pml04,pml.pml07,pml.pml08)
              RETURNING l_flag,pml.pml09
             IF l_flag THEN
                LET pml.pml09=1
             END IF
             LET pml.pml10=l_ima24
             LET pml.pml11='N'
             LET pml.pml12=''
             LET pml.pml121=''
             LET pml.pml122=''
             LET pml.pml123=''
             LET pml.pml13=0
             LET pml.pml14= g_sma.sma886[1,1]
             LET pml.pml15= g_sma.sma886[2,2]
             LET pml.pml16= pmk.pmk25
             #LET pml.pml20= -1*l_diff
             LET pml.pml21=0
             LET pml.pml23='Y'
             LET pml.pml30=0
             LET pml.pml31=0
             LET pml.pml32=0
             CALL s_aday(tm.pmk04,1,l_ima48) RETURNING pml.pml33
             CALL s_aday(pml.pml33,1,l_ima49) RETURNING pml.pml34
             CALL s_aday(pml.pml34,1,l_ima491) RETURNING pml.pml35
             LET pml.pml91=' '
             LET pml.pml49=' '
             LET pml.pml50=' '
             LET pml.pml54='1'
             LET pml.pml56=' '
             LET pml.pml38='Y'
             LET pml.pml42='0'
             LET pml.pml43=0
             LET pml.pml431=0
             LET pml.pml67=pmk.pmk12
             LET pml.pml80=pml.pml07
             LET pml.pml81=pml.pml09
             LET pml.pml82=pml.pml20
             LET pml.pml86=pml.pml07
             LET pml.pml87=pml.pml20
             LET pml.pml190=l_ima913
             LET pml.pml191=l_ima914
             LET pml.pml192='N'
             LET pml.pml91 = 'N'
             LET pml.pml92 = 'N'  #FUN-9B0023
             LET pml.pml49 = '1'
             LET pml.pml50 = '1'  #FUN-9B0023
             LET pml.pml930=s_costcenter(pmk.pmk13)
             LET pml.pmlplant = g_plant      #No.FUN-980030 10/01/04
             LET pml.pmllegal = g_legal      #No.FUN-980030 10/01/04
             INSERT INTO pml_file VALUES(pml.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","pml_file",pml.pml01,pml.pml02,SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_i = l_i+1
             INITIALIZE pml.* TO NULL
          END FOREACH
       END FOREACH
       IF g_success = 'Y' THEN
          CALL cl_err(l_no,'apm-144',1)
          MESSAGE '资料产生成功！'
          COMMIT WORK
       ELSE
          CALL cl_err(l_no,'aps-528',1)
          MESSAGE '资料产生失败！'
          ROLLBACK WORK
       END IF

END FUNCTION
