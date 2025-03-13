# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Pattern name...: aglg009.4gl
# Descriptions...: 新舊會計科目轉換明細表
# Date & Author..: No.FUN-9A0036 09/11/03 By chenmoyan
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B80161 11/09/21 By chenying 明細類CR轉GR
# Modify.........: No.FUN-B80161 12/01/05 By qirl FUN-BB0047追单
# Modify.........: No.FUN-C50007 12/05/14 By minpp GR程序优化
# Modify.........: No.FUN-CB0051 12/11/16 By chenying 4rp中的visibility condition在4gl中實現，達到單身無定位點
# Modify.........: No.FUN-CC0085 12/12/24 By chenjing 過單處理 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_a        LIKE type_file.chr1    
DEFINE g_year     LIKE type_file.chr4
DEFINE g_bookno_o LIKE aah_file.aah00
DEFINE g_bookno_n LIKE aah_file.aah00
DEFINE g_str      STRING
DEFINE g_sql      LIKE type_file.chr1000
DEFINE l_table1   LIKE type_file.chr1000
DEFINE l_table2   LIKE type_file.chr1000
DEFINE g_feld DYNAMIC ARRAY OF RECORD
        prog   LIKE zz_file.zz01,
        table  LIKE zta_file.zta01,
        field  LIKE gaq_file.gaq01
        END RECORD
DEFINE g_feld_1 DYNAMIC ARRAY OF RECORD
        prog     LIKE zz_file.zz01,
        table    LIKE zta_file.zta01,
        field_1  LIKE gaq_file.gaq01,
        field_2  LIKE gaq_file.gaq01
        END RECORD



###GENGRE###START
TYPE sr1_t RECORD
    prog LIKE zz_file.zz01,
    progname LIKE gaz_file.gaz03,
    field LIKE type_file.chr30,
    fieldname LIKE type_file.chr30,
    bookno_n LIKE type_file.chr20,
    new LIKE type_file.chr30,
    n_aag02 LIKE type_file.chr100,
    bookno_o LIKE type_file.chr100,
    old LIKE type_file.chr30,
    o_aag02 LIKE type_file.chr30
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80161 mark
   LET g_sql = "prog.zz_file.zz01,",
               "progname.gaz_file.gaz03,",
               "field.type_file.chr30,",
               "fieldname.type_file.chr30,",
               "bookno_n.type_file.chr20,",
               "new.type_file.chr30,",
               "n_aag02.type_file.chr100,",
               "bookno_o.type_file.chr100,",
               "old.type_file.chr30,",
               "o_aag02.type_file.chr30"
   LET l_table1 = cl_prt_temptable('aglg009',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B80161 add
   CALL aglg009_tm(0,0)             # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table1)   #FUN-B80161 
END MAIN

FUNCTION aglg009_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000

   LET p_row = 5 
   LET p_col = 10
   LET g_pdate = g_today  #FUN-B80161
   OPEN WINDOW aglg009_w AT p_row,p_col
        WITH FORM "agl/42f/aglg009"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   
   WHILE TRUE
      INPUT BY NAME g_a,g_year,g_bookno_o,g_bookno_n
         BEFORE INPUT
            LET g_a = '1'
            CALL g009_set_entry()
            CALL g009_set_no_entry()

         AFTER FIELD g_a
            IF g_a='1' THEN
               CALL g009_set_entry()
            ELSE
               CALL g009_set_no_entry()
            END IF
          

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT
  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT 
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_select
            CALL cl_qbe_select()

      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aglg009_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table1)   #FUN-B80161 
         EXIT PROGRAM
            
      END IF
      CALL aglg009()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglg009_w
END FUNCTION


FUNCTION aglg009()
DEFINE i             LIKE type_file.num5
DEFINE l_name        LIKE type_file.chr10

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?) "                                                                                                
   PREPARE insert_prep1 FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80161--add--
      CALL cl_gre_drop_temptable(l_table1)   #FUN-B80161 
      EXIT PROGRAM                                                                             
   END IF        
   CALL cl_del_data(l_table1)
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg009'

   IF g_a=1 THEN
      CALL g009_set_data_1()
      FOR i = 1 TO 253
         CALL g009_tran1(g_feld[i].prog,g_feld[i].table,g_feld[i].field)
      END FOR
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
      LET g_str = ' '
#     LET l_name = 'aglg009'           #FUN-B80161 mark
      LET g_template = 'aglg009'       #FUN-B80161 add 
   ELSE
      CALL g009_set_data_2()
      FOR i = 1 TO 168
         CALL g009_tran2(g_feld_1[i].prog,g_feld_1[i].table,g_feld_1[i].field_1,g_feld_1[i].field_2)
      END FOR
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
      LET g_str = g_year,';',g_bookno_o,';',g_bookno_n
#     LET l_name = 'aglg009_1'         #FUN-B80161 mark
      LET g_template = 'aglg009_1'     #FUN-B80161 add 
   END IF
#  CALL cl_prt_cs1('aglg009',l_name,g_sql,g_str)    #FUN-B80161 mark
   CALL aglg009_grdata()   #FUN-B80161 add
END FUNCTION

FUNCTION g009_set_data_1()
      LET g_feld[1].prog = 'agli104'
      LET g_feld[1].table= 'aab_file'
      LET g_feld[1].field= 'aab01' 

      LET g_feld[2].prog = 'agli108'
      LET g_feld[2].table= 'aac_file'
      LET g_feld[2].field= 'aac04' 

      LET g_feld[3].prog = 'agli1022'
      LET g_feld[3].table= 'aag_file'
      LET g_feld[3].field= 'aag01' 

      LET g_feld[4].prog = 'agli102'
      LET g_feld[4].table= 'aag_file'
      LET g_feld[4].field= 'aag01' 

      LET g_feld[5].prog = 'agli100'
      LET g_feld[5].table= 'aag_file'
      LET g_feld[5].field= 'aag01' 

      LET g_feld[6].prog = 'agli102'
      LET g_feld[6].table= 'aag_file'
      LET g_feld[6].field= 'aag08' 

      LET g_feld[7].prog = 'agli100'
      LET g_feld[7].table= 'aag_file'
      LET g_feld[7].field= 'aag08' 

      LET g_feld[8].prog = 'agli102'
      LET g_feld[8].table= 'aag_file'
      LET g_feld[8].field= 'aag09' 

      LET g_feld[9].prog = 'agli103'
      LET g_feld[9].table= 'aak_file'
      LET g_feld[9].field= 'aak01' 

      LET g_feld[10].prog = 'agli810'
      LET g_feld[10].table= 'abg_file'
      LET g_feld[10].field= 'abg03' 

      LET g_feld[11].prog = 'agli109'
      LET g_feld[11].table= 'aee_file'
      LET g_feld[11].field= 'aee01' 

      LET g_feld[12].prog = 'agli802'
      LET g_feld[12].table= 'afb_file'
      LET g_feld[12].field= 'afb02' 

      LET g_feld[13].prog = 'agli602'
      LET g_feld[13].table= 'afb_file'
      LET g_feld[13].field= 'afb02' 

      LET g_feld[14].prog = 'agli702'
      LET g_feld[14].table= 'afb_file'
      LET g_feld[14].field= 'afb02' 

      LET g_feld[15].prog = 'agli502'
      LET g_feld[15].table= 'afb_file'
      LET g_feld[15].field= 'afb02' 

      LET g_feld[16].prog = 'agli720'
      LET g_feld[16].table= 'ahb_file'
      LET g_feld[16].field= 'ahb03' 

      LET g_feld[17].prog = 'agli710'
      LET g_feld[17].table= 'ahb_file'
      LET g_feld[17].field= 'ahb03' 

      LET g_feld[18].prog = 'agli730'
      LET g_feld[18].table= 'ahb_file'
      LET g_feld[18].field= 'ahb03' 

      LET g_feld[19].prog = 'agli730'
      LET g_feld[19].table= 'ahb_file'
      LET g_feld[19].field= 'ahb16' 

      LET g_feld[20].prog = 'agli120'
      LET g_feld[20].table= 'ahf_file'
      LET g_feld[20].field= 'ahf01' 

      LET g_feld[21].prog = 'agli121'
      LET g_feld[21].table= 'ahh_file'
      LET g_feld[21].field= 'ahh01' 

      LET g_feld[22].prog = 'aapi111'
      LET g_feld[22].table= 'apm_file'
      LET g_feld[22].field= 'apm00' 

      LET g_feld[23].prog = 'aapi101'
      LET g_feld[23].table= 'apm_file'
      LET g_feld[23].field= 'apm00' 

      LET g_feld[24].prog = 'aapi112'
      LET g_feld[24].table= 'apn_file'
      LET g_feld[24].field= 'apn00' 

      LET g_feld[25].prog = 'aapi102'
      LET g_feld[25].table= 'apn_file'
      LET g_feld[25].field= 'apn00' 

      LET g_feld[26].prog = 'aapi202'
      LET g_feld[26].table= 'aps_file'
      LET g_feld[26].field= 'aps11' 

      LET g_feld[27].prog = 'aapi202'
      LET g_feld[27].table= 'aps_file'
      LET g_feld[27].field= 'aps12' 

      LET g_feld[28].prog = 'aapi202'
      LET g_feld[28].table= 'aps_file'
      LET g_feld[28].field= 'aps13' 

      LET g_feld[29].prog = 'aapi702'
      LET g_feld[29].table= 'aps_file'
      LET g_feld[29].field= 'aps22' 

      LET g_feld[30].prog = 'aapi202'
      LET g_feld[30].table= 'aps_file'
      LET g_feld[30].field= 'aps22' 

      LET g_feld[31].prog = 'aapi202'
      LET g_feld[31].table= 'aps_file'
      LET g_feld[31].field= 'aps23' 

      LET g_feld[32].prog = 'aapi702'
      LET g_feld[32].table= 'aps_file'
      LET g_feld[32].field= 'aps233' 

      LET g_feld[33].prog = 'aapi202'
      LET g_feld[33].table= 'aps_file'
      LET g_feld[33].field= 'aps233' 

      LET g_feld[34].prog = 'aapi702'
      LET g_feld[34].table= 'aps_file'
      LET g_feld[34].field= 'aps234' 

      LET g_feld[35].prog = 'aapi202'
      LET g_feld[35].table= 'aps_file'
      LET g_feld[35].field= 'aps234' 

      LET g_feld[36].prog = 'aapi202'
      LET g_feld[36].table= 'aps_file'
      LET g_feld[36].field= 'aps24' 

      LET g_feld[37].prog = 'aapi702'
      LET g_feld[37].table= 'aps_file'
      LET g_feld[37].field= 'aps25' 

      LET g_feld[38].prog = 'aapi202'
      LET g_feld[38].table= 'aps_file'
      LET g_feld[38].field= 'aps25' 

      LET g_feld[39].prog = 'aapi202'
      LET g_feld[39].table= 'aps_file'
      LET g_feld[39].field= 'aps40' 

      LET g_feld[40].prog = 'aapi202'
      LET g_feld[40].table= 'aps_file'
      LET g_feld[40].field= 'aps41' 

      LET g_feld[41].prog = 'aapi702'
      LET g_feld[41].table= 'aps_file'
      LET g_feld[41].field= 'aps42' 

      LET g_feld[42].prog = 'aapi202'
      LET g_feld[42].table= 'aps_file'
      LET g_feld[42].field= 'aps42' 

      LET g_feld[43].prog = 'aapi702'
      LET g_feld[43].table= 'aps_file'
      LET g_feld[43].field= 'aps43' 

      LET g_feld[44].prog = 'aapi202'
      LET g_feld[44].table= 'aps_file'
      LET g_feld[44].field= 'aps43' 

      LET g_feld[45].prog = 'aapi202'
      LET g_feld[45].table= 'aps_file'
      LET g_feld[45].field= 'aps44' 

      LET g_feld[46].prog = 'aapi702'
      LET g_feld[46].table= 'aps_file'
      LET g_feld[46].field= 'aps45' 

      LET g_feld[47].prog = 'aapi202'
      LET g_feld[47].table= 'aps_file'
      LET g_feld[47].field= 'aps45' 

      LET g_feld[48].prog = 'aapi202'
      LET g_feld[48].table= 'aps_file'
      LET g_feld[48].field= 'aps46' 

      LET g_feld[49].prog = 'aapi202'
      LET g_feld[49].table= 'aps_file'
      LET g_feld[49].field= 'aps47' 

      LET g_feld[50].prog = 'aapi702'
      LET g_feld[50].table= 'aps_file'
      LET g_feld[50].field= 'aps51' 

      LET g_feld[51].prog = 'aapi702'
      LET g_feld[51].table= 'aps_file'
      LET g_feld[51].field= 'aps54' 

      LET g_feld[52].prog = 'aapi702'
      LET g_feld[52].table= 'aps_file'
      LET g_feld[52].field= 'aps55' 

      LET g_feld[53].prog = 'aapi202'
      LET g_feld[53].table= 'aps_file'
      LET g_feld[53].field= 'aps56' 

      LET g_feld[54].prog = 'aapi202'
      LET g_feld[54].table= 'aps_file'
      LET g_feld[54].field= 'aps57' 

      LET g_feld[55].prog = 'aapi202'
      LET g_feld[55].table= 'aps_file'
      LET g_feld[55].field= 'aps58' 

      LET g_feld[56].prog = 'aapi203'
      LET g_feld[56].table= 'apt_file'
      LET g_feld[56].field= 'apt03' 

      LET g_feld[57].prog = 'aapi203'
      LET g_feld[57].table= 'apt_file'
      LET g_feld[57].field= 'apt04' 

      LET g_feld[58].prog = 'aapi204'
      LET g_feld[58].table= 'apw_file'
      LET g_feld[58].field= 'apw03' 

      LET g_feld[59].prog = 'agli001'
      LET g_feld[59].table= 'axe_file'
      LET g_feld[59].field= 'axe04' 

      LET g_feld[60].prog = 'agli001'
      LET g_feld[60].table= 'axe_file'
      LET g_feld[60].field= 'axe06' 

      LET g_feld[61].prog = 'agli0011'
      LET g_feld[61].table= 'axee_file'
      LET g_feld[61].field= 'axee04' 

      LET g_feld[62].prog = 'agli0011'
      LET g_feld[62].table= 'axee_file'
      LET g_feld[62].field= 'axee06' 

      LET g_feld[63].prog = 'agli0031'
      LET g_feld[63].table= 'axf_file'
      LET g_feld[63].field= 'axf01' 

      LET g_feld[64].prog = 'agli003'
      LET g_feld[64].table= 'axf_file'
      LET g_feld[64].field= 'axf01' 

      LET g_feld[65].prog = 'agli0033'
      LET g_feld[65].table= 'axf_file'
      LET g_feld[65].field= 'axf02' 

      LET g_feld[66].prog = 'agli0032'
      LET g_feld[66].table= 'axf_file'
      LET g_feld[66].field= 'axf02' 

      LET g_feld[67].prog = 'agli003'
      LET g_feld[67].table= 'axf_file'
      LET g_feld[67].field= 'axf02' 

      LET g_feld[68].prog = 'agli003'
      LET g_feld[68].table= 'axf_file'
      LET g_feld[68].field= 'axf04' 

      LET g_feld[69].prog = 'agli003'
      LET g_feld[69].table= 'axf_file'
      LET g_feld[69].field= 'axf15' 

      LET g_feld[70].prog = 'agli008'
      LET g_feld[70].table= 'axp_file'
      LET g_feld[70].field= 'axp09' 

      LET g_feld[71].prog = 'agli011'
      LET g_feld[71].table= 'axr_file'
      LET g_feld[71].field= 'axr03' 

      LET g_feld[72].prog = 'agli011'
      LET g_feld[72].table= 'axr_file'
      LET g_feld[72].field= 'axr07' 

      LET g_feld[73].prog = 'agli0031'
      LET g_feld[73].table= 'axs_file'
      LET g_feld[73].field= 'axs03' 

      LET g_feld[74].prog = 'agli0033'
      LET g_feld[74].table= 'axt_file'
      LET g_feld[74].field= 'axt03' 

      LET g_feld[75].prog = 'agli0032'
      LET g_feld[75].table= 'axt_file'
      LET g_feld[75].field= 'axt03' 

      LET g_feld[76].prog = 'agli0033'
      LET g_feld[76].table= 'axu_file'
      LET g_feld[76].field= 'axu04' 

      LET g_feld[77].prog = 'agli012'
      LET g_feld[77].table= 'axv_file'
      LET g_feld[77].field= 'axv09' 

      LET g_feld[78].prog = 'agli012'
      LET g_feld[78].table= 'axv_file'
      LET g_feld[78].field= 'axv10' 

      LET g_feld[79].prog = 'agli151'
      LET g_feld[79].table= 'ayb_file'
      LET g_feld[79].field= 'ayb02' 

      LET g_feld[80].prog = 'agli016'
      LET g_feld[80].table= 'ayc_file'
      LET g_feld[80].field= 'ayc10' 

      LET g_feld[81].prog = 'aooi312'
      LET g_feld[81].table= 'azf_file'
      LET g_feld[81].field= 'azf05' 

      LET g_feld[82].prog = 'aooi300'
      LET g_feld[82].table= 'azf_file'
      LET g_feld[82].field= 'azf05' 

      LET g_feld[83].prog = 'aooi300'
      LET g_feld[83].table= 'azf_file'
      LET g_feld[83].field= 'azf051' 

      LET g_feld[84].prog = 'aooi300'
      LET g_feld[84].table= 'azf_file'
      LET g_feld[84].field= 'azf07' 

      LET g_feld[85].prog = 'aooi300'
      LET g_feld[85].table= 'azf_file'
      LET g_feld[85].field= 'azf14' 

      LET g_feld[86].prog = 'abgi200'
      LET g_feld[86].table= 'bgq_file'
      LET g_feld[86].field= 'bgq04' 

      LET g_feld[87].prog = 'abgi600'
      LET g_feld[87].table= 'bgu_file'
      LET g_feld[87].field= 'bgu032' 

      LET g_feld[88].prog = 'abgi500'
      LET g_feld[88].table= 'bgw_file'
      LET g_feld[88].field= 'bgw11' 

      LET g_feld[89].prog = 'abgi130'
      LET g_feld[89].table= 'bgx04'
      LET g_feld[89].field= 'bgx_file' 

      LET g_feld[90].prog = 'abgi410'
      LET g_feld[90].table= 'bhc_file'
      LET g_feld[90].field= 'bhc04' 

      LET g_feld[91].prog = 'abgi300'
      LET g_feld[91].table= 'bhe_file'
      LET g_feld[91].field= 'bhe02' 

      LET g_feld[92].prog = 'abgi300'
      LET g_feld[92].table= 'bhe_file'
      LET g_feld[92].field= 'bhe03' 

      LET g_feld[93].prog = 'abgi300'
      LET g_feld[93].table= 'bhe_file'
      LET g_feld[93].field= 'bhe04' 

      LET g_feld[94].prog = 'abgi301'
      LET g_feld[94].table= 'bhe_file'
      LET g_feld[94].field= 'bhe06' 

      LET g_feld[95].prog = 'axci040'
      LET g_feld[95].table= 'caa_file'
      LET g_feld[95].field= 'caa05' 

      LET g_feld[96].prog = 'axci001'
      LET g_feld[96].table= 'cay_file'
      LET g_feld[96].field= 'cay06' 

      LET g_feld[97].prog = 'axci001'
      LET g_feld[97].table= 'cay_file'
      LET g_feld[97].field= 'cay10' 

      LET g_feld[98].prog = 'axci041'
      LET g_feld[98].table= 'cda_file'
      LET g_feld[98].field= 'cda05' 

      LET g_feld[99].prog = 'apyi040'
      LET g_feld[99].table= 'cph_file'
      LET g_feld[99].field= 'cph19' 

      LET g_feld[100].prog = 'apyi040'
      LET g_feld[100].table= 'cph_file'
      LET g_feld[100].field= 'cph101' 

      LET g_feld[101].prog = 'apyi108'
      LET g_feld[101].table= 'cqq_file'
      LET g_feld[101].field= 'cqq03' 

      LET g_feld[102].prog = 'axci010'
      LET g_feld[102].table= 'cxg_file'
      LET g_feld[102].field= 'cxg05' 

      LET g_feld[103].prog = 'axci010'
      LET g_feld[103].table= 'cxg_file'
      LET g_feld[103].field= 'cxg051' 

      LET g_feld[104].prog = 'axci010'
      LET g_feld[104].table= 'cxg_file'
      LET g_feld[104].field= 'cxg051c' 

      LET g_feld[105].prog = 'axci010'
      LET g_feld[105].table= 'cxg_file'
      LET g_feld[105].field= 'cxg05c' 

      LET g_feld[106].prog = 'axci101'
      LET g_feld[106].table= 'cxi_file'
      LET g_feld[106].field= 'cxi04' 

      LET g_feld[107].prog = 'apyi102'
      LET g_feld[107].table= 'czy_file'
      LET g_feld[107].field= 'czy07' 

      LET g_feld[108].prog = 'aeci603'
      LET g_feld[108].table= 'ecc_file'
      LET g_feld[108].field= 'ecc02' 

      LET g_feld[109].prog = 'aeci603'
      LET g_feld[109].table= 'ecc_file'
      LET g_feld[109].field= 'ecc03' 

      LET g_feld[110].prog = 'aeci603'
      LET g_feld[110].table= 'ecc_file'
      LET g_feld[110].field= 'ecc04' 

      LET g_feld[111].prog = 'aeci603'
      LET g_feld[111].table= 'ecc_file'
      LET g_feld[111].field= 'ecc05' 

      LET g_feld[112].prog = 'afai010'
      LET g_feld[112].table= 'fab_file'
      LET g_feld[112].field= 'fab11' 

      LET g_feld[113].prog = 'afai010'
      LET g_feld[113].table= 'fab_file'
      LET g_feld[113].field= 'fab12' 

      LET g_feld[114].prog = 'afai010'
      LET g_feld[114].table= 'fab_file'
      LET g_feld[114].field= 'fab13' 

      LET g_feld[115].prog = 'afai010'
      LET g_feld[115].table= 'fab_file'
      LET g_feld[115].field= 'fab24' 

      LET g_feld[116].prog = 'afai030'
      LET g_feld[116].table= 'fad_file'
      LET g_feld[116].field= 'fad03' 

      LET g_feld[117].prog = 'afai030'
      LET g_feld[117].table= 'fad_file'
      LET g_feld[117].field= 'fad031' 

      LET g_feld[118].prog = 'afai030'
      LET g_feld[118].table= 'fae_file'
      LET g_feld[118].field= 'fae07' 

      LET g_feld[119].prog = 'afai030'
      LET g_feld[119].table= 'fae_file'
      LET g_feld[119].field= 'fae071' 

      LET g_feld[120].prog = 'afai030'
      LET g_feld[120].table= 'fae_file'
      LET g_feld[120].field= 'fae09' 

      LET g_feld[121].prog = 'afai100'
      LET g_feld[121].table= 'faj_file'
      LET g_feld[121].field= 'faj53' 

      LET g_feld[122].prog = 'aemi100'
      LET g_feld[122].table= 'faj_file'
      LET g_feld[122].field= 'faj53' 

      LET g_feld[123].prog = 'afai100'
      LET g_feld[123].table= 'faj_file'
      LET g_feld[123].field= 'faj54' 

      LET g_feld[124].prog = 'afai100'
      LET g_feld[124].table= 'faj_file'
      LET g_feld[124].field= 'faj55' 

      LET g_feld[125].prog = 'afai101'
      LET g_feld[125].table= 'fak_file'
      LET g_feld[125].field= 'fak53' 

      LET g_feld[126].prog = 'afai101'
      LET g_feld[126].table= 'fak_file'
      LET g_feld[126].field= 'fak54' 

      LET g_feld[127].prog = 'afai101'
      LET g_feld[127].table= 'fak_file'
      LET g_feld[127].field= 'fak55' 

      LET g_feld[128].prog = 'afai900'
      LET g_feld[128].table= 'fan_file'
      LET g_feld[128].field= 'fan11' 

      LET g_feld[129].prog = 'afai900'
      LET g_feld[129].table= 'fan_file'
      LET g_feld[129].field= 'fan12' 

      LET g_feld[130].prog = 'afai901'
      LET g_feld[130].table= 'fao_file'
      LET g_feld[130].field= 'fao11' 

      LET g_feld[131].prog = 'afai901'
      LET g_feld[131].table= 'fao_file'
      LET g_feld[131].field= 'fao12' 

      LET g_feld[132].prog = 'afai080'
      LET g_feld[132].table= 'fbi_file'
      LET g_feld[132].field= 'fbi02' 

      LET g_feld[133].prog = 'afai090'
      LET g_feld[133].table= 'fbz_file'
      LET g_feld[133].field= 'fbz05' 

      LET g_feld[134].prog = 'afai090'
      LET g_feld[134].table= 'fbz_file'
      LET g_feld[134].field= 'fbz06' 

      LET g_feld[135].prog = 'afai090'
      LET g_feld[135].table= 'fbz_file'
      LET g_feld[135].field= 'fbz07' 

      LET g_feld[136].prog = 'afai090'
      LET g_feld[136].table= 'fbz_file'
      LET g_feld[136].field= 'fbz08' 

      LET g_feld[137].prog = 'afai090'
      LET g_feld[137].table= 'fbz_file'
      LET g_feld[137].field= 'fbz09' 

      LET g_feld[138].prog = 'afai090'
      LET g_feld[138].table= 'fbz_file'
      LET g_feld[138].field= 'fbz10' 

      LET g_feld[139].prog = 'afai090'
      LET g_feld[139].table= 'fbz_file'
      LET g_feld[139].field= 'fbz11' 

      LET g_feld[140].prog = 'afai090'
      LET g_feld[140].table= 'fbz_file'
      LET g_feld[140].field= 'fbz12' 

      LET g_feld[141].prog = 'afai090'
      LET g_feld[141].table= 'fbz_file'
      LET g_feld[141].field= 'fbz13' 

      LET g_feld[142].prog = 'afai090'
      LET g_feld[142].table= 'fbz_file'
      LET g_feld[142].field= 'fbz14' 

      LET g_feld[143].prog = 'afai090'
      LET g_feld[143].table= 'fbz_file'
      LET g_feld[143].field= 'fbz15' 

      LET g_feld[144].prog = 'afai090'
      LET g_feld[144].table= 'fbz_file'
      LET g_feld[144].field= 'fbz16' 

      LET g_feld[145].prog = 'afai090'
      LET g_feld[145].table= 'fbz_file'
      LET g_feld[145].field= 'fbz17' 

      LET g_feld[146].prog = 'afai090'
      LET g_feld[146].table= 'fbz_file'
      LET g_feld[146].field= 'fbz18' 

      LET g_feld[147].prog = 'afai550'
      LET g_feld[147].table= 'fcx_file'
      LET g_feld[147].field= 'fcx09' 

      LET g_feld[148].prog = 'afai550'
      LET g_feld[148].table= 'fcx_file'
      LET g_feld[148].field= 'fcx10' 

      LET g_feld[149].prog = 'afai500'
      LET g_feld[149].table= 'fdd_file'
      LET g_feld[149].field= 'fdd08' 

      LET g_feld[150].prog = 'afai500'
      LET g_feld[150].table= 'fdd_file'
      LET g_feld[150].field= 'fdd09' 

      LET g_feld[151].prog = 'aooi150'
      LET g_feld[151].table= 'gec_file'
      LET g_feld[151].field= 'gec03' 

      LET g_feld[152].prog = 'agli933'
      LET g_feld[152].table= 'gin_file'
      LET g_feld[152].field= 'gin02' 

      LET g_feld[153].prog = 'agli931'
      LET g_feld[153].table= 'gis_file'
      LET g_feld[153].field= 'gis02' 

      LET g_feld[154].prog = 'agli932'
      LET g_feld[154].table= 'git_file'
      LET g_feld[154].field= 'git02' 

      LET g_feld[155].prog = 'agli010'
      LET g_feld[155].table= 'giu_file'
      LET g_feld[155].field= 'giu01' 

      LET g_feld[156].prog = 'agli010'
      LET g_feld[156].table= 'giu_file'
      LET g_feld[156].field= 'giu08' 

      LET g_feld[157].prog = 'agli010'
      LET g_feld[157].table= 'giu_file'
      LET g_feld[157].field= 'giu09' 

      LET g_feld[158].prog = 'anmi600'
      LET g_feld[158].table= 'gsa_file'
      LET g_feld[158].field= 'gsa04' 

      LET g_feld[159].prog = 'anmi600'
      LET g_feld[159].table= 'gsa_file'
      LET g_feld[159].field= 'gsa05' 

      LET g_feld[160].prog = 'anmi600'
      LET g_feld[160].table= 'gsa_file'
      LET g_feld[160].field= 'gsa06' 

      LET g_feld[161].prog = 'anmi601'
      LET g_feld[161].table= 'gsf_file'
      LET g_feld[161].field= 'gsf04' 

      LET g_feld[162].prog = 'anmi601'
      LET g_feld[162].table= 'gsf_file'
      LET g_feld[162].field= 'gsf041' 

      LET g_feld[163].prog = 'axmi121'
      LET g_feld[163].table= 'ima_file'
      LET g_feld[163].field= 'ima132' 

      LET g_feld[164].prog = 'aimi105'
      LET g_feld[164].table= 'ima_file'
      LET g_feld[164].field= 'ima39' 

      LET g_feld[165].prog = 'aimi100'
      LET g_feld[165].table= 'ima_file'
      LET g_feld[165].field= 'ima39' 

      LET g_feld[166].prog = 'aimi152'
      LET g_feld[166].table= 'imaa_file'
      LET g_feld[166].field= 'imaa132' 

      LET g_feld[167].prog = 'aimi155'
      LET g_feld[167].table= 'imaa_file'
      LET g_feld[167].field= 'imaa39' 

      LET g_feld[168].prog = 'aimi150'
      LET g_feld[168].table= 'imaa_file'
      LET g_feld[168].field= 'imaa39' 

      LET g_feld[169].prog = 'aimi201' 
      LET g_feld[169].table= 'imd_file'
      LET g_feld[169].field= 'imd08' 

      LET g_feld[170].prog = 'aimi201'
      LET g_feld[170].table= 'ime_file'
      LET g_feld[170].field= 'ime08' 

      LET g_feld[171].prog = 'aimi201'
      LET g_feld[171].table= 'ime_file'
      LET g_feld[171].field= 'ime09' 

      LET g_feld[172].prog = 'aimp701'
      LET g_feld[172].table= 'img_file'
      LET g_feld[172].field= 'img26' 

      LET g_feld[173].prog = 'aimp401'
      LET g_feld[173].table= 'imn_file'
      LET g_feld[173].field= 'imn07' 

      LET g_feld[174].prog = 'aimp400'
      LET g_feld[174].table= 'imn_file'
      LET g_feld[174].field= 'imn07' 

      LET g_feld[175].prog = 'aimt701'
      LET g_feld[175].table= 'imn_file'
      LET g_feld[175].field= 'imn07' 

      LET g_feld[176].prog = 'aimp700'
      LET g_feld[176].table= 'imn_file'
      LET g_feld[176].field= 'imn07' 

      LET g_feld[177].prog = 'aimt306'
      LET g_feld[177].table= 'imo_file'
      LET g_feld[177].field= 'imo05' 

      LET g_feld[178].prog = 'aimi111'
      LET g_feld[178].table= 'imz_file'
      LET g_feld[178].field= 'imz132' 

      LET g_feld[179].prog = 'aimi110'
      LET g_feld[179].table= 'imz_file'
      LET g_feld[179].field= 'imz39' 

      LET g_feld[180].prog = 'agli116'
      LET g_feld[180].table= 'maj_file'
      LET g_feld[180].field= 'maj21' 

      LET g_feld[181].prog = 'agli116'
      LET g_feld[181].table= 'maj_file'
      LET g_feld[181].field= 'maj22' 

      LET g_feld[182].prog = 'anmi030'
      LET g_feld[182].table= 'nma_file'
      LET g_feld[182].field= 'nma05' 

      LET g_feld[183].prog = 'anmi032'
      LET g_feld[183].table= 'nmc_file'
      LET g_feld[183].field= 'nmc04' 

      LET g_feld[184].prog = 'anmi702'
      LET g_feld[184].table= 'nmq_file'
      LET g_feld[184].field= 'nmq01' 

      LET g_feld[185].prog = 'anmi702'
      LET g_feld[185].table= 'nmq_file'
      LET g_feld[185].field= 'nmq02' 

      LET g_feld[186].prog = 'anmi702'
      LET g_feld[186].table= 'nmq_file'
      LET g_feld[186].field= 'nmq10' 

      LET g_feld[187].prog = 'anmi702'
      LET g_feld[187].table= 'nmq_file'
      LET g_feld[187].field= 'nmq11' 

      LET g_feld[188].prog = 'anmi930'
      LET g_feld[188].table= 'nmq_file'
      LET g_feld[188].field= 'nmq21' 

      LET g_feld[189].prog = 'anmi930'
      LET g_feld[189].table= 'nmq_file'
      LET g_feld[189].field= 'nmq22' 

      LET g_feld[190].prog = 'anmi930'
      LET g_feld[190].table= 'nmq_file'
      LET g_feld[190].field= 'nmq23' 

      LET g_feld[191].prog = 'anmi930'
      LET g_feld[191].table= 'nmq_file'
      LET g_feld[191].field= 'nmq24' 

      LET g_feld[192].prog = 'anmi040'
      LET g_feld[192].table= 'nms_file'
      LET g_feld[192].field= 'nms12' 

      LET g_feld[193].prog = 'anmi040'
      LET g_feld[193].table= 'nms_file'
      LET g_feld[193].field= 'nms13' 

      LET g_feld[194].prog = 'anmi040'
      LET g_feld[194].table= 'nms_file'
      LET g_feld[194].field= 'nms15' 

      LET g_feld[195].prog = 'anmi040'
      LET g_feld[195].table= 'nms_file'
      LET g_feld[195].field= 'nms22' 

      LET g_feld[196].prog = 'anmi040'
      LET g_feld[196].table= 'nms_file'
      LET g_feld[196].field= 'nms28' 

      LET g_feld[197].prog = 'anmi700'
      LET g_feld[197].table= 'nnn_file'
      LET g_feld[197].field= 'nnn04' 

      LET g_feld[198].prog = 'anmi700'
      LET g_feld[198].table= 'nnn_file'
      LET g_feld[198].field= 'nnn041' 

      LET g_feld[199].prog = 'agli014'
      LET g_feld[199].table= 'npq_file'
      LET g_feld[199].field= 'npq03' 

      LET g_feld[200].prog = 'axci100'
      LET g_feld[200].table= 'npq_file'
      LET g_feld[200].field= 'npq03' 

      LET g_feld[201].prog = 'apyi107'
      LET g_feld[201].table= 'npq_file'
      LET g_feld[201].field= 'npq03' 

      LET g_feld[202].prog = 'agli130'
      LET g_feld[202].table= 'npr_file'
      LET g_feld[202].field= 'npr00' 

      LET g_feld[203].prog = 'axmi110'
      LET g_feld[203].table= 'oba_file'
      LET g_feld[203].field= 'oba11' 

      LET g_feld[204].prog = 'axmi210'
      LET g_feld[204].table= 'oca_file'
      LET g_feld[204].field= 'oca03' 

      LET g_feld[207].prog = 'axri040'
      LET g_feld[207].table= 'ooc_file'
      LET g_feld[207].field= 'ooc03' 

      LET g_feld[208].prog = 'axri090'
      LET g_feld[208].table= 'ool_file'
      LET g_feld[208].field= 'ool11' 

      LET g_feld[209].prog = 'axri090'
      LET g_feld[209].table= 'ool_file'
      LET g_feld[209].field= 'ool12' 

      LET g_feld[210].prog = 'axri090'
      LET g_feld[210].table= 'ool_file'
      LET g_feld[210].field= 'ool13' 

      LET g_feld[211].prog = 'axri090'
      LET g_feld[211].table= 'ool_file'
      LET g_feld[211].field= 'ool14' 

      LET g_feld[212].prog = 'axri090'
      LET g_feld[212].table= 'ool_file'
      LET g_feld[212].field= 'ool15' 

      LET g_feld[213].prog = 'axri090'
      LET g_feld[213].table= 'ool_file'
      LET g_feld[213].field= 'ool21' 

      LET g_feld[214].prog = 'axri090'
      LET g_feld[214].table= 'ool_file'
      LET g_feld[214].field= 'ool22' 

      LET g_feld[215].prog = 'axri090'
      LET g_feld[215].table= 'ool_file'
      LET g_feld[215].field= 'ool23' 

      LET g_feld[216].prog = 'axri090'
      LET g_feld[216].table= 'ool_file'
      LET g_feld[216].field= 'ool24' 

      LET g_feld[217].prog = 'axri090'
      LET g_feld[217].table= 'ool_file'
      LET g_feld[217].field= 'ool25' 

      LET g_feld[218].prog = 'axri090'
      LET g_feld[218].table= 'ool_file'
      LET g_feld[218].field= 'ool26' 

      LET g_feld[219].prog = 'axri090'
      LET g_feld[219].table= 'ool_file'
      LET g_feld[219].field= 'ool27' 

      LET g_feld[220].prog = 'axri090'
      LET g_feld[220].table= 'ool_file'
      LET g_feld[220].field= 'ool28' 

      LET g_feld[221].prog = 'axri090'
      LET g_feld[221].table= 'ool_file'
      LET g_feld[221].field= 'ool41' 

      LET g_feld[222].prog = 'axri090'
      LET g_feld[222].table= 'ool_file'
      LET g_feld[222].field= 'ool42' 

      LET g_feld[223].prog = 'axri090'
      LET g_feld[223].table= 'ool_file'
      LET g_feld[223].field= 'ool43' 

      LET g_feld[224].prog = 'axri090'
      LET g_feld[224].table= 'ool_file'
      LET g_feld[224].field= 'ool45' 

      LET g_feld[225].prog = 'axri090'
      LET g_feld[225].table= 'ool_file'
      LET g_feld[225].field= 'ool46' 

      LET g_feld[226].prog = 'axri090'
      LET g_feld[226].table= 'ool_file'
      LET g_feld[226].field= 'ool47' 

      LET g_feld[227].prog = 'axri090'
      LET g_feld[227].table= 'ool_file'
      LET g_feld[227].field= 'ool51' 

      LET g_feld[228].prog = 'axri090'
      LET g_feld[228].table= 'ool_file'
      LET g_feld[228].field= 'ool52' 

      LET g_feld[229].prog = 'axri090'
      LET g_feld[229].table= 'ool_file'
      LET g_feld[229].field= 'ool53' 

      LET g_feld[230].prog = 'axri090'
      LET g_feld[230].table= 'ool_file'
      LET g_feld[230].field= 'ool54' 

      LET g_feld[231].prog = 'axri500'
      LET g_feld[231].table= 'ooo_file'
      LET g_feld[231].field= 'ooo03' 

      LET g_feld[232].prog = 'aimt826'
      LET g_feld[232].table= 'pia_file'
      LET g_feld[232].field= 'pia07' 

      LET g_feld[233].prog = 'aimt820'
      LET g_feld[233].table= 'pia_file'
      LET g_feld[233].field= 'pia07' 

      LET g_feld[234].prog = 'aimt821'
      LET g_feld[234].table= 'pia_file'
      LET g_feld[234].field= 'pia07' 

      LET g_feld[235].prog = 'aimt900'
      LET g_feld[235].table= 'pia_file'
      LET g_feld[235].field= 'pia07' 

      LET g_feld[236].prog = 'aimt850'
      LET g_feld[236].table= 'pia_file'
      LET g_feld[236].field= 'pia07' 

      LET g_feld[237].prog = 'aimt851'
      LET g_feld[237].table= 'pia_file'
      LET g_feld[237].field= 'pia07' 

      LET g_feld[238].prog = 'aimt860'
      LET g_feld[238].table= 'pia_file'
      LET g_feld[238].field= 'pia07' 

      LET g_feld[239].prog = 'aimt836'
      LET g_feld[239].table= 'pia_file'
      LET g_feld[239].field= 'pia07' 

      LET g_feld[240].prog = 'aimt822'
      LET g_feld[240].table= 'piaa_file'
      LET g_feld[240].field= 'piaa07' 

      LET g_feld[241].prog = 'aimt828'
      LET g_feld[241].table= 'piaa_file'
      LET g_feld[241].field= 'piaa07' 

      LET g_feld[242].prog = 'aimt852'
      LET g_feld[242].table= 'piaa_file'
      LET g_feld[242].field= 'piaa07' 

      LET g_feld[243].prog = 'aimt838'
      LET g_feld[243].table= 'piaa_file'
      LET g_feld[243].field= 'piaa07' 

      LET g_feld[244].prog = 'apji200'
      LET g_feld[244].table= 'pjg_file'
      LET g_feld[244].field= 'pjg03' 

      LET g_feld[245].prog = 'aict040'
      LET g_feld[245].table= 'pmn_file'
      LET g_feld[245].field= 'pmn40' 

      LET g_feld[246].prog = 'apmi650'
      LET g_feld[246].table= 'pnr_file'
      LET g_feld[246].field= 'pnr02' 

      LET g_feld[247].prog = 'asft670'
      LET g_feld[247].table= 'sfl_file'
      LET g_feld[247].field= 'sfl09' 

      LET g_feld[248].prog = 'aeci020'
      LET g_feld[248].table= 'sgb_file'
      LET g_feld[248].field= 'sgb06' 

      LET g_feld[249].prog = 'atmi217'
      LET g_feld[249].table= 'tqe_file'
      LET g_feld[249].field= 'tqe06' 

      LET g_feld[250].prog = 'atmi217'
      LET g_feld[250].table= 'tqe_file'
      LET g_feld[250].field= 'tqe07' 

      LET g_feld[251].prog = 'atmi217'
      LET g_feld[251].table= 'tqe_file'
      LET g_feld[251].field= 'tqe09' 

      LET g_feld[252].prog = 'atmi217'
      LET g_feld[252].table= 'tqe_file'
      LET g_feld[252].field= 'tqe10' 

      LET g_feld[253].prog = 'apyi807'
      LET g_feld[253].table= 'trh_file'
      LET g_feld[253].field= 'trh01' 
END FUNCTION
FUNCTION g009_set_data_2()
      LET g_feld_1[1].prog = 'aapi202'
      LET g_feld_1[1].table= 'aps_file'
      LET g_feld_1[1].field_1 = 'aps11' 
      LET g_feld_1[1].field_2 = 'aps111'

      LET g_feld_1[2].prog = 'aapi202'
      LET g_feld_1[2].table= 'aps_file'
      LET g_feld_1[2].field_1 = 'aps12' 
      LET g_feld_1[2].field_2 = 'aps121'

      LET g_feld_1[3].prog = 'aapi202'
      LET g_feld_1[3].table= 'aps_file'
      LET g_feld_1[3].field_1 = 'aps13' 
      LET g_feld_1[3].field_2 = 'aps131'

      LET g_feld_1[4].prog = 'aapi702'
      LET g_feld_1[4].table= 'aps_file'
      LET g_feld_1[4].field_1 = 'aps14' 
      LET g_feld_1[4].field_2 = 'aps141'

      LET g_feld_1[5].prog = 'aapi202'
      LET g_feld_1[5].table= 'aps_file'
      LET g_feld_1[5].field_1 = 'aps14' 
      LET g_feld_1[5].field_2 = 'aps141'

      LET g_feld_1[6].prog = 'aapi202'
      LET g_feld_1[6].table= 'aps_file'
      LET g_feld_1[6].field_1 = 'aps21' 
      LET g_feld_1[6].field_2 = 'aps211'

      LET g_feld_1[7].prog = 'aapi702'
      LET g_feld_1[7].table= 'aps_file'
      LET g_feld_1[7].field_1 = 'aps22' 
      LET g_feld_1[7].field_2 = 'aps221'

      LET g_feld_1[8].prog = 'aapi202'
      LET g_feld_1[8].table= 'aps_file'
      LET g_feld_1[8].field_1 = 'aps22' 
      LET g_feld_1[8].field_2 = 'aps221'

      LET g_feld_1[9].prog = 'aapi202'
      LET g_feld_1[9].table= 'aps_file'
      LET g_feld_1[9].field_1 = 'aps23' 
      LET g_feld_1[9].field_2 = 'aps235'

      LET g_feld_1[10].prog = 'aapi202'
      LET g_feld_1[10].table= 'aps_file'
      LET g_feld_1[10].field_1 = 'aps231' 
      LET g_feld_1[10].field_2 = 'aps236'

      LET g_feld_1[11].prog = 'aapi202'
      LET g_feld_1[11].table= 'aps_file'
      LET g_feld_1[11].field_1 = 'aps232' 
      LET g_feld_1[11].field_2 = 'aps237'

      LET g_feld_1[12].prog = 'aapi702'
      LET g_feld_1[12].table= 'aps_file'
      LET g_feld_1[12].field_1 = 'aps233' 
      LET g_feld_1[12].field_2 = 'aps238'

      LET g_feld_1[13].prog = 'aapi202'
      LET g_feld_1[13].table= 'aps_file'
      LET g_feld_1[13].field_1 = 'aps233' 
      LET g_feld_1[13].field_2 = 'aps238'

      LET g_feld_1[14].prog = 'aapi702'
      LET g_feld_1[14].table= 'aps_file'
      LET g_feld_1[14].field_1 = 'aps234' 
      LET g_feld_1[14].field_2 = 'aps239'

      LET g_feld_1[15].prog = 'aapi202'
      LET g_feld_1[15].table= 'aps_file'
      LET g_feld_1[15].field_1 = 'aps234' 
      LET g_feld_1[15].field_2 = 'aps239'

      LET g_feld_1[16].prog = 'aapi202'
      LET g_feld_1[16].table= 'aps_file'
      LET g_feld_1[16].field_1 = 'aps24' 
      LET g_feld_1[16].field_2 = 'aps241'

      LET g_feld_1[17].prog = 'aapi702'
      LET g_feld_1[17].table= 'aps_file'
      LET g_feld_1[17].field_1 = 'aps25' 
      LET g_feld_1[17].field_2 = 'aps251'

      LET g_feld_1[18].prog = 'aapi202'
      LET g_feld_1[18].table= 'aps_file'
      LET g_feld_1[18].field_1 = 'aps25' 
      LET g_feld_1[18].field_2 = 'aps251'

      LET g_feld_1[19].prog = 'aapi202'
      LET g_feld_1[19].table= 'aps_file'
      LET g_feld_1[19].field_1 = 'aps40' 
      LET g_feld_1[19].field_2 = 'aps401'

      LET g_feld_1[20].prog = 'aapi202'
      LET g_feld_1[20].table= 'aps_file'
      LET g_feld_1[20].field_1 = 'aps41' 
      LET g_feld_1[20].field_2 = 'aps411'

      LET g_feld_1[21].prog = 'aapi702'
      LET g_feld_1[21].table= 'aps_file'
      LET g_feld_1[21].field_1 = 'aps42' 
      LET g_feld_1[21].field_2 = 'aps421'

      LET g_feld_1[22].prog = 'aapi202'
      LET g_feld_1[22].table= 'aps_file'
      LET g_feld_1[22].field_1 = 'aps42' 
      LET g_feld_1[22].field_2 = 'aps421'

      LET g_feld_1[23].prog = 'aapi702'
      LET g_feld_1[23].table= 'aps_file'
      LET g_feld_1[23].field_1 = 'aps43' 
      LET g_feld_1[23].field_2 = 'aps431'

      LET g_feld_1[24].prog = 'aapi202'
      LET g_feld_1[24].table= 'aps_file'
      LET g_feld_1[24].field_1 = 'aps43' 
      LET g_feld_1[24].field_2 = 'aps431'

      LET g_feld_1[25].prog = 'aapi202'
      LET g_feld_1[25].table= 'aps_file'
      LET g_feld_1[25].field_1 = 'aps44' 
      LET g_feld_1[25].field_2 = 'aps441'

      LET g_feld_1[26].prog = 'aapi702'
      LET g_feld_1[26].table= 'aps_file'
      LET g_feld_1[26].field_1 = 'aps45' 
      LET g_feld_1[26].field_2 = 'aps451'

      LET g_feld_1[27].prog = 'aapi202'
      LET g_feld_1[27].table= 'aps_file'
      LET g_feld_1[27].field_1 = 'aps45' 
      LET g_feld_1[27].field_2 = 'aps451'

      LET g_feld_1[28].prog = 'aapi202'
      LET g_feld_1[28].table= 'aps_file'
      LET g_feld_1[28].field_1 = 'aps46' 
      LET g_feld_1[28].field_2 = 'aps461'

      LET g_feld_1[29].prog = 'aapi202'
      LET g_feld_1[29].table= 'aps_file'
      LET g_feld_1[29].field_1 = 'aps47' 
      LET g_feld_1[29].field_2 = 'aps471'

      LET g_feld_1[30].prog = 'aapi702'
      LET g_feld_1[30].table= 'aps_file'
      LET g_feld_1[30].field_1 = 'aps51' 
      LET g_feld_1[30].field_2 = 'aps511'

      LET g_feld_1[31].prog = 'aapi702'
      LET g_feld_1[31].table= 'aps_file'
      LET g_feld_1[31].field_1 = 'aps52' 
      LET g_feld_1[31].field_2 = 'aps521'

      LET g_feld_1[32].prog = 'aapi702'
      LET g_feld_1[32].table= 'aps_file'
      LET g_feld_1[32].field_1 = 'aps53' 
      LET g_feld_1[32].field_2 = 'aps531'

      LET g_feld_1[33].prog = 'aapi702'
      LET g_feld_1[33].table= 'aps_file'
      LET g_feld_1[33].field_1 = 'aps54' 
      LET g_feld_1[33].field_2 = 'aps541'

      LET g_feld_1[34].prog = 'aapi702'
      LET g_feld_1[34].table= 'aps_file'
      LET g_feld_1[34].field_1 = 'aps55' 
      LET g_feld_1[34].field_2 = 'aps551'

      LET g_feld_1[35].prog = 'aapi202'
      LET g_feld_1[35].table= 'aps_file'
      LET g_feld_1[35].field_1 = 'aps56' 
      LET g_feld_1[35].field_2 = 'aps561'

      LET g_feld_1[36].prog = 'aapi202'
      LET g_feld_1[36].table= 'aps_file'
      LET g_feld_1[36].field_1 = 'aps57' 
      LET g_feld_1[36].field_2 = 'aps571'

      LET g_feld_1[37].prog = 'aapi202'
      LET g_feld_1[37].table= 'aps_file'
      LET g_feld_1[37].field_1 = 'aps58' 
      LET g_feld_1[37].field_2 = 'aps581'

      LET g_feld_1[38].prog = 'aapi203'
      LET g_feld_1[38].table= 'apt_file'
      LET g_feld_1[38].field_1 = 'apt03' 
      LET g_feld_1[38].field_2 = 'apt031'

      LET g_feld_1[39].prog = 'aapi203'
      LET g_feld_1[39].table= 'apt_file'
      LET g_feld_1[39].field_1 = 'apt04' 
      LET g_feld_1[39].field_2 = 'apt041'

      LET g_feld_1[40].prog = 'aapi204'
      LET g_feld_1[40].table= 'apw_file'
      LET g_feld_1[40].field_1 = 'apw03' 
      LET g_feld_1[40].field_2 = 'apw031'

      LET g_feld_1[41].prog = 'aooi312'
      LET g_feld_1[41].table= 'azf_file'
      LET g_feld_1[41].field_1 = 'azf05' 
      LET g_feld_1[41].field_2 = 'azf051'

      LET g_feld_1[42].prog = 'aooi300'
      LET g_feld_1[42].table= 'azf_file'
      LET g_feld_1[42].field_1 = 'azf05' 
      LET g_feld_1[42].field_2 = 'azf051'

      LET g_feld_1[43].prog = 'apyi040'
      LET g_feld_1[43].table= 'cph_file'
      LET g_feld_1[43].field_1 = 'cph19' 
      LET g_feld_1[43].field_2 = 'cph191'

      LET g_feld_1[44].prog = 'apyi108'
      LET g_feld_1[44].table= 'cqq_file'
      LET g_feld_1[44].field_1 = 'cqq03' 
      LET g_feld_1[44].field_2 = 'cqq031'

      LET g_feld_1[45].prog = 'axci010'
      LET g_feld_1[45].table= 'cxg_file'
      LET g_feld_1[45].field_1 = 'cxg05' 
      LET g_feld_1[45].field_2 = 'cxg051'

      LET g_feld_1[46].prog = 'axci010'
      LET g_feld_1[46].table= 'cxg_file'
      LET g_feld_1[46].field_1 = 'cxg05c' 
      LET g_feld_1[46].field_2 = 'cxg051c'

      LET g_feld_1[47].prog = 'axci101'
      LET g_feld_1[47].table= 'cxi_file'
      LET g_feld_1[47].field_1 = 'cxi04' 
      LET g_feld_1[47].field_2 = 'cxi041'

      LET g_feld_1[48].prog = 'apyi102'
      LET g_feld_1[48].table= 'czy_file'
      LET g_feld_1[48].field_1 = 'czy07' 
      LET g_feld_1[48].field_2 = 'czy071'

      LET g_feld_1[49].prog = 'afai010'
      LET g_feld_1[49].table= 'fab_file'
      LET g_feld_1[49].field_1 = 'fab11' 
      LET g_feld_1[49].field_2 = 'fab111'

      LET g_feld_1[50].prog = 'afai010'
      LET g_feld_1[50].table= 'fab_file'
      LET g_feld_1[50].field_1 = 'fab12' 
      LET g_feld_1[50].field_2 = 'fab121'

      LET g_feld_1[51].prog = 'afai010'
      LET g_feld_1[51].table= 'fab_file'
      LET g_feld_1[51].field_1 = 'fab13' 
      LET g_feld_1[51].field_2 = 'fab131'

      LET g_feld_1[52].prog = 'afai010'
      LET g_feld_1[52].table= 'fab_file'
      LET g_feld_1[52].field_1 = 'fab24' 
      LET g_feld_1[52].field_2 = 'fab241'

      LET g_feld_1[53].prog = 'afai030'
      LET g_feld_1[53].table= 'fad_file'
      LET g_feld_1[53].field_1 = 'fad03' 
      LET g_feld_1[53].field_2 = 'fad031'

      LET g_feld_1[54].prog = 'afai030'
      LET g_feld_1[54].table= 'fad_file'
      LET g_feld_1[54].field_1 = 'fad07' 
      LET g_feld_1[54].field_2 = 'fad071'

      LET g_feld_1[55].prog = 'afai100'
      LET g_feld_1[55].table= 'faj_file'
      LET g_feld_1[55].field_1 = 'faj53' 
      LET g_feld_1[55].field_2 = 'faj531'

      LET g_feld_1[56].prog = 'afai100'
      LET g_feld_1[56].table= 'faj_file'
      LET g_feld_1[56].field_1 = 'faj54' 
      LET g_feld_1[56].field_2 = 'faj541'

      LET g_feld_1[57].prog = 'afai100'
      LET g_feld_1[57].table= 'faj_file'
      LET g_feld_1[57].field_1 = 'faj55' 
      LET g_feld_1[57].field_2 = 'faj551'

      LET g_feld_1[58].prog = 'afai101'
      LET g_feld_1[58].table= 'faj_file'
      LET g_feld_1[58].field_1 = 'fak53' 
      LET g_feld_1[58].field_2 = 'fak531'

      LET g_feld_1[59].prog = 'afai101'
      LET g_feld_1[59].table= 'faj_file'
      LET g_feld_1[59].field_1 = 'fak54' 
      LET g_feld_1[59].field_2 = 'fak541'

      LET g_feld_1[60].prog = 'afai101'
      LET g_feld_1[60].table= 'faj_file'
      LET g_feld_1[60].field_1 = 'fak55' 
      LET g_feld_1[60].field_2 = 'fak551'

      LET g_feld_1[61].prog = 'afai900'
      LET g_feld_1[61].table= 'fan_file'
      LET g_feld_1[61].field_1 = 'fan11' 
      LET g_feld_1[61].field_2 = 'fan111'

      LET g_feld_1[62].prog = 'afai900'
      LET g_feld_1[62].table= 'fan_file'
      LET g_feld_1[62].field_1 = 'fan12' 
      LET g_feld_1[62].field_2 = 'fan121'

      LET g_feld_1[63].prog = 'afai901'
      LET g_feld_1[63].table= 'fao_file'
      LET g_feld_1[63].field_1 = 'fao11' 
      LET g_feld_1[63].field_2 = 'fao111'

      LET g_feld_1[64].prog = 'afai901'
      LET g_feld_1[64].table= 'fao_file'
      LET g_feld_1[64].field_1 = 'fao12' 
      LET g_feld_1[64].field_2 = 'fao121'

      LET g_feld_1[65].prog = 'afai080'
      LET g_feld_1[65].table= 'fbi_file'
      LET g_feld_1[65].field_1 = 'fbi02' 
      LET g_feld_1[65].field_2 = 'fbi021'

      LET g_feld_1[66].prog = 'afai090'
      LET g_feld_1[66].table= 'fbz_file'
      LET g_feld_1[66].field_1 = 'fbz05' 
      LET g_feld_1[66].field_2 = 'fbz051'

      LET g_feld_1[67].prog = 'afai090'
      LET g_feld_1[67].table= 'fbz_file'
      LET g_feld_1[67].field_1 = 'fbz06' 
      LET g_feld_1[67].field_2 = 'fbz061'

      LET g_feld_1[68].prog = 'afai090'
      LET g_feld_1[68].table= 'fbz_file'
      LET g_feld_1[68].field_1 = 'fbz07' 
      LET g_feld_1[68].field_2 = 'fbz071'

      LET g_feld_1[69].prog = 'afai090'
      LET g_feld_1[69].table= 'fbz_file'
      LET g_feld_1[69].field_1 = 'fbz08' 
      LET g_feld_1[69].field_2 = 'fbz081'

      LET g_feld_1[70].prog = 'afai090'
      LET g_feld_1[70].table= 'fbz_file'
      LET g_feld_1[70].field_1 = 'fbz09' 
      LET g_feld_1[70].field_2 = 'fbz091'

      LET g_feld_1[71].prog = 'afai090'
      LET g_feld_1[71].table= 'fbz_file'
      LET g_feld_1[71].field_1 = 'fbz10' 
      LET g_feld_1[71].field_2 = 'fbz101'

      LET g_feld_1[72].prog = 'afai090'
      LET g_feld_1[72].table= 'fbz_file'
      LET g_feld_1[72].field_1 = 'fbz11' 
      LET g_feld_1[72].field_2 = 'fbz111'

      LET g_feld_1[73].prog = 'afai090'
      LET g_feld_1[73].table= 'fbz_file'
      LET g_feld_1[73].field_1 = 'fbz12' 
      LET g_feld_1[73].field_2 = 'fbz121'

      LET g_feld_1[74].prog = 'afai090'
      LET g_feld_1[74].table= 'fbz_file'
      LET g_feld_1[74].field_1 = 'fbz13' 
      LET g_feld_1[74].field_2 = 'fbz131'

      LET g_feld_1[75].prog = 'afai090'
      LET g_feld_1[75].table= 'fbz_file'
      LET g_feld_1[75].field_1 = 'fbz14' 
      LET g_feld_1[75].field_2 = 'fbz141'

      LET g_feld_1[76].prog = 'afai090'
      LET g_feld_1[76].table= 'fbz_file'
      LET g_feld_1[76].field_1 = 'fbz15' 
      LET g_feld_1[76].field_2 = 'fbz151'

      LET g_feld_1[77].prog = 'afai090'
      LET g_feld_1[77].table= 'fbz_file'
      LET g_feld_1[77].field_1 = 'fbz16' 
      LET g_feld_1[77].field_2 = 'fbz161'

      LET g_feld_1[78].prog = 'afai090'
      LET g_feld_1[78].table= 'fbz_file'
      LET g_feld_1[78].field_1 = 'fbz17' 
      LET g_feld_1[78].field_2 = 'fbz171'

      LET g_feld_1[79].prog = 'afai090'
      LET g_feld_1[79].table= 'fbz_file'
      LET g_feld_1[79].field_1 = 'fbz18' 
      LET g_feld_1[79].field_2 = 'fbz181'

      LET g_feld_1[80].prog = 'afai550'
      LET g_feld_1[80].table= 'fcx_file'
      LET g_feld_1[80].field_1 = 'fcx09' 
      LET g_feld_1[80].field_2 = 'fcx091'

      LET g_feld_1[81].prog = 'afai550'
      LET g_feld_1[81].table= 'fcx_file'
      LET g_feld_1[81].field_1 = 'fcx10' 
      LET g_feld_1[81].field_2 = 'fcx101'

      LET g_feld_1[82].prog = 'afai500'
      LET g_feld_1[82].table= 'fdd_file'
      LET g_feld_1[82].field_1 = 'fdd08' 
      LET g_feld_1[82].field_2 = 'fdd081'

      LET g_feld_1[83].prog = 'afai500'
      LET g_feld_1[83].table= 'fdd_file'
      LET g_feld_1[83].field_1 = 'fdd09' 
      LET g_feld_1[83].field_2 = 'fdd091'

      LET g_feld_1[84].prog = 'aooi150'
      LET g_feld_1[84].table= 'gec_file'
      LET g_feld_1[84].field_1 = 'gec03' 
      LET g_feld_1[84].field_2 = 'gec031'

      LET g_feld_1[85].prog = 'anmi600'
      LET g_feld_1[85].table= 'gsa_file'
      LET g_feld_1[85].field_1 = 'gsa04' 
      LET g_feld_1[85].field_2 = 'gsa041'

      LET g_feld_1[86].prog = 'anmi600'
      LET g_feld_1[86].table= 'gsa_file'
      LET g_feld_1[86].field_1 = 'gsa05' 
      LET g_feld_1[86].field_2 = 'gsa051'

      LET g_feld_1[87].prog = 'anmi600'
      LET g_feld_1[87].table= 'gsa_file'
      LET g_feld_1[87].field_1 = 'gsa06' 
      LET g_feld_1[87].field_2 = 'gsa061'

      LET g_feld_1[88].prog = 'anmi601'
      LET g_feld_1[88].table= 'gsf_file'
      LET g_feld_1[88].field_1 = 'gsf04' 
      LET g_feld_1[88].field_2 = 'gsf041'

      LET g_feld_1[89].prog = 'axmi121'
      LET g_feld_1[89].table= 'ima_file'
      LET g_feld_1[89].field_1 = 'ima132' 
      LET g_feld_1[89].field_2 = 'ima1321'

      LET g_feld_1[90].prog = 'aimi100'
      LET g_feld_1[90].table= 'ima_file'
      LET g_feld_1[90].field_1 = 'ima39' 
      LET g_feld_1[90].field_2 = 'ima391'

      LET g_feld_1[91].prog = 'aimi152'
      LET g_feld_1[91].table= 'imaa_file'
      LET g_feld_1[91].field_1 = 'imaa132' 
      LET g_feld_1[91].field_2 = 'imaa1321'

      LET g_feld_1[92].prog = 'aimi150'
      LET g_feld_1[92].table= 'imaa_file'
      LET g_feld_1[92].field_1 = 'imaa39' 
      LET g_feld_1[92].field_2 = 'imaa391'

      LET g_feld_1[93].prog = 'aimi201'
      LET g_feld_1[93].table= 'imd_file'
      LET g_feld_1[93].field_1 = 'imd08' 
      LET g_feld_1[93].field_2 = 'imd081'

      LET g_feld_1[94].prog = 'aimi201'
      LET g_feld_1[94].table= 'ime_file'
      LET g_feld_1[94].field_1 = 'ime09' 
      LET g_feld_1[94].field_2 = 'ime091'

      LET g_feld_1[95].prog = 'aimi111'
      LET g_feld_1[95].table= 'imz_file'
      LET g_feld_1[95].field_1 = 'imz132' 
      LET g_feld_1[95].field_2 = 'imz1321'

      LET g_feld_1[96].prog = 'aimi110'
      LET g_feld_1[96].table= 'imz_file'
      LET g_feld_1[96].field_1 = 'imz39' 
      LET g_feld_1[96].field_2 = 'imz391'

      LET g_feld_1[97].prog = 'anmi030'
      LET g_feld_1[97].table= 'nma_file'
      LET g_feld_1[97].field_1 = 'nma05' 
      LET g_feld_1[97].field_2 = 'nma051'

      LET g_feld_1[98].prog = 'anmi032'
      LET g_feld_1[98].table= 'nmc_file'
      LET g_feld_1[98].field_1 = 'nmc04' 
      LET g_feld_1[98].field_2 = 'nmc041'

      LET g_feld_1[99].prog = 'anmi702'
      LET g_feld_1[99].table= 'nmq_file'
      LET g_feld_1[99].field_1 = 'nmq01' 
      LET g_feld_1[99].field_2 = 'nmq011'

      LET g_feld_1[100].prog = 'anmi702'
      LET g_feld_1[100].table= 'nmq_file'
      LET g_feld_1[100].field_1 = 'nmq02' 
      LET g_feld_1[100].field_2 = 'nmq021'

      LET g_feld_1[101].prog = 'anmi702'
      LET g_feld_1[101].table= 'nmq_file'
      LET g_feld_1[101].field_1 = 'nmq10' 
      LET g_feld_1[101].field_2 = 'nmq101'

      LET g_feld_1[102].prog = 'anmi702'
      LET g_feld_1[102].table= 'nmq_file'
      LET g_feld_1[102].field_1 = 'nmq11' 
      LET g_feld_1[102].field_2 = 'nmq111'

      LET g_feld_1[103].prog = 'anmi930'
      LET g_feld_1[103].table= 'nmq_file'
      LET g_feld_1[103].field_1 = 'nmq21' 
      LET g_feld_1[103].field_2 = 'nmq211'

      LET g_feld_1[104].prog = 'anmi930'
      LET g_feld_1[104].table= 'nmq_file'
      LET g_feld_1[104].field_1 = 'nmq22' 
      LET g_feld_1[104].field_2 = 'nmq221'

      LET g_feld_1[105].prog = 'anmi930'
      LET g_feld_1[105].table= 'nmq_file'
      LET g_feld_1[105].field_1 = 'nmq23' 
      LET g_feld_1[105].field_2 = 'nmq231'

      LET g_feld_1[106].prog = 'anmi930'
      LET g_feld_1[106].table= 'nmq_file'
      LET g_feld_1[106].field_1 = 'nmq24' 
      LET g_feld_1[106].field_2 = 'nmq241'

      LET g_feld_1[107].prog = 'anmi040'
      LET g_feld_1[107].table= 'nms_file'
      LET g_feld_1[107].field_1 = 'nms12' 
      LET g_feld_1[107].field_2 = 'nms121'

      LET g_feld_1[108].prog = 'anmi040'
      LET g_feld_1[108].table= 'nms_file'
      LET g_feld_1[108].field_1 = 'nms13' 
      LET g_feld_1[108].field_2 = 'nms131'

      LET g_feld_1[109].prog = 'anmi040'
      LET g_feld_1[109].table= 'nms_file'
      LET g_feld_1[109].field_1 = 'nms14' 
      LET g_feld_1[109].field_2 = 'nms141'

      LET g_feld_1[110].prog = 'anmi040'
      LET g_feld_1[110].table= 'nms_file'
      LET g_feld_1[110].field_1 = 'nms15' 
      LET g_feld_1[110].field_2 = 'nms151'

      LET g_feld_1[111].prog = 'anmi040'
      LET g_feld_1[111].table= 'nms_file'
      LET g_feld_1[111].field_1 = 'nms16' 
      LET g_feld_1[111].field_2 = 'nms161'

      LET g_feld_1[112].prog = 'anmi040'
      LET g_feld_1[112].table= 'nms_file'
      LET g_feld_1[112].field_1 = 'nms17' 
      LET g_feld_1[112].field_2 = 'nms171'

      LET g_feld_1[113].prog = 'anmi040'
      LET g_feld_1[113].table= 'nms_file'
      LET g_feld_1[113].field_1 = 'nms18' 
      LET g_feld_1[113].field_2 = 'nms181'

      LET g_feld_1[114].prog = 'anmi040'
      LET g_feld_1[114].table= 'nms_file'
      LET g_feld_1[114].field_1 = 'nms21' 
      LET g_feld_1[114].field_2 = 'nms211'

      LET g_feld_1[115].prog = 'anmi040'
      LET g_feld_1[115].table= 'nms_file'
      LET g_feld_1[115].field_1 = 'nms22' 
      LET g_feld_1[115].field_2 = 'nms221'

      LET g_feld_1[116].prog = 'anmi040'
      LET g_feld_1[116].table= 'nms_file'
      LET g_feld_1[116].field_1 = 'nms23' 
      LET g_feld_1[116].field_2 = 'nms231'

      LET g_feld_1[117].prog = 'anmi040'
      LET g_feld_1[117].table= 'nms_file'
      LET g_feld_1[117].field_1 = 'nms24' 
      LET g_feld_1[117].field_2 = 'nms241'

      LET g_feld_1[118].prog = 'anmi040'
      LET g_feld_1[118].table= 'nms_file'
      LET g_feld_1[118].field_1 = 'nms25' 
      LET g_feld_1[118].field_2 = 'nms251'

      LET g_feld_1[119].prog = 'anmi040'
      LET g_feld_1[119].table= 'nms_file'
      LET g_feld_1[119].field_1 = 'nms26' 
      LET g_feld_1[119].field_2 = 'nms261'

      LET g_feld_1[120].prog = 'anmi040'
      LET g_feld_1[120].table= 'nms_file'
      LET g_feld_1[120].field_1 = 'nms27' 
      LET g_feld_1[120].field_2 = 'nms271'

      LET g_feld_1[121].prog = 'anmi040'
      LET g_feld_1[121].table= 'nms_file'
      LET g_feld_1[121].field_1 = 'nms28' 
      LET g_feld_1[121].field_2 = 'nms281'

      LET g_feld_1[122].prog = 'anmi040'
      LET g_feld_1[122].table= 'nms_file'
      LET g_feld_1[122].field_1 = 'nms50' 
      LET g_feld_1[122].field_2 = 'nms501'

      LET g_feld_1[123].prog = 'anmi040'
      LET g_feld_1[123].table= 'nms_file'
      LET g_feld_1[123].field_1 = 'nms51' 
      LET g_feld_1[123].field_2 = 'nms511'

      LET g_feld_1[124].prog = 'anmi040'
      LET g_feld_1[124].table= 'nms_file'
      LET g_feld_1[124].field_1 = 'nms55' 
      LET g_feld_1[124].field_2 = 'nms551'

      LET g_feld_1[125].prog = 'anmi040'
      LET g_feld_1[125].table= 'nms_file'
      LET g_feld_1[125].field_1 = 'nms56' 
      LET g_feld_1[125].field_2 = 'nms561'

      LET g_feld_1[126].prog = 'anmi040'
      LET g_feld_1[126].table= 'nms_file'
      LET g_feld_1[126].field_1 = 'nms57' 
      LET g_feld_1[126].field_2 = 'nms571'

      LET g_feld_1[127].prog = 'anmi040'
      LET g_feld_1[127].table= 'nms_file'
      LET g_feld_1[127].field_1 = 'nms58' 
      LET g_feld_1[127].field_2 = 'nms581'

      LET g_feld_1[128].prog = 'anmi040'
      LET g_feld_1[128].table= 'nms_file'
      LET g_feld_1[128].field_1 = 'nms59' 
      LET g_feld_1[128].field_2 = 'nms591'

      LET g_feld_1[129].prog = 'anmi040'
      LET g_feld_1[129].table= 'nms_file'
      LET g_feld_1[129].field_1 = 'nms60' 
      LET g_feld_1[129].field_2 = 'nms601'

      LET g_feld_1[130].prog = 'anmi040'
      LET g_feld_1[130].table= 'nms_file'
      LET g_feld_1[130].field_1 = 'nms61' 
      LET g_feld_1[130].field_2 = 'nms611'

      LET g_feld_1[131].prog = 'anmi040'
      LET g_feld_1[131].table= 'nms_file'
      LET g_feld_1[131].field_1 = 'nms62' 
      LET g_feld_1[131].field_2 = 'nms621'

      LET g_feld_1[132].prog = 'anmi040'
      LET g_feld_1[132].table= 'nms_file'
      LET g_feld_1[132].field_1 = 'nms63' 
      LET g_feld_1[132].field_2 = 'nms631'

      LET g_feld_1[133].prog = 'anmi040'
      LET g_feld_1[133].table= 'nms_file'
      LET g_feld_1[133].field_1 = 'nms64' 
      LET g_feld_1[133].field_2 = 'nms641'

      LET g_feld_1[134].prog = 'anmi040'
      LET g_feld_1[134].table= 'nms_file'
      LET g_feld_1[134].field_1 = 'nms65' 
      LET g_feld_1[134].field_2 = 'nms651'

      LET g_feld_1[135].prog = 'anmi040'
      LET g_feld_1[135].table= 'nms_file'
      LET g_feld_1[135].field_1 = 'nms66' 
      LET g_feld_1[135].field_2 = 'nms661'

      LET g_feld_1[136].prog = 'anmi040'
      LET g_feld_1[136].table= 'nms_file'
      LET g_feld_1[136].field_1 = 'nms67' 
      LET g_feld_1[136].field_2 = 'nms671'

      LET g_feld_1[137].prog = 'anmi040'
      LET g_feld_1[137].table= 'nms_file'
      LET g_feld_1[137].field_1 = 'nms68' 
      LET g_feld_1[137].field_2 = 'nms681'

      LET g_feld_1[138].prog = 'anmi040'
      LET g_feld_1[138].table= 'nms_file'
      LET g_feld_1[138].field_1 = 'nms69' 
      LET g_feld_1[138].field_2 = 'nms691'

      LET g_feld_1[139].prog = 'anmi040'
      LET g_feld_1[139].table= 'nms_file'
      LET g_feld_1[139].field_1 = 'nms70' 
      LET g_feld_1[139].field_2 = 'nms701'

      LET g_feld_1[140].prog = 'anmi040'
      LET g_feld_1[140].table= 'nms_file'
      LET g_feld_1[140].field_1 = 'nms71' 
      LET g_feld_1[140].field_2 = 'nms711'

      LET g_feld_1[141].prog = 'anmi700'
      LET g_feld_1[141].table= 'nnn_file'
      LET g_feld_1[141].field_1 = 'nnn04' 
      LET g_feld_1[141].field_2 = 'nnn041'

      LET g_feld_1[142].prog = 'axmi110'
      LET g_feld_1[142].table= 'oba_file'
      LET g_feld_1[142].field_1 = 'oba11' 
      LET g_feld_1[142].field_2 = 'oba111'

      LET g_feld_1[143].prog = 'axmi210'
      LET g_feld_1[143].table= 'oca_file'
      LET g_feld_1[143].field_1 = 'oca03' 
      LET g_feld_1[143].field_2 = 'oca04'

      LET g_feld_1[144].prog = 'axri040'
      LET g_feld_1[144].table= 'oca_file'
      LET g_feld_1[144].field_1 = 'oca03' 
      LET g_feld_1[144].field_2 = 'oca04'

      LET g_feld_1[145].prog = 'axri090'
      LET g_feld_1[145].table= 'ool_file'
      LET g_feld_1[145].field_1 = 'ool11' 
      LET g_feld_1[145].field_2 = 'ool111'

      LET g_feld_1[146].prog = 'axri090'
      LET g_feld_1[146].table= 'ool_file'
      LET g_feld_1[146].field_1 = 'ool12' 
      LET g_feld_1[146].field_2 = 'ool121'

      LET g_feld_1[147].prog = 'axri090'
      LET g_feld_1[147].table= 'ool_file'
      LET g_feld_1[147].field_1 = 'ool13' 
      LET g_feld_1[147].field_2 = 'ool131'

      LET g_feld_1[148].prog = 'axri090'
      LET g_feld_1[148].table= 'ool_file'
      LET g_feld_1[148].field_1 = 'ool14' 
      LET g_feld_1[148].field_2 = 'ool141'

      LET g_feld_1[149].prog = 'axri090'
      LET g_feld_1[149].table= 'ool_file'
      LET g_feld_1[149].field_1 = 'ool15' 
      LET g_feld_1[149].field_2 = 'ool151'

      LET g_feld_1[150].prog = 'axri090'
      LET g_feld_1[150].table= 'ool_file'
      LET g_feld_1[150].field_1 = 'ool21' 
      LET g_feld_1[150].field_2 = 'ool211'

      LET g_feld_1[151].prog = 'axri090'
      LET g_feld_1[151].table= 'ool_file'
      LET g_feld_1[151].field_1 = 'ool22' 
      LET g_feld_1[151].field_2 = 'ool221'

      LET g_feld_1[152].prog = 'axri090'
      LET g_feld_1[152].table= 'ool_file'
      LET g_feld_1[152].field_1 = 'ool24' 
      LET g_feld_1[152].field_2 = 'ool241'

      LET g_feld_1[153].prog = 'axri090'
      LET g_feld_1[153].table= 'ool_file'
      LET g_feld_1[153].field_1 = 'ool25' 
      LET g_feld_1[153].field_2 = 'ool251'

      LET g_feld_1[154].prog = 'axri090'
      LET g_feld_1[154].table= 'ool_file'
      LET g_feld_1[154].field_1 = 'ool26' 
      LET g_feld_1[154].field_2 = 'ool261'

      LET g_feld_1[155].prog = 'axri090'
      LET g_feld_1[155].table= 'ool_file'
      LET g_feld_1[155].field_1 = 'ool27' 
      LET g_feld_1[155].field_2 = 'ool271'

      LET g_feld_1[156].prog = 'axri090'
      LET g_feld_1[156].table= 'ool_file'
      LET g_feld_1[156].field_1 = 'ool8' 
      LET g_feld_1[156].field_2 = 'ool281'

      LET g_feld_1[157].prog = 'axri090'
      LET g_feld_1[157].table= 'ool_file'
      LET g_feld_1[157].field_1 = 'ool41' 
      LET g_feld_1[157].field_2 = 'ool411'

      LET g_feld_1[158].prog = 'axri090'
      LET g_feld_1[158].table= 'ool_file'
      LET g_feld_1[158].field_1 = 'ool42' 
      LET g_feld_1[158].field_2 = 'ool421'

      LET g_feld_1[159].prog = 'axri090'
      LET g_feld_1[159].table= 'ool_file'
      LET g_feld_1[159].field_1 = 'ool43' 
      LET g_feld_1[159].field_2 = 'ool431'

      LET g_feld_1[160].prog = 'axri090'
      LET g_feld_1[160].table= 'ool_file'
      LET g_feld_1[160].field_1 = 'ool44' 
      LET g_feld_1[160].field_2 = 'ool441'

      LET g_feld_1[161].prog = 'axri090'
      LET g_feld_1[161].table= 'ool_file'
      LET g_feld_1[161].field_1 = 'ool45' 
      LET g_feld_1[161].field_2 = 'ool451'

      LET g_feld_1[162].prog = 'axri090'
      LET g_feld_1[162].table= 'ool_file'
      LET g_feld_1[162].field_1 = 'ool46' 
      LET g_feld_1[162].field_2 = 'ool461'

      LET g_feld_1[163].prog = 'axri090'
      LET g_feld_1[163].table= 'ool_file'
      LET g_feld_1[163].field_1 = 'ool47' 
      LET g_feld_1[163].field_2 = 'ool471'

      LET g_feld_1[164].prog = 'axri090'
      LET g_feld_1[164].table= 'ool_file'
      LET g_feld_1[164].field_1 = 'ool51' 
      LET g_feld_1[164].field_2 = 'ool511'

      LET g_feld_1[165].prog = 'axri090'
      LET g_feld_1[165].table= 'ool_file'
      LET g_feld_1[165].field_1 = 'ool52' 
      LET g_feld_1[165].field_2 = 'ool521'

      LET g_feld_1[166].prog = 'axri090'
      LET g_feld_1[166].table= 'ool_file'
      LET g_feld_1[166].field_1 = 'ool53' 
      LET g_feld_1[166].field_2 = 'ool531'

      LET g_feld_1[167].prog = 'axri090'
      LET g_feld_1[167].table= 'ool_file'
      LET g_feld_1[167].field_1 = 'ool54' 
      LET g_feld_1[167].field_2 = 'ool541'

      LET g_feld_1[168].prog = 'aict040'
      LET g_feld_1[168].table= 'pmn_file'
      LET g_feld_1[168].field_1 = 'pmn40' 
      LET g_feld_1[168].field_2 = 'pmn401'
END FUNCTION
FUNCTION g009_tran1(p_prog,p_table,p_field)
DEFINE p_prog               LIKE zz_file.zz01
DEFINE p_table              LIKE gaz_file.gaz03
DEFINE p_field              LIKE gaq_file.gaq01
DEFINE l_field_n,l_field_o  LIKE aab_file.aab01
DEFINE l_cnt                LIKE type_file.num5
DEFINE l_gaz03              LIKE gaz_file.gaz03
DEFINE l_gae04              LIKE gae_file.gae04
DEFINE l_aag02_n,l_aag02_o  LIKE aag_file.aag02
   LET g_sql = "SELECT DISTINCT ",p_field," FROM ",p_table, 
               " WHERE ",p_field," IS NOT NULL"
   PREPARE g009_field_pre1 FROM g_sql
   DECLARE g009_field_cur1 CURSOR FOR g009_field_pre1
  #FUN-C50007--ADD--STR
   LET g_sql = "SELECT COUNT(*) FROM tag_file ",
                   " WHERE tag01 = '",g_year,"'",
                   "   AND tag02 = '",g_bookno_o,"'",
                   "   AND tag03 = ?",
                   "   AND tag04 = '",g_bookno_n,"'"
      PREPARE g009_cnt_pre1 FROM g_sql
      DECLARE g009_cnt_cur1 CURSOR FOR g009_cnt_pre1

      LET g_sql = "SELECT tag05 FROM tag_file ",    
                     " WHERE tag01 = '",g_year,"'",
                     "   AND tag02 = '",g_bookno_o,"'",
                     "   AND tag03 = ?",
                     "   AND tag04 = '",g_bookno_n,"'",
                     " ORDER BY tag05 "
         PREPARE g009_tran_pre1 FROM g_sql
         DECLARE g009_tran_cur1 CURSOR FOR g009_tran_pre1
   #FUN-C50007--ADD-END
   FOREACH g009_field_cur1 INTO l_field_o
      LET l_aag02_n = ' '
      LET l_aag02_o = ' '
      LET l_gaz03   = ' '
      LET l_gae04   = ' '
      SELECT gaz03 INTO l_gaz03 FROM gaz_file
       WHERE gaz01=p_prog 
         AND gaz02=g_lang

      SELECT gae04 INTO l_gae04 FROM gae_file
       WHERE gae01=p_prog 
         AND gae02=p_field 
         AND gae03=g_lang
     SELECT aag02 INTO l_aag02_o FROM aag_file
      WHERE aag00=g_bookno_o 
        AND aag01=l_field_o
     #FUN-C50007--MARK--STR
     #LET g_sql = "SELECT COUNT(*) FROM tag_file ",   
     #             " WHERE tag01 = '",g_year,"'",
     #             "   AND tag02 = '",g_bookno_o,"'",
     #             "   AND tag03 = '",l_field_o,"'",
     #             "   AND tag04 = '",g_bookno_n,"'"
     #PREPARE g009_cnt_pre1 FROM g_sql
     #DECLARE g009_cnt_cur1 CURSOR FOR g009_cnt_pre1
     #OPEN g009_cnt_cur1
     #FUN-C50007--MARK--END
      OPEN g009_cnt_cur1 USING l_field_o    #FUN-C50007 ADD
      FETCH g009_cnt_cur1 INTO l_cnt  
      IF l_cnt = 0  THEN
         EXECUTE insert_prep1 USING p_prog,l_gaz03,p_field,
                                    l_gae04,g_bookno_n,
                                    l_field_o,l_aag02_o,
                                    g_bookno_o,l_field_o,l_aag02_o
      ELSE
         LET l_aag02_n = ' '
       #FUN-C50007--MARK--STR
        #LET g_sql = "SELECT tag05 FROM tag_file ",   
        #            " WHERE tag01 = '",g_year,"'",
        #            "   AND tag02 = '",g_bookno_o,"'",
        #            "   AND tag03 = '",l_field_o,"'",
        #            "   AND tag04 = '",g_bookno_n,"'",
        #            " ORDER BY tag05 "
        #PREPARE g009_tran_pre1 FROM g_sql
        #DECLARE g009_tran_cur1 CURSOR FOR g009_tran_pre1
        #OPEN g009_tran_cur1
        #FUN-C50007--MARK--END
         OPEN g009_tran_cur1 USING l_field_o #FUN-C50007 ADD
         FOREACH g009_tran_cur1 INTO l_field_n
         SELECT aag02 INTO l_aag02_n FROM aag_file
          WHERE aag00=g_bookno_n 
            AND aag01=l_field_n
            EXECUTE insert_prep1 USING p_prog,l_gaz03,p_field,
                                       l_gae04,g_bookno_n,
                                       l_field_n,l_aag02_n,
                                       g_bookno_o,l_field_o,l_aag02_o
         END FOREACH
      END IF
   END FOREACH
END FUNCTION

FUNCTION g009_tran2(p_prog,p_table,p_field_1,p_field_2)
DEFINE p_prog               LIKE zz_file.zz01
DEFINE p_table              LIKE gaz_file.gaz03
DEFINE p_field_1,p_field_2  LIKE gaq_file.gaq01
DEFINE l_field_n,l_field_o  LIKE aps_file.aps11
DEFINE l_gaz03              LIKE gaz_file.gaz03
DEFINE l_gae04_1,l_gae04_2  LIKE gae_file.gae04
DEFINE l_aag02_n,l_aag02_o  LIKE aag_file.aag02
   LET l_gae04_1 = ' '
   LET l_gae04_2 = ' '
 
   SELECT gaz03 INTO l_gaz03 FROM gaz_file
    WHERE gaz01=p_prog 
      AND gaz02=g_lang

   SELECT gae04 INTO l_gae04_1 FROM gae_file
    WHERE gae01=p_prog 
      AND gae02=p_field_1 
      AND gae03=g_lang

   SELECT gae04 INTO l_gae04_2 FROM gae_file
    WHERE gae01=p_prog 
      AND gae02=p_field_2 
      AND gae03=g_lang
   LET g_sql = "SELECT DISTINCT ",p_field_1,",",p_field_2," FROM ",p_table 
   PREPARE g009_field_pre2 FROM g_sql
   DECLARE g009_field_cur2 CURSOR FOR g009_field_pre2
   FOREACH g009_field_cur2 INTO l_field_n,l_field_o
      IF cl_null(l_field_n) AND cl_null(l_field_o) THEN
         CONTINUE FOREACH
      END IF
      LET l_aag02_n = ' '
      LET l_aag02_o = ' '

      SELECT aag02 INTO l_aag02_n FROM aag_file
       WHERE aag01=l_field_n
         AND aag00=g_aza.aza81

      SELECT aag02 INTO l_aag02_o FROM aag_file
       WHERE aag01=l_field_o
         AND aag00=g_aza.aza82

      EXECUTE insert_prep1 USING p_prog,l_gaz03,
                                 l_field_n,l_aag02_n,
                                 p_field_1,l_gae04_1,
                                 l_field_o,l_aag02_o,
                                 p_field_2,l_gae04_2
   END FOREACH
END FUNCTION

FUNCTION g009_set_entry()
   CALL cl_set_comp_entry("g_year,g_bookno_o,g_bookno_n",TRUE)
END FUNCTION
   
FUNCTION g009_set_no_entry()
   CALL cl_set_comp_entry("g_year,g_bookno_o,g_bookno_n",FALSE)
END FUNCTION
#No.FUN-9A0036

###GENGRE###START
FUNCTION aglg009_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg009")
        IF handler IS NOT NULL THEN
            START REPORT aglg009_rep TO XML HANDLER handler
            IF g_template = 'aglg009' THEN
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED, 
                           " ORDER BY prog,field,new,old"
            ELSE
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                           " ORDER BY prog,bookno_n,old,field desc"
            END IF

            DECLARE aglg009_datacur1 CURSOR FROM l_sql
            FOREACH aglg009_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg009_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg009_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg009_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr1_o sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_str    STRING    #FUN-B80161
    DEFINE l_display  LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display1 LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display2 LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display3 LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display4 LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display5 LIKE type_file.chr1   #FUN-B80161
    DEFINE l_display6 LIKE type_file.chr1   #FUN-B80161
#FUN-CB0051--add--str--    
    DEFINE l_prog      LIKE zz_file.zz01
    DEFINE l_progname  LIKE gaz_file.gaz03
    DEFINE l_field     LIKE type_file.chr30
    DEFINE l_fieldname LIKE type_file.chr30
    DEFINE l_bookno_n  LIKE type_file.chr20
    DEFINE l_new       LIKE type_file.chr30
    DEFINE l_n_aag02   LIKE type_file.chr100
    DEFINE l_old       LIKE type_file.chr30
    DEFINE l_o_aag02   LIKE type_file.chr30 
#FUN-CB0051--add--end--
    
    ORDER EXTERNAL BY sr1.prog,sr1.field
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name,g_year   #FUN-B80161 add g_ptime,g_user_name,g_year
            
            #FUN-B80161---add---str-------
            IF g_a = 1 THEN LET l_str = ''
            ELSE LET l_str = g_year END IF
            PRINTX l_str
            #FUN-B80161---add---end-------
              
        BEFORE GROUP OF sr1.prog
        BEFORE GROUP OF sr1.field

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B80161---add-----str---
            IF NOT cl_null(sr1_o.prog) THEN
               IF sr1_o.prog != sr1.prog THEN
                  LET l_display = 'Y'
                  LET l_prog = sr1.prog           #FUN-CB0051
                  LET l_progname = sr1.progname   #FUN-CB0051
               ELSE
                  LET l_display = 'N'
                  LET l_prog = ' '       #FUN-CB0051
                  LET l_progname = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_prog = sr1.prog           #FUN-CB0051
               LET l_progname = sr1.progname   #FUN-CB0051
            END IF
            PRINTX l_display  
 
            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1.field) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.field AND sr1.field THEN
                  LET l_display6 = 'Y'
                  LET l_field = sr1.field           #FUN-CB0051
                  LET l_fieldname = sr1.fieldname   #FUN-CB0051
               ELSE
                  LET l_display6 = 'N'
                  LET l_field = ' '       #FUN-CB0051
                  LET l_fieldname = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display6 = 'Y'
               LET l_field = sr1.field           #FUN-CB0051
               LET l_fieldname = sr1.fieldname   #FUN-CB0051
            END IF

            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1_o.bookno_n) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.bookno_n != sr1.bookno_n THEN
                  LET l_display1 = 'Y'
                  LET l_bookno_n = sr1.bookno_n   #FUN-CB0051
               ELSE
                  LET l_display1 = 'N'
                  LET l_bookno_n = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_bookno_n = sr1.bookno_n   #FUN-CB0051
            END IF
            PRINTX l_display1   

            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1_o.new) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.new != sr1.new THEN
                  LET l_display2 = 'Y'
                  LET l_new = sr1.new   #FUN-CB0051
               ELSE
                  LET l_display2 = 'N'
                  LET l_new = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display2 = 'Y'
               LET l_new = sr1.new   #FUN-CB0051
            END IF
            PRINTX l_display2   

            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1_o.n_aag02) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.n_aag02 != sr1.n_aag02 THEN
                  LET l_display3 = 'Y'
                  LET l_n_aag02 = sr1.n_aag02   #FUN-CB0051
               ELSE
                  LET l_display3 = 'N'
                  LET l_n_aag02 = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display3 = 'Y'
               LET l_n_aag02 = sr1.n_aag02   #FUN-CB0051
            END IF
            PRINTX l_display3   

            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1_o.old) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.old != sr1.old THEN
                  LET l_display4 = 'Y'
                  LET l_old = sr1.old   #FUN-CB0051
               ELSE
                  LET l_display4 = 'N'
                  LET l_old = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display4 = 'Y'
               LET l_old = sr1.old   #FUN-CB0051
            END IF
            PRINTX l_display4   

            IF NOT cl_null(sr1_o.prog) AND NOT cl_null(sr1_o.o_aag02) THEN
               IF sr1_o.prog != sr1.prog OR sr1_o.o_aag02 != sr1.o_aag02 THEN
                  LET l_display5 = 'Y'
                  LET l_o_aag02 = sr1.o_aag02   #FUN-CB0051
               ELSE
                  LET l_display5 = 'N'
                  LET l_o_aag02 = ' '   #FUN-CB0051
               END IF
            ELSE
               LET l_display5 = 'Y'
               LET l_o_aag02 = sr1.o_aag02   #FUN-CB0051
            END IF
            PRINTX l_display5   
            PRINTX l_display6   

            LET sr1_o.* = sr1.*
            #FUN-B80161---add-----end---

            PRINTX sr1.*
#FUN-CB0051--add--str--
            PRINTX l_prog     
            PRINTX l_progname   
            PRINTX l_field      
            PRINTX l_fieldname  
            PRINTX l_bookno_n   
            PRINTX l_new        
            PRINTX l_n_aag02   
            PRINTX l_old        
            PRINTX l_o_aag02   
#FUN-CB0051--add--end--

        AFTER GROUP OF sr1.prog
        AFTER GROUP OF sr1.field

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-CC0085
