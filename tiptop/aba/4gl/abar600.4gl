# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abar600.4gl
# Descriptions...: 配貨單列印作業
# Date & Author..: No:DEV-CB0007 2012/11/14 By TSD.JIE
#                  No:DEV-CC0009 2013/01/04 By Nina 在子報表裡增加欄位box11
# Modify.........: No.DEV-D30025 2013/03/11 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds

GLOBALS "../..//config/top.global"

DEFINE tm   RECORD
            wc       STRING,
            wc1      STRING,
            a        LIKE type_file.chr1,
            more     LIKE type_file.chr1
            END RECORD
DEFINE g_i        LIKE type_file.num5
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE l_table1   STRING
DEFINE l_table2   STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql="box01.box_file.box01,", #配货单号
             "box02.box_file.box02,", #配货单项次
             "box12.box_file.box12,", #系列 若非屏风，则存放box02
             "box03.box_file.box03,",
             "box04.box_file.box04,",

             "box05.box_file.box05,",
             "box06.box_file.box06,",
             "box07.box_file.box07,",
             "box08.box_file.box08,",
             "box11.box_file.box11,",

             "box13.box_file.box13,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ima131.ima_file.ima131,",          #系列
             "oba02.oba_file.oba02,",

             "ima25.ima_file.ima25,",            #库存单位
             "oga02.oga_file.oga02,",            #单据日期
             "oga03.oga_file.oga03,",            #账款客户
             "occ02_3.occ_file.occ02,",          #账款客户名称
             "oga04.oga_file.oga04,",            #送货客户

             "occ02_4.occ_file.occ02,",          #送货客户名称
             "occ241.occ_file.occ241,",          #送货地址
             "oga16.oga_file.oga16,",            #订单号
             "oea10.oea_file.oea10 "             #客户订单号

   LET l_table = cl_prt_temptable('abar600',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF

  #LET g_sql="iba06.iba_file.iba06,", #No:DEV-CB0007--mark
   LET g_sql="box12.box_file.box12,", #No:DEV-CB0007--add
             "box11.box_file.box11,", #DEV-CC0009 add
             "boxb01.boxb_file.boxb01,",
             "boxb02.boxb_file.boxb02,",
             "boxb03.boxb_file.boxb03,",
             "boxb04.boxb_file.boxb04,",
             "boxb05.boxb_file.boxb05,",
             "boxb06.boxb_file.boxb06,",
             "boxb07.boxb_file.boxb07,",
             "boxb08.boxb_file.boxb08,",
             "boxb09.boxb_file.boxb09 "

   LET l_table1 = cl_prt_temptable('abar6001',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF

  #No:DEV-CB0007--mark--begin
  #LET l_table2 = cl_prt_temptable('abar6002',g_sql) CLIPPED
  #IF  l_table2 = -1 THEN EXIT PROGRAM END IF
  #No:DEV-CB0007--mark--end

    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"                       
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              #" VALUES(?,?,?,?,?, ?,?,?,?,?)"        #DEV-CC0009 mark
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"      #DEV-CC0009 add
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
              #" VALUES(?,?,?,?,?, ?,?,?,?,?)"        #DEV-CC0009 mark
               " VALUES(?,?,?,?,?, ?,?,?,?,?,?)"      #DEV-CC0009 add
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) EXIT PROGRAM
   END IF

   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET tm.wc    = ARG_VAL(11)
   LET tm.a     = ARG_VAL(12)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL abar600_tm(0,0)        # Input print condition
   ELSE
      CALL abar600()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION abar600_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000

   LET p_row = 4 LET p_col = 16
   OPEN WINDOW abar600_w AT p_row,p_col WITH FORM "aba/42f/abar600"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a = '1'
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON box01
            
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(box01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                   #LET g_qryparam.form = "cq_box" #mark
                    LET g_qryparam.form = "q_box04"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO box01
                    NEXT FIELD box01
               END CASE
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION CONTROLG
            CALL cl_cmdask()    #No.TQC-740008 add

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abar600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abar600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abar600()
      ERROR ""
   END WHILE
   CLOSE WINDOW abar600_w
END FUNCTION


FUNCTION abar600()
DEFINE
    sr              RECORD
             box01	LIKE box_file.box01, #配货单号
             box02	LIKE box_file.box02, #配货单项次
             box12	LIKE box_file.box12, #系列 若非屏风，则存放box02
             box03	LIKE box_file.box03,
             box04	LIKE box_file.box04,
             box05	LIKE box_file.box05,
             box06	LIKE box_file.box06,
             box07	LIKE box_file.box07,
             box08	LIKE box_file.box08,
             box11	LIKE box_file.box11,
             box13	LIKE box_file.box13,
             ima02	LIKE ima_file.ima02,
             ima021	LIKE ima_file.ima021,
             ima131	LIKE ima_file.ima131,
             oba02	LIKE oba_file.oba02,
             ima25	LIKE ima_file.ima25,         #库存单位
             oga02	LIKE oga_file.oga02,         #单据日期
             oga03	LIKE oga_file.oga03,         #账款客户
             occ02_3	LIKE occ_file.occ02,         #账款客户名称
             oga04	LIKE oga_file.oga04,         #送货客户
             occ02_4	LIKE occ_file.occ02,         #送货客户名称
             occ241	LIKE occ_file.occ241,        #送货地址
             oga16	LIKE oga_file.oga16,         #订单号
             oea10	LIKE oea_file.oea10          #客户订单号
       END RECORD,
   #No:DEV-CB0007--mark--begin
   #sr1             RECORD
   #    iba06   LIKE iba_file.iba06,
   #    boxb01  LIKE boxb_file.boxb01,
   #    boxb02  LIKE boxb_file.boxb02,
   #    boxb03  LIKE boxb_file.boxb03,
   #    boxb04  LIKE boxb_file.boxb04,
   #    boxb05  LIKE boxb_file.boxb05,
   #    boxb06  LIKE boxb_file.boxb06,
   #    boxb07  LIKE boxb_file.boxb07,
   #    boxb08  LIKE boxb_file.boxb08,
   #    boxb09  LIKE boxb_file.boxb09
   #    END RECORD,
   #sr1_o             RECORD
   #    iba06   LIKE iba_file.iba06,
   #    boxb01  LIKE boxb_file.boxb01,
   #    boxb02  LIKE boxb_file.boxb02,
   #    boxb03  LIKE boxb_file.boxb03,
   #    boxb04  LIKE boxb_file.boxb04,
   #    boxb05  LIKE boxb_file.boxb05,
   #    boxb06  LIKE boxb_file.boxb06,
   #    boxb07  LIKE boxb_file.boxb07,
   #    boxb08  LIKE boxb_file.boxb08,
   #    boxb09  LIKE boxb_file.boxb09
   #    END RECORD,
   #No:DEV-CB0007--mark--end
    l_boxb      RECORD LIKE boxb_file.*, #No:DEV-CB0007--add
    l_min	LIKE boxb_file.boxb05,
    l_max	LIKE boxb_file.boxb05,
    l_name      LIKE type_file.chr20,  #External(Disk) file name
    l_za05      LIKE za_file.za05,
    l_azi03     LIKE azi_file.azi03,
    l_wc        STRING
DEFINE l_n1     LIKE type_file.num5
DEFINE l_imgb03  LIKE imgb_file.imgb03
DEFINE l_iba01   LIKE iba_file.iba01
DEFINE l_check       LIKE type_file.chr1


    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
   #CALL cl_del_data(l_table2) #No:DEV-CB0012--mrak

    IF cl_null(tm.a) THEN LET tm.a = '1' END IF

    CASE tm.a
      WHEN '1'     #销售出货
       #LET g_sql = "SELECT box01,decode(box11,'axmt610',0,box02),decode(box11,'axmt610',box12,box02),box03,box04,", #No:DEV-CB0012--mark
        LET g_sql = "SELECT box01,box02,box12,box03,box04,", #No:DEV-CB0012--mark
                    "       box05,box06,box07,box08,box11,box13, ",
                    "       ima02,ima021,ima131,oba02,ima25,",
                    "       oga02,oga03,a.occ02,oga04,b.occ02,b.occ241,oga16,oea10 ",          
                    "  FROM box_file,",
                    "       ima_file ",
                    "           LEFT JOIN oba_file ON oba01 = ima131 ,",
                    "       oga_file ",
                    "           LEFT JOIN occ_file a ON a.occ01 = oga03 ",
                    "           LEFT JOIN occ_file b ON b.occ01 = oga04 ",
                    "           LEFT JOIN oea_file   ON oea01   = oga16 ",
                    " WHERE box01 = oga01 AND box04 = ima01 ",
                    "   AND ",tm.wc
      WHEN '2'     #杂发
       #LET g_sql = "SELECT box01,decode(box11,'axmt610',0,box02),decode(box11,'axmt610',box12,box02),box03,box04,", #No:DEV-CB0012--mark
        LET g_sql = "SELECT box01,box02,box12,box03,box04,", #No:DEV-CB0012--mark
                    "       box05,box06,box07,box08,box11,box13, ",
                    "       ima02,ima021,ima131,oba02,ima25,",
                    "       ina02,'','','','','','','' ",        
                    "  FROM box_file,",
                    "       ima_file ",
                    "           LEFT JOIN oba_file ON oba01 = ima131 ,",
                    "       ina_file ",
                    " WHERE box01 = ina01 AND box04 = ima01 ",
                    "   AND ",tm.wc
      WHEN '3'     #跨库调拨
       #LET g_sql = "SELECT box01,decode(box11,'axmt610',0,box02),decode(box11,'axmt610',box12,box02),box03,box04,", #No:DEV-CB0012--mark
        LET g_sql = "SELECT box01,box02,box12,box03,box04,", #No:DEV-CB0012--mark
                    "       box05,box06,box07,box08,box11,box13, ",
                    "       ima02,ima021,ima131,oba02,ima25,",
                    "       imm02,'','','','','','','' ",        
                    "  FROM box_file,",
                    "       ima_file ",
                    "           LEFT JOIN oba_file ON oba01 = ima131 ,",
                    "       imm_file ",
                    " WHERE box01 = imm01 AND box04 = ima01 AND imm10 <> '3' ",
                    "   AND ",tm.wc
     #No:DEV-CB0007--mark--begin
     #WHEN '4'     #跨厂调拨
     #  LET g_sql = "SELECT box01,decode(box11,'axmt610',0,box02),decode(box11,'axmt610',box12,box02),box03,box04,",
     #              "       box05,box06,box07,box08,box11,box13, ",
     #              "       ima02,ima021,ima131,oba02,ima25,",
     #              "       imm02,'','','','','','','' ",
     #              "  FROM box_file,",
     #              "       ima_file ",
     #              "           LEFT JOIN oba_file ON oba01 = ima131 ,",
     #              "       imm_file ",
     #              " WHERE box01 = imm01 AND box04 = ima01 AND imm10 = '3' ",
     #              "   AND ",tm.wc
     #No:DEV-CB0007--mark--end
    END CASE

    #No:DEV-CB0007--add--begin
    CASE
       WHEN tm.a = '1'
          LET g_sql = g_sql ," AND box14 = 'axmt610'"
       WHEN tm.a = '2'
          LET g_sql = g_sql ," AND box14 = 'aimt301'"
       WHEN tm.a = '3'
          LET g_sql = g_sql ," AND box14 = 'aimt324'"
    END CASE
    LET g_sql = g_sql ," AND boxplant = '",g_plant,"'",
                       " AND boxlegal = '",g_legal,"'"
    #No:DEV-CB0007--add--end

    PREPARE r600_p1 FROM g_sql
    IF STATUS THEN CALL cl_err('r600_p1',STATUS,0) END IF

    DECLARE r600_co
        CURSOR FOR r600_p1

    FOREACH r600_co INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:r600_co',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       #No:DEV-CB0007--add--begin
      #DEV-CC0009 mark str-------------
      #IF sr.box11 = 'axmt610' THEN
      #   LET sr.box02 = 0
      #ELSE
      #   LET sr.box12 = sr.box02
      #END IF
      #DEV-CC0009 mark end-------------

       LET g_sql="SELECT boxb_file.* ",
                 "  FROM boxb_file ",
                 " WHERE boxb01 = '",sr.box01,"'",
                 "   AND boxb02 =  ",sr.box02,
                 "   AND boxb03 =  ",sr.box03 #121201 add
       PREPARE r600_p2 FROM g_sql
       IF STATUS THEN CALL cl_err('r600_p2',STATUS,0) END IF
       DECLARE r600_c2 CURSOR FOR r600_p2
       
       FOREACH r600_c2 INTO l_boxb.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:r600_c2',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          EXECUTE insert_prep1 USING sr.box12,
                                     sr.box11,              #DEV-CC0009 add
                                     l_boxb.boxb01,l_boxb.boxb02,
                                     l_boxb.boxb03,l_boxb.boxb04,
                                     l_boxb.boxb05,l_boxb.boxb06,
                                     l_boxb.boxb07,l_boxb.boxb08,
                                     l_boxb.boxb09
       END FOREACH
       #No:DEV-CB0007--add--end

       EXECUTE insert_prep USING sr.*
    END FOREACH

   #No:DEV-CB0007--mark--begin
   #LET g_sql="SELECT decode(iba04,'1',iba06,boxb02),boxb_file.* ",
   #          "  FROM boxb_file,iba_file ",
   #          " WHERE boxb05 = iba01",
   #          "   AND ",tm.wc1
   #PREPARE r600_p2 FROM g_sql
   #IF STATUS THEN CALL cl_err('r600_p2',STATUS,0) END IF
   #DECLARE r600_c2 CURSOR FOR r600_p2

   #FOREACH r600_c2 INTO sr1.*
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err('foreach:r600_c2',SQLCA.sqlcode,1)
   #      EXIT FOREACH
   #   END IF
   #   EXECUTE insert_prep1 USING sr1.*
   #END FOREACH

   #LET g_sql = "select * from ",g_cr_db_str CLIPPED,l_table1 CLIPPED ," ORDER BY 1,2,3,5,6,7,8,10"
   #PREPARE r600_p3 FROM g_sql
   #IF STATUS THEN CALL cl_err('r600_p3',STATUS,0) END IF
   #DECLARE r600_c3 CURSOR FOR r600_p3

   #LET l_min = ''
   #LET l_max = ''
   #INITIALIZE sr1_o.* TO NULL
   #FOREACH r600_c3 INTO sr1.*
   #   IF cl_null(sr1_o.boxb05) THEN #第一笔资料
   #      LET l_min = sr1.boxb05
   #      LET l_max = sr1.boxb05
   #      LET sr1_o.* = sr1.*
   #   ELSE
   #      IF sr1.iba06 = sr1_o.iba06 AND sr1.boxb02 = sr1_o.boxb02 AND sr1.boxb01 = sr1_o.boxb01 THEN  #同一组
   #         IF sr1.boxb04 = sr1_o.boxb04 AND
   #            #sr1.boxb05 = sr1_o.boxb05 AND   #条码判断连号
   #            r600_lh(sr1_o.boxb05,sr1.boxb05) AND
   #            sr1.boxb06 = sr1_o.boxb06 AND
   #            sr1.boxb07 = sr1_o.boxb07 AND
   #            sr1.boxb08 = sr1_o.boxb08 AND
   #            sr1.boxb09 = sr1_o.boxb09 THEN
   #            LET l_max = sr1.boxb05
   #            LET sr1_o.boxb05 = sr1.boxb05
   #        ELSE
   #            IF l_min <> l_max THEN
   #               LET sr1_o.boxb05 = l_min,"\n~",l_max
   #            END IF
   #            EXECUTE insert_prep2 USING sr1_o.*
   #            LET sr1_o.* = sr1.*
   #            LET l_min = sr1.boxb05
   #            LET l_max = sr1.boxb05
   #        END IF
   #      ELSE
   #        IF l_min <> l_max THEN
   #           LET sr1_o.boxb05 = l_min,"\n~",l_max
   #        END IF
   #        EXECUTE insert_prep2 USING sr1_o.*
   #        LET sr1_o.* = sr1.*
   #        LET l_min = sr1.boxb05
   #        LET l_max = sr1.boxb05
   #      END IF
   #   END IF
   #END FOREACH
   #IF l_min <> l_max THEN
   #   LET sr1_o.boxb05 = l_min,"\n~",l_max
   #END IF
   #EXECUTE insert_prep2 USING sr1_o.*
   #No:DEV-CB0007--mark--end


   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
             #"SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED #No:DEV-CB0007--mark
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED #No:DEV-CB0007--add

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'box01')
         RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF

   LET g_str = tm.wc,";",tm.a
    CALL cl_prt_cs3('abar600','abar600',g_sql,g_str)

END FUNCTION

#No:DEV-CB0007--mark--begin
#FUNCTION r600_lh(p_no1,p_no2)
##判断传递的两个条码是否连号
#   DEFINE p_no1,p_no2	LIKE iba_file.iba01
#   DEFINE l_no1,l_no2	LIKE type_file.num20
#   DEFINE l_iba05_1,l_iba05_2 LIKE type_file.chr50
#
#   SELECT substr(iba01,length(trim(decode(iba04,'1',iba05||iba06,iba05)))+1,length(iba01)-length(trim(decode(iba04,'1',iba05||iba06,iba05)))),
#          decode(iba04,'1',iba05||iba06,iba05)
#     INTO l_no1,l_iba05_1
#     FROM iba_file
#    WHERE iba01 = p_no1
#
#   SELECT substr(iba01,length(trim(decode(iba04,'1',iba05||iba06,iba05)))+1,length(iba01)-length(trim(decode(iba04,'1',iba05||iba06,iba05)))) ,
#          decode(iba04,'1',iba05||iba06,iba05)
#     INTO l_no2,l_iba05_2
#     FROM iba_file
#    WHERE iba01 = p_no2
#
#   IF l_iba05_1 =l_iba05_2 AND l_no1 + 1 = l_no2 THEN
#      RETURN TRUE
#   ELSE
#      RETURN FALSE
#   END IF
#END FUNCTION
#No:DEV-CB0007--mark--end
#DEV-D30025--add
