# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aoop603.4gl
# Descriptions...: 基本資料拋轉作業
# Input parameter:
# Date & Author..: 07/12/11 By Carrier FUN-7C0010
# Modify.........: No.FUN-830090 08/03/27 By Carrier 權限控管
# Modify.........: No.MOD-840246 08/04/20 By Carrier 下載問題處理
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-980147 09/08/18 By Dido aooi102 應為 smc_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60132 10/06/21 By Sarah FUNCTION p603_set_tables()好幾支程式對應的table都寫錯 
# Modify.........: No:CHI-A60030 10/06/30 By Summer 有些程式對應到同一個table(azf_file與tqa_file),在匯出資料時SQL應該要區分key值
# Modify.........: No.FUN-A80036 10/08/11 By Carrier s_basic_data_carry中的g_tables多加了一个temptb的column,故此程序也要加
# Modify.........: No.FUN-AA0006 10/10/11 By vealxu GLOBAL 基本資料拋轉中心.新增拋轉資料檔.
# Modify.........: No:CHI-A80055 10/10/15 By Summer 加上拋轉aimi110的料件分群基本資料維護作業
# Modify.........: NO.FUN-AA0083 10/10/27 By vealxu FUN-AA0006(資料中心), 程式修正.
# Modify.........: NO.FUN-B40037 11/04/13 By lilingyu 增加拋轉aimi200、aimi201
# Modify.........: NO.FUN-B60097 11/06/20 By suncx    增加拋轉aimi200、aimi201
# Modify.........: NO.FUN-B70021 11/07/26 By pauline  增加拋轉almi530
# Modify.........: NO.FUN-BC0058 11/12/22 By yangxf 更改TABLE 
# Modify.........: No:CHI-B60098 13/04/03 By Alberti 新增 geu00 為 KEY 值
# Modify.........: NO.FUN-D40046 13/04/09 By SunLM 拋轉增加aeci650/aeci600/aeci670/aeci620
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global" #FUN-7C0010
 
DEFINE tm1        RECORD
                  gev04    LIKE gev_file.gev04,
                  geu02    LIKE geu_file.geu02
                  END RECORD
DEFINE g_rec_b	  LIKE type_file.num10
DEFINE g_tables   DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  sel      LIKE type_file.chr1,
                  prog     LIKE zz_file.zz01,
                  gaz03    LIKE gaz_file.gaz03,
                  zr02     LIKE gat_file.gat01,
                  gat03    LIKE gat_file.gat03,
                  temptb   STRING                 #No.FUN-A80036
                  END RECORD
DEFINE 
       #g_sql      LIKE type_file.chr1000
       g_sql        STRING       #NO.FUN-910082
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_i        LIKE type_file.num5
DEFINE l_ac       LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE g_cnt1     LIKE type_file.num10
 
MAIN
  DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p603_w AT p_row,p_col
        WITH FORM "aoo/42f/aoop603"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   #No.FUN-A80036  --Begin                                                      
   CALL cl_set_comp_visible("temp_tb",FALSE)                                    
   #No.FUN-A80036  --End
 
   SELECT * FROM gev_file WHERE gev01 = '0' AND gev02 = g_plant
                            AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_plant,'aoo-036',1)   #Not Carry DB
      EXIT PROGRAM
   END IF
 
   CALL p603_tm()
   CALL p603_menu()
 
   CLOSE WINDOW p603_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p603_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL p603_bp("G")
      CASE g_action_choice
#        WHEN "dantou"
#           IF cl_chk_act_auth() THEN
#              CALL p603_tm()
#           END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p603_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "carry"
            IF cl_chk_act_auth() THEN
               CALL ui.Interface.refresh()
               CALL p603()
            END IF
 
         WHEN "download"
            IF cl_chk_act_auth() THEN
               CALL p603_download()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_tables),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p603_tm()
  DEFINE l_sql,l_where  STRING
  DEFINE l_module       LIKE type_file.chr4
 
    CALL cl_opmsg('p')
    INITIALIZE tm1.* TO NULL            # Default condition
    CALL p603_init_b()
 
    LET tm1.gev04=NULL
    LET tm1.geu02=NULL
 
    SELECT gev04 INTO tm1.gev04 FROM gev_file
     WHERE gev01 = '0' AND gev02 = g_plant
    SELECT geu02 INTO tm1.geu02 FROM geu_file
    #WHERE geu01 = tm1.gev04                     #CHI-B60098 mark  
     WHERE geu01 = tm1.gev04 AND geu00='1'       #CHI-B60098 add
    DISPLAY BY NAME tm1.*
 
#   INPUT BY NAME tm1.gev04 WITHOUT DEFAULTS
 
#      AFTER FIELD gev04
#         IF cl_null(tm1.gev04) THEN NEXT FIELD gev04 END IF
#         IF NOT cl_null(tm1.gev04) THEN
#            CALL p603_gev04()
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(tm1.gev04,g_errno,0)
#               NEXT FIELD gev04
#            END IF
#         ELSE
#            DISPLAY '' TO geu02
#         END IF
 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(gev04)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_gev04"
#               LET g_qryparam.arg1 = "0"
#               LET g_qryparam.arg2 = g_plant
#               CALL cl_create_qry() RETURNING tm1.gev04
#               DISPLAY BY NAME tm1.gev04
#               NEXT FIELD gev04
#            OTHERWISE EXIT CASE
#         END CASE
 
#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
 
#      ON ACTION controlg
#         CALL cl_cmdask()
 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
 
#   END INPUT
 
#   IF INT_FLAG THEN
#      LET INT_FLAG=0
#      CLOSE WINDOW p603_w
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#      EXIT PROGRAM
#   END IF
 
    CALL p603_b()
 
END FUNCTION
 
FUNCTION p603_b()
 
    SELECT * FROM gev_file
     WHERE gev01 = '0' AND gev02 = g_plant
       AND gev03 = 'Y' AND gev04 = tm1.gev04
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,'aoo-036',1)
       RETURN
    END IF
 
    INPUT ARRAY g_tables WITHOUT DEFAULTS FROM s_tables.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER INPUT
          EXIT INPUT
 
       ON ACTION select_all
          CALL p603_sel_all_1("Y")
 
       ON ACTION select_non
          CALL p603_sel_all_1("N")
 
       ON ACTION qry_carry_history
          IF l_ac > 0 THEN
             LET g_sql='aooq604 "',tm1.gev04,'" "0" "',g_tables[l_ac].prog,'" ""'
             CALL cl_cmdrun(g_sql)
          END IF
            
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
 
    LET g_action_choice=''
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p603_gev04()
    DEFINE l_geu00   LIKE geu_file.geu00
    DEFINE l_geu02   LIKE geu_file.geu02
    DEFINE l_geuacti LIKE geu_file.geuacti
 
    LET g_errno = ' '
    SELECT geu00,geu02,geuacti INTO l_geu00,l_geu02,l_geuacti
     #FROM geu_file WHERE geu01=tm1.gev04                           #CHI-B60098 mark
      FROM geu_file WHERE geu01=tm1.gev04 AND geu00='1'             #CHI-B60098 add
    CASE
        WHEN l_geuacti = 'N' LET g_errno = '9028'
        WHEN l_geu00 <> '1'  LET g_errno = 'aoo-030'
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       LET l_geu02 = NULL
    ELSE
       SELECT * FROM gev_file WHERE gev01 = '0' AND gev02 = g_plant
                                AND gev03 = 'Y' AND gev04 = tm1.gev04
       IF SQLCA.sqlcode THEN
          LET g_errno = 'aoo-036'   #Not Carry DB
       END IF
    END IF
    IF cl_null(g_errno) THEN
       LET tm1.geu02 = l_geu02
    END IF
    DISPLAY BY NAME tm1.geu02
END FUNCTION
 
FUNCTION p603_sel_all_1(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_tables.getLength()
       LET g_tables[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION p603()
  DEFINE l_i      LIKE type_file.num10  #No.FUN-830090
  DEFINE l_flag   LIKE type_file.chr1   #No.FUN-830090
 
   #No.FUN-830090  --Begin
   LET l_flag = 'N'
   FOR l_i = 1 TO g_tables.getLength()
       IF g_tables[l_i].sel = 'Y' THEN 
          LET l_flag = 'Y'
       END IF
   END FOR 
   IF l_flag = 'N' THEN
      CALL cl_err('','aoo-096',0)
      RETURN
   END IF
   #No.FUN-830090  --End  
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(tm1.gev04,'0')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL s_showmsg_init()
   CALL s_basic_data_carry(g_tables,g_azp,tm1.gev04,'1')
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION p603_set_tables()
    #程序清單 共80個程序
    LET g_tables[01].prog="aooi030"  LET g_tables[02].prog="aooi040"
    LET g_tables[03].prog="aooi050"  LET g_tables[04].prog="aooi080"
    LET g_tables[05].prog="aooi090"  LET g_tables[06].prog="aooi100"
    LET g_tables[07].prog="aooi101"  LET g_tables[08].prog="aooi102"
    LET g_tables[09].prog="aooi110"  LET g_tables[10].prog="aooi150"
    LET g_tables[11].prog="aooi160"  LET g_tables[12].prog="aooi210"
    LET g_tables[13].prog="aooi301"  LET g_tables[14].prog="aooi304"
    LET g_tables[15].prog="aooi305"  LET g_tables[16].prog="aooi306"
    LET g_tables[17].prog="aooi309"  LET g_tables[18].prog="aooi310"
    LET g_tables[19].prog="aooi311"  LET g_tables[20].prog="aooi312"
    LET g_tables[21].prog="aooi313"  LET g_tables[22].prog="aapi104"
    LET g_tables[23].prog="aapi105"  LET g_tables[24].prog="afai010"
    LET g_tables[25].prog="afai020"  LET g_tables[26].prog="afai050"
    LET g_tables[27].prog="anmi031"  LET g_tables[28].prog="anmi032"
    LET g_tables[29].prog="anmi033"  LET g_tables[30].prog="anmi060"
    LET g_tables[31].prog="anmi070"  LET g_tables[32].prog="anmi080"
    LET g_tables[33].prog="apmi100"  LET g_tables[34].prog="apmi101"
    LET g_tables[35].prog="apyi040"  LET g_tables[36].prog="apyi050"
    LET g_tables[37].prog="apyi104"  LET g_tables[38].prog="aqci100"
    LET g_tables[39].prog="aqci101"  LET g_tables[40].prog="aqci102"
    LET g_tables[41].prog="aqci103"  LET g_tables[42].prog="aqci110"
    LET g_tables[43].prog="artt301"  LET g_tables[44].prog="atmi170"     #FUN-AA0083 mod atmi150 ->artt301
    LET g_tables[45].prog="atmi400"  LET g_tables[46].prog="atmi401"
    LET g_tables[47].prog="atmi402"  LET g_tables[48].prog="atmi403"
    LET g_tables[49].prog="atmi404"  LET g_tables[50].prog="atmi405"
    LET g_tables[51].prog="atmi406"  LET g_tables[52].prog="atmi407"
    LET g_tables[53].prog="atmi408"  LET g_tables[54].prog="atmi409"
    LET g_tables[55].prog="atmi410"  LET g_tables[56].prog="atmi411"
    LET g_tables[57].prog="atmi412"  LET g_tables[58].prog="atmi413"
    LET g_tables[59].prog="atmi414"  LET g_tables[60].prog="atmi415"
    LET g_tables[61].prog="atmi416"  LET g_tables[62].prog="atmi417"
    LET g_tables[63].prog="atmi418"  LET g_tables[64].prog="atmi419"
    LET g_tables[65].prog="atmi420"  LET g_tables[66].prog="axci030"
    LET g_tables[67].prog="axmi020"  LET g_tables[68].prog="axmi030"
    LET g_tables[69].prog="axmi040"  LET g_tables[70].prog="axmi040" #axmi040有兩個table
    LET g_tables[71].prog="axmi050"  LET g_tables[72].prog="axmi070"
    LET g_tables[73].prog="axmi080"  LET g_tables[74].prog="axmi081"
    LET g_tables[75].prog="axmi110"  LET g_tables[76].prog="axmi111"
    LET g_tables[77].prog="axmi130"  LET g_tables[78].prog="axmi210"
    LET g_tables[79].prog="axmi900"  LET g_tables[80].prog="axmi910"
    LET g_tables[81].prog="axmi920"  LET g_tables[82].prog="aimi110" #CHI-A80055 add aimi110
    #CHI-A80055 mod +1 --start--
    #FUN-AA0006---------------add start----------------------------
    LET g_tables[83].prog="almi210"  LET g_tables[84].prog="almi210"
    LET g_tables[85].prog="almi240"  LET g_tables[86].prog="almi250"
    LET g_tables[87].prog="almi260"  LET g_tables[88].prog="almi270"
    LET g_tables[89].prog="almi330"  LET g_tables[90].prog="almi380"
#FUN-BC0058 MARK BEGIN---
#   LET g_tables[91].prog="almi480"  LET g_tables[92].prog="almi490"
#   LET g_tables[93].prog="almi500"  LET g_tables[94].prog="almi510"
#   LET g_tables[95].prog="almi520"  LET g_tables[96].prog="almi530"
#   LET g_tables[97].prog="almi540"  LET g_tables[98].prog="almi550"
#FUN-BC0058 MARK END ----
#FUN-BC0058 add begin ---
    LET g_tables[91].prog="almi501"  LET g_tables[92].prog="almi502"
    LET g_tables[93].prog="almi503"  LET g_tables[94].prog="almi504"
    LET g_tables[95].prog="almi505"  LET g_tables[96].prog="almi506"
    LET g_tables[97].prog="almi507"  LET g_tables[98].prog="almi508"
#FUN-BC0058 add end ----
    LET g_tables[99].prog="almi550"  LET g_tables[100].prog="almi650"
    LET g_tables[101].prog="almi660"  LET g_tables[102].prog="almi660"
    LET g_tables[103].prog="almi710"  LET g_tables[104].prog="aooi111"         #FUN-AA0083 almi111->aooi111    
    LET g_tables[105].prog="aooi112"  LET g_tables[106].prog="aooi113"
    LET g_tables[107].prog="arti101"  LET g_tables[108].prog="arti102"
    LET g_tables[109].prog="arti103"  LET g_tables[110].prog="arti104"
    LET g_tables[111].prog="arti105"  LET g_tables[112].prog="arti108"
    LET g_tables[113].prog="arti111"  LET g_tables[114].prog="arti112"
    LET g_tables[115].prog="arti112"  LET g_tables[116].prog="arti160"
    LET g_tables[117].prog="arti161"  LET g_tables[118].prog="arti162"
    LET g_tables[119].prog="atmi215"  LET g_tables[120].prog="atmi171"        #FUN-AA0083 atmi170 -> atmi215
    LET g_tables[121].prog="atmi172"  LET g_tables[122].prog="atmi172"
    LET g_tables[123].prog="atmi173"  LET g_tables[124].prog="atmi174"
    LET g_tables[125].prog="atmi175"  LET g_tables[126].prog="atmi176"
    LET g_tables[127].prog="atmi177"  LET g_tables[128].prog="atmi178"
    LET g_tables[129].prog="atmi182"  LET g_tables[130].prog="atmi183"
  # LET g_tables[131].prog="artt301"  LET g_tables[132].prog="atmi215"       #FUN-AA0083 mark 
    LET g_tables[131].prog="aimi200"  #LET g_tables[132].prog="aimi201"       #FUN-B40037 #FUN-B60097 mark
    LET g_tables[132].prog="aimi201"  LET g_tables[133].prog="almi530"        #FUN-B40037  #FUN-B70021 add
    LET g_tables[134].prog="aeci600"  LET g_tables[135].prog="aeci620"       #FUN-D40046 add
    LET g_tables[136].prog="aeci650"  LET g_tables[137].prog="aeci670"       #FUN-D40046 add    
    #FUN-AA0006 ------------------------addd end---------------------
    #CHI-A80055 mod +1 --end--

    #table清單,與程序一一對應,其中axmi040有兩個table
    LET g_tables[01].zr02="gem_file" LET g_tables[02].zr02="gen_file"
    LET g_tables[03].zr02="azi_file" LET g_tables[04].zr02="azf_file"
    LET g_tables[05].zr02="geb_file" LET g_tables[06].zr02="gea_file"
    LET g_tables[07].zr02="gfe_file" LET g_tables[08].zr02="smc_file"  #MOD-980147 tag_file->smc_file
    LET g_tables[09].zr02="geo_file" LET g_tables[10].zr02="gec_file"
    LET g_tables[11].zr02="ged_file" LET g_tables[12].zr02="azh_file"
    LET g_tables[13].zr02="azf_file" LET g_tables[14].zr02="azf_file"  #'2' '6'  #MOD-A60132 14 apr_file->azf_file
    LET g_tables[15].zr02="azf_file" LET g_tables[16].zr02="azf_file"  #'8' 'A'  #MOD-A60132 16 apo_file->azf_file
    LET g_tables[17].zr02="azf_file" LET g_tables[18].zr02="azf_file"  #'D' 'E'  #MOD-A60132 18 fab_file->azf_file
    LET g_tables[19].zr02="azf_file" LET g_tables[20].zr02="azf_file"  #'F' 'G'  #MOD-A60132 20 fac_file->azf_file
    LET g_tables[21].zr02="azf_file" LET g_tables[22].zr02="apr_file"  #'H'      #MOD-A60132 22 fag_file->apr_file
    LET g_tables[23].zr02="apo_file" LET g_tables[24].zr02="fab_file"            #MOD-A60132 23 azf_file->apo_file 24 nmb_file->fab_file
    LET g_tables[25].zr02="fac_file" LET g_tables[26].zr02="fag_file"            #MOD-A60132 25 azf_file->fac_file 26 nmc_file->fag_file 
    LET g_tables[27].zr02="nmb_file" LET g_tables[28].zr02="nmc_file"            #MOD-A60132 27 azf_file->nmb_file 28 nmk_file->nmc_file    
    LET g_tables[29].zr02="nmk_file" LET g_tables[30].zr02="nml_file"            #MOD-A60132 29 azf_file->nmk_file
    LET g_tables[31].zr02="nmo_file" LET g_tables[32].zr02="nmt_file"
    LET g_tables[33].zr02="pma_file" LET g_tables[34].zr02="pmb_file"
    LET g_tables[35].zr02="cph_file" LET g_tables[36].zr02="cpj_file"
    LET g_tables[37].zr02="cpw_file" LET g_tables[38].zr02="qca_file"
    LET g_tables[39].zr02="qch_file" LET g_tables[40].zr02="qce_file"
    LET g_tables[41].zr02="qcj_file" LET g_tables[42].zr02="qcb_file"
    LET g_tables[43].zr02="raa_file" LET g_tables[44].zr02="obm_file"  #FUN-AA0083 mod oaj_file -> raa_file
    LET g_tables[45].zr02="tqa_file" LET g_tables[46].zr02="tqa_file"  #    '1'
    LET g_tables[47].zr02="tqa_file" LET g_tables[48].zr02="tqa_file"  #'2' '3'
    LET g_tables[49].zr02="tqa_file" LET g_tables[50].zr02="tqa_file"  #'4' '5'
    LET g_tables[51].zr02="tqa_file" LET g_tables[52].zr02="tqa_file"  #'6' '7'
    LET g_tables[53].zr02="tqa_file" LET g_tables[54].zr02="tqa_file"  #'8' '9'
    LET g_tables[55].zr02="tqa_file" LET g_tables[56].zr02="tqa_file"  #'10''11'
    LET g_tables[57].zr02="tqa_file" LET g_tables[58].zr02="tqa_file"  #'12''13'
    LET g_tables[59].zr02="tqa_file" LET g_tables[60].zr02="tqa_file"  #'14''15'
    LET g_tables[61].zr02="tqa_file" LET g_tables[62].zr02="tqa_file"  #'16''17'
    LET g_tables[63].zr02="tqa_file" LET g_tables[64].zr02="tqa_file"  #'18''19'
    LET g_tables[65].zr02="tqa_file" LET g_tables[66].zr02="cab_file"  #'20'     #MOD-A60132 ccd_file->cab_file
    LET g_tables[67].zr02="oab_file" LET g_tables[68].zr02="oac_file"
    LET g_tables[69].zr02="oae_file" LET g_tables[70].zr02="oaf_file"
    LET g_tables[71].zr02="oag_file" LET g_tables[72].zr02="oaj_file"
    LET g_tables[73].zr02="oak_file" LET g_tables[74].zr02="ock_file"
    LET g_tables[75].zr02="oba_file" LET g_tables[76].zr02="obb_file"
    LET g_tables[77].zr02="obe_file" LET g_tables[78].zr02="oca_file"
    LET g_tables[79].zr02="oza_file" LET g_tables[80].zr02="ozb_file"
    LET g_tables[81].zr02="ozc_file" LET g_tables[82].zr02="imz_file" #CHI-A80055 add imz_file
    #CHI-A80055 mod +1 --start--
    #FUN-AA0006 -----------------------add start----------------------
    LET g_tables[83].zr02="lmm_file"         LET g_tables[84].zr02="lmn_file"
    LET g_tables[85].zr02="lmq_file"         LET g_tables[86].zr02="lmr_file"
    LET g_tables[87].zr02="lms_file"         LET g_tables[88].zr02="lmt_file"
    LET g_tables[89].zr02="lnj_file"         LET g_tables[90].zr02="lnr_file"
#FUN-BC0058 MARK---
#    LET g_tables[91].zr02="lpa_file"         LET g_tables[92].zr02="lpb_file"    
#    LET g_tables[93].zr02="lpc_file"         LET g_tables[94].zr02="lpd_file"
#    LET g_tables[95].zr02="lpe_file"         LET g_tables[96].zr02="lpf_file"
#    LET g_tables[97].zr02="lpg_file"         LET g_tables[98].zr02="lph_file"
#FUN-BC0058 MARK---
#FUN-BC0058 begin---
    LET g_tables[91].zr02="lpc_file"         LET g_tables[92].zr02="lpc_file"   #'1' '2'
    LET g_tables[93].zr02="lpc_file"         LET g_tables[94].zr02="lpc_file"   #'3' '4'
    LET g_tables[95].zr02="lpc_file"         LET g_tables[96].zr02="lpc_file"   #'5' '6'
    LET g_tables[97].zr02="lpc_file"         LET g_tables[98].zr02="lpc_file"   #'7' '8'
#FUN-BC0058 end ---
#   LET g_tables[99].zr02="lnk_file"         LET g_tables[100].zr02="lrz_file"      #FUN-BC0058 mark
    LET g_tables[99].zr02="lph_file"         LET g_tables[100].zr02="lrz_file"      #FUN-BC0058 add
    LET g_tables[101].zr02="lpx_file"        LET g_tables[102].zr02="lnk_file"
    LET g_tables[103].zr02="lqf_file"        LET g_tables[104].zr02="rya_file"
    LET g_tables[105].zr02="ryb_file"        LET g_tables[106].zr02="ryf_file"
    LET g_tables[107].zr02="tqa_file"        LET g_tables[108].zr02="tqa_file"
    LET g_tables[109].zr02="tqa_file"        LET g_tables[110].zr02="tqa_file"
    LET g_tables[111].zr02="ryd_file"        LET g_tables[112].zr02="rxw_file"
    LET g_tables[113].zr02="rta_file"        LET g_tables[114].zr02="rtb_file"
    LET g_tables[115].zr02="rtc_file"        LET g_tables[116].zr02="rvi_file"
    LET g_tables[117].zr02="rvj_file"        LET g_tables[118].zr02="rvk_file"
    LET g_tables[119].zr02="tqb_file"        LET g_tables[120].zr02="obp_file"          #FUN-AA0083 mod obm_file-> tqb_file 
    LET g_tables[121].zr02="obn_file"        LET g_tables[122].zr02="obo_file"
    LET g_tables[123].zr02="obq_file"        LET g_tables[124].zr02="obr_file"
    LET g_tables[125].zr02="obs_file"        LET g_tables[126].zr02="obt_file"
    LET g_tables[127].zr02="obu_file"        LET g_tables[128].zr02="obv_file"
    LET g_tables[129].zr02="obz_file"        LET g_tables[130].zr02="adj_file"
  # LET g_tables[131].zr02="raa_file"        LET g_tables[132].zr02="tqb_file"          #FUN-AA0083 mark 
    LET g_tables[131].zr02="imd_file"        #LET g_tables[132].zr02="imd_file"      #FUN-B40037 #FUN-B60097 mark
    LET g_tables[132].zr02="ime_file"        LET g_tables[133].zr02="lqq_file"       #FUN-B40037  #FUN-B70021 add
    LET g_tables[134].zr02="eca_file"        LET g_tables[135].zr02="ecd_file"      #FUN-D40046 add
    LET g_tables[136].zr02="ecg_file"        LET g_tables[137].zr02="eci_file"      #FUN-D40046 add    
    #FUN-AA0006 -----------------------add end------------------------  
    #CHI-A80055 mod +1 --end--
END FUNCTION
 
FUNCTION p603_init_b()
  DEFINE l_sql,l_where  STRING
 
    CALL g_tables.clear()
    CALL p603_set_tables()
    LET l_sql="SELECT gaz03 FROM gaz_file",
              " WHERE gaz01 = ? ",
              "   AND gaz02 = '",g_lang,"'",
              "   AND gaz05 = 'N' "
 
    PREPARE p603_prepare1 FROM l_sql
    DECLARE p603_bc1 SCROLL CURSOR FOR p603_prepare1
 
    LET l_sql="SELECT gat03 FROM gat_file",
              " WHERE gat01 = ?   ",
              "   AND gat_file.gat02 = '",g_lang,"'"
 
    PREPARE p603_prepare2 FROM l_sql
    DECLARE p603_bc2 SCROLL CURSOR FOR p603_prepare2
 
    LET g_cnt = 1
    LET g_rec_b = g_tables.getLength()
    FOR g_cnt = 1 TO g_rec_b
        LET g_tables[g_cnt].sel = 'N'
        OPEN p603_bc1 USING g_tables[g_cnt].prog
        FETCH FIRST p603_bc1 INTO g_tables[g_cnt].gaz03
        CLOSE p603_bc1
        OPEN p603_bc2 USING g_tables[g_cnt].zr02
        FETCH FIRST p603_bc2 INTO g_tables[g_cnt].gat03
        CLOSE p603_bc2
    END FOR
 
END FUNCTION
 
FUNCTION p603_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tables TO s_tables.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
#     ON ACTION dantou
#        LET g_action_choice="dantou"
#        EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION carry
         LET g_action_choice="carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice="download"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p603_download()
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10  #No.FUN-830090
  DEFINE l_flag       LIKE type_file.chr1   #No.FUN-830090
 
    #No.FUN-830090  --Begin
    LET l_flag = 'N'
    FOR l_i = 1 TO g_tables.getLength()
        IF g_tables[l_i].sel = 'Y' THEN 
           LET l_flag = 'Y'
        END IF
    END FOR 
    IF l_flag = 'N' THEN
       CALL cl_err('','aoo-096',0)
       RETURN
    END IF
    #No.FUN-830090  --End  
 
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
 
    CALL p603_download_files(l_path)
 
END FUNCTION
 
FUNCTION p603_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE type_file.chr50
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_sql             STRING       #CHI-A60030 add
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   FOR l_i = 1 TO g_tables.getLength()
       IF cl_null(g_tables[l_i].zr02) THEN
          CONTINUE FOR
       END IF
       IF g_tables[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
       LET l_upload_file = l_tempdir CLIPPED,'/',g_tables[l_i].prog CLIPPED,
                           '_',g_tables[l_i].zr02 CLIPPED,'_0.txt'
       LET l_download_file = p_path CLIPPED,"/",g_tables[l_i].prog CLIPPED,
                             '_',g_tables[l_i].zr02 CLIPPED,'_0.txt'
       #CHI-A60030 mark --start--
       #LET g_sql = 'unloadx ',g_dbs CLIPPED,' ',l_upload_file CLIPPED,
       #             ' "SELECT * FROM ',g_tables[l_i].zr02 CLIPPED,'"'
       #CHI-A60030 mark --end--
       #CHI-A60030 add --start--
       CASE g_tables[l_i].prog
          WHEN "aooi301"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='2' "
          WHEN "aooi304"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='6' "
          WHEN "aooi305"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='8' "
          WHEN "aooi306"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='A' "
          WHEN "aooi309"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='D' "
          WHEN "aooi310"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='E' "
          WHEN "aooi311"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='F' "
          WHEN "aooi312"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='G' "
          WHEN "aooi313"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE azf02='H' "
          WHEN "atmi401"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='1' "
          WHEN "atmi402"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='2' "
          WHEN "atmi403"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='3' "
          WHEN "atmi404"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='4' "
          WHEN "atmi405"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='5' "
          WHEN "atmi406"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='6' "
          WHEN "atmi407"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='7' "
          WHEN "atmi408"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='8' "
          WHEN "atmi409"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='9' "
          WHEN "atmi410"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='10' "
          WHEN "atmi411"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='11' "
          WHEN "atmi412"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='12' "
          WHEN "atmi413"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='13' "
          WHEN "atmi414"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='14' "
          WHEN "atmi415"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='15' "
          WHEN "atmi416"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='16' "
          WHEN "atmi417"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='17' "
          WHEN "atmi418"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='18' "
          WHEN "atmi419"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='19' "
          WHEN "atmi420"
	    LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='20' "
#FUN-AA0006 --------------add start-------------------------------------------------------
          WHEN "almi550"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE lnk02='1' "
          WHEN "almi660"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE lnk02='2' "
          WHEN "arti101"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='21' "
          WHEN "arti102"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='22' "
          WHEN "arti103"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='23' "
          WHEN "arti104"
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED," WHERE tqa03='24' "
#FUN-AA0006 --------------add end--------------------------------------------------------------- 
          OTHERWISE
            LET l_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED
       END CASE
       LET g_sql = 'unloadx ',g_dbs CLIPPED,' ',l_upload_file CLIPPED,' " ',l_sql,'"'  
       #CHI-A60030 add --end--
       RUN g_sql RETURNING l_status
       IF l_status THEN
       #  CALL cl_err(l_upload_file,STATUS,1)
       #  CONTINUE FOR   #No.MOD-840246
       END IF
       MESSAGE "Download File:",l_download_file CLIPPED
       CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
       IF l_status THEN
          CALL cl_err(l_upload_file,STATUS,1)
          CONTINUE FOR
       END IF
       LET g_sql = "rm ",l_upload_file CLIPPED
       RUN g_sql 
   END FOR
 
END FUNCTION
