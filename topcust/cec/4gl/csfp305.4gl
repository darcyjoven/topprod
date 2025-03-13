# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: csfp305.4gl
# Descriptions...: 訂單整批工單產生作業
# Date & Author..: 16/08/03 BY aiqq
# Modify.........: 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../topcust/csf/4gl/csfp304.global"

DEFINE
         g_argv1   LIKE   oea_file.oea01,  #TQC-730022
         g_argv2   LIKE   smy_file.smyslip,  #TQC-730022
         g_argv3   LIKE   type_file.chr1,    #TQC-730022
         g_ima     RECORD LIKE ima_file.*,
         g_oea     RECORD LIKE oea_file.*,
         g_sfb     RECORD LIKE sfb_file.*,
         g_flag    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
         sfc_sw    LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         lot       LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
#        lota      LIKE ima_file.ima26,    #No.FUN-680121 DEC(15,3), 
         lota      LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044 
         l_mod     LIKE type_file.num10,   #No.FUN-680121 INTEGER, 
         g_cmd,g_sql,g_sql_smy  STRING,  #No.FUN-580092 HCN
         g_t1      LIKE oay_file.oayslip,                     #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
         g_sw      LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
         mm_sfb7  LIKE sfb_file.sfb08,
         l_ima60   LIKE ima_file.ima60,
         l_ima601  LIKE ima_file.ima601,   #No.FUN-840194 
         l_oeb05   LIKE oeb_file.oeb05,
         l_ima55   LIKE ima_file.ima55,
         l_ima562  LIKE ima_file.ima562,
 
         new DYNAMIC ARRAY OF RECORD
                x             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                new_part      LIKE ima_file.ima01,    #No.MOD-490217
                ima02         LIKE ima_file.ima02,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sfb93         LIKE sfb_file.sfb93,    #FUN-A50066
                sfb06         LIKE sfb_file.sfb06,    #FUN-A50066
                new_qty       LIKE sfb_file.sfb08,    #No.FUN-680121 DEC(15,3),
                b_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                e_date        LIKE type_file.dat,     #No.FUN-680121 DATE
                sfb02         LIKE sfb_file.sfb02,    #FUN-650054
                new_no        LIKE oea_file.oea01,    #No.FUN-680121 VARCHAR(16), #No.FUN-550067  
                ven_no        LIKE pmc_file.pmc01    #No.FUN-680121 VARCHAR(10),
                END RECORD,
         tm         RECORD
                gen02         LIKE gen_file.gen02,
                desc          LIKE pmc_file.pmc01,  #No.FUN-680121 VARCHAR(10),
                gem01         LIKE gem_file.gem01,  #FUN-670103
                skd01         LIKE skd_file.skd01, #No.FUN-810014
                sfb81         LIKE sfb_file.sfb81, #No.FUN-810014
              tc_cpb01        LIKE tc_cpb_file.tc_cpb01,
                sfb01         LIKE sfb_file.sfb01,
               slip           LIKE smy_file.smyslip,
                sfc01         LIKe sfc_file.sfc01, #No.FUN-810014
                bmb09         LIKE bmb_file.bmb09, #No.FUN-870117
                mac_opt       LIKE type_file.chr1  #FUN-A80102
                END RECORD
#FUN-D50098 ------Begin------
  DEFINE
   mg
      DYNAMIC ARRAY OF RECORD
         orno  LIKE sfb_file.sfb01
      END RECORD
#FUN-D50098 ------End--------
  DEFINE l_slip LIKE sfb_file.sfb01   #00-12-26
 
DEFINE   l_max_no    LIKE sfb_file.sfb01         #No.MOD-960317 add
DEFINE   l_min_no    LIKE sfb_file.sfb01         #No.MOD-960317 add
DEFINE   g_chr           LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_msg2          STRING
DEFINE   g_wc            STRING                  #FUN-920088
DEFINE   l_barcode_yn    LIKE ima_file.ima930    #DEV-D30026 add      #條碼使用否 
#add by aiqq160730------s
DEFINE   g_chk           LIKE type_file.chr1 
DEFINE   g_bom       DYNAMIC ARRAY OF RECORD       #新增bom资料
                     bmb01   LIKE bmb_file.bmb01,  #主件料号
                     bmb03   LIKE bmb_file.bmb03   #元件料号
                     END RECORD   
DEFINE   g_cnt_1     LIKE type_file.num10
DEFINE   g_sfb08     LIKE  sfb_file.sfb08


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   LET g_argv1  = ARG_VAL(1)
   LET g_argv2  = ARG_VAL(2)
   LET g_argv3  = ARG_VAL(3)
   IF cl_null(g_argv3) THEN
     LET g_argv3 = 'N'
   END IF
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   LET g_chk = 'N'    #add by aiqq160730
   LET g_cnt_1 = 0    #add by aiqq160730
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   
    DROP TABLE q003_tmp
    CREATE TEMP TABLE q003_tmp
    (sfb01    LIKE sfb_file.sfb01,
     sfb05    LIKE sfb_file.sfb05,
     sfb08    LIKE sfb_file.sfb08)    
#     sfb08b    LIKE sfb_file.sfb08)   #tianry add 用来记录生成工单信息
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-A70028 add
   IF g_bgjob = 'N' THEN
      CALL p305_tm()
   ELSE
      LET g_oea.oea01 = g_argv1 CLIPPED
      LET g_sfb.sfb81 = TODAY
      CALL p305_fill_b_data()
      LET g_success='Y'
      CALL asfp305()
      
      IF g_success='Y' THEN
         MESSAGE "Success!"
      END IF
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No:MOD-A70028 add
END MAIN
 
FUNCTION p305_tm()
   DEFINE   p_row,p_col,i    LIKE type_file.num5    #No.FUN-680121 SMALLINT
#  DEFINE   mm_qty,mm_qty1   LIKE ima_file.ima26    #No.FUN-680121 DEC(15,3)
   DEFINE   mm_qty,mm_qty1   LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_oea00          LIKE oea_file.oea00    #No.MOD-940349 add
   DEFINE   l_costcenter     LIKE gem_file.gem01   #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02   #FUN-670103
 
   IF s_shut(0) THEN
      RETURN
   END IF
   LET p_row = 2 
   LET p_col = 4 
 
     OPEN WINDOW p305_w AT p_row,p_col
        WITH FORM "csf/42f/csfp305"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()    
 
   CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("gem01",TRUE)
   END IF
   CALL cl_set_comp_visible("costcenter,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("sfb919,gb3",g_sma.sma1421='Y')  #FUN-A80102
   CALL cl_set_comp_visible("edc01,edc02",g_sma.sma541='Y')  #FUN-A80054
 
   CALL cl_opmsg('z')
 
   WHILE TRUE  #MOD-490189
 
   MESSAGE ''
   CLEAR FORM 
   INITIALIZE g_oea.* TO NULL
   INITIALIZE tm.*    TO NULL
   LET mm_qty=0   
   LET mm_qty1=0   
   LET sfc_sw='Y'
   LET lot=1   
   LET g_sw='N' 
   LET g_sfb.sfb81 = TODAY
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   LET tm.gem01=g_grup    #FUN-670103
   LET l_gem02c = ''                                              #FUN-920088
   SELECT gem02 INTO l_gem02c FROM gem_file WHERE gem01=tm.gem01  #FUN-920088
      AND gemacti='Y'                                             #FUN-920088
      IF tm.mac_opt IS NULL THEN LET tm.mac_opt='N' END IF #FUN-A80102
      DISPLAY BY NAME g_sfb.sfb81,tm.gem01 #FUN-670103 #FUN-650054 ,tm.wo_type
      DISPLAY BY NAME tm.mac_opt  #FUN-A80102
      DISPLAY l_gem02c TO gem02   #FUN-920088
 
      INPUT BY NAME g_sfb.sfb81,tm.tc_cpb01,tm.sfb01 WITHOUT DEFAULTS  #FUN-670103 #FUN-650054 ,tm.wo_type #FUN-920088  #FUN-A80102
 
        AFTER FIELD tc_cpb01
            IF NOT cl_null(tm.tc_cpb01) THEN
               SELECT  COUNT(*) INTO l_cnt FROM tc_cpb_file WHERE tc_cpb01=tm.tc_cpb01  
               AND tc_cpbconf='Y' 
               IF l_cnt=0 THEN
                  CALL cl_err(tm.tc_cpb01,'csf-092',1)
                  NEXT FIELD tc_cpb01
               END IF
            END IF
        AFTER FIELD  sfb01
           IF NOT cl_null(tm.sfb01) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM smy_file
               WHERE smyslip = tm.sfb01 AND smysys = 'asf' AND smykind = '1' AND smyud03='Y'
              IF SQLCA.sqlcode OR cl_null(tm.sfb01) THEN
                 LET l_cnt = 0
              END IF
              IF l_cnt = 0 THEN
                 CALL cl_err(tm.sfb01,'asf-822',0)
                 NEXT FIELD sfb01
              END IF
           END IF

        #TQC-C80187----add----begin
        AFTER INPUT
              IF INT_FLAG THEN
                 EXIT INPUT
              END IF
            ON ACTION CONTROLP
               CASE
                  WHEN INFIELD(sfb01)
                       CALL q_smy(FALSE,TRUE,tm.sfb01,'ASF','1') RETURNING tm.sfb01
                       DISPLAY BY NAME tm.sfb01
                       NEXT FIELD sfb01

                   WHEN INFIELD(tc_cpb01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_pja"
                       LET g_qryparam.default1= tm.tc_cpb01
                       CALL cl_create_qry() RETURNING tm.tc_cpb01
                  #     CALL t110_tc_cpb01('d')
                       NEXT FIELD tc_cpb01

                  OTHERWISE EXIT CASE
              END CASE
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

#TQC-A50129 --begin--         
         ON ACTION controlg
            CALL cl_cmdask()   
#TQC-A50129 --end--  
      
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      
      #將塞單身這段整個搬出成一個FUNCTION
      CALL p305_fill_b_data()
            
      LET g_success='Y'
      LET g_flag='Y'
      CALL asfp305()
         CALL cl_confirm('lib-005') RETURNING l_flag
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW p305_w
 
END FUNCTION
 
FUNCTION p305_fill_b_data()
   DEFINE   p_gem01          LIKE gem_file.gem01
   DEFINE   l_cnt,s_date     LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE   l_time           LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE   l_sfb08          LIKE sfb_file.sfb08
   DEFINE   l_flag           LIKE type_file.chr1                  #No.FUN-680121 VARCHAR(1)
   DEFINE   l_cn             LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima55_fac      LIKE ima_file.ima55_fac
   DEFINE   l_check          LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE   l_ima59          LIKE ima_file.ima59
   DEFINE   l_ima61          LIKE ima_file.ima61
   DEFINE   l_costcenter     LIKE gem_file.gem01    #FUN-670103
   DEFINE   l_gem02c         LIKE gem_file.gem02    #FUN-670103
   DEFINE   li_result        LIKE type_file.num5    #No.TQC-730022
   DEFINE   l_oea00          LIKE oea_file.oea00    #FUN-920088
   DEFINE   l_smy57          LIKE smy_file.smy57    #FUN-A50066
   DEFINE   l_sql            STRING                 #FUN-A80102
   DEFINE   l_tmp            STRING                 #FUN-A80102
   DEFINE   l_snum,l_enum    STRING                 #FUN-A80102
   DEFINE   l_ssn,l_esn      LIKE type_file.num20   #FUN-A80102
   DEFINE   l_avg_oeb12,l_tol_oeb12,l_sum_oeb12  LIKE oeb_file.oeb12    #FUN-A80102
   DEFINE   l_ima54          LIKE ima_file.ima54    #MOD-AB0243 add
   DEFINE   l_ima08          LIKE ima_file.ima08    #MOD-AB0243 add
   DEFINE   tok1             base.StringTokenizer   #FUN-B20075
   DEFINE   l_token_cnt      LIKE type_file.num10   #FUN-B20075
   DEFINE   l_sfb919         LIKE sfb_file.sfb919   #FUN-B20075
   #CHI-B80044 -- begin --
   DEFINE   l_availqty       LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE   l_calc           LIKE type_file.num5   #計算生產批量倍數用
   DEFINE   l_allowqty       LIKE sfb_file.sfb08   #允許生產數量
   #CHI-B80044
   #add by aiqq160730------s
   DEFINE   l_sfb071         LIKE sfb_file.sfb071,
            l_sfb27          LIKE sfb_file.sfb27,
            l_bmb06          LIKE bmb_file.bmb06,
            l_QPA            LIKE bmb_file.bmb06,  #FUN-560230
            l_total          LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #原發數量
            l_total2         LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #應發數量
            l_ActualQPA      LIKE bmb_file.bmb06,
            l_sfa11          LIKE sfa_file.sfa11
   #add by aiqq160730------e
      CALL new.clear()
   #   IF cl_null(g_wc) THEN
   #      LET g_wc= 'oeb01=',"'",g_argv1,"'"
   #   END IF
     #MOD-C40193 end add------
      LET g_sql = "SELECT 'Y',tc_cpb13,ima02,ima021,",
                  " '',ima94,1,'','','',ima111,'' ",  #add by aiqq160531
                  " FROM tc_cpb_file",
                  " ,ima_file  ",
                  " WHERE tc_cpb01='",tm.tc_cpb01,"' AND ima01 = tc_cpb13  "
                  # ," AND tc_cpb01||tc_cpb13 NOT IN (SELECT sfb27||sfb05 FROM sfb_file WHERE sfb87='Y' )"  #tianry add 160918
 
         PREPARE q_oeb_prepare1 FROM g_sql
         DECLARE oeb_curs1 CURSOR FOR q_oeb_prepare1
         LET g_i=1
         FOREACH oeb_curs1 INTO new[g_i].*
            #默认工艺以及单别赋值
            IF cl_null(new[g_i].new_no) THEN  #默认单别为空
               LET new[g_i].new_no=tm.sfb01      #赋值给单头默认工单单别
               SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=new[g_i].new_no
               LET new[g_i].sfb93=l_smy57[1,1]
            END IF
            LET new[g_i].b_date=g_today
            SELECT ima59 INTO l_ima59 FROM ima_file WHERE ima01=new[g_i].new_part
            LET new[g_i].e_date=g_today+l_ima59
            SELECT ima94 INTO new[g_i].sfb06 FROM ima_file WHERE ima01=new[g_i].new_part
            SELECT smy72 INTO new[g_i].sfb02 FROM smy_file WHERE smyslip=new[g_i].new_no
            IF new[g_i].sfb02='7' THEN   #委外工单
               SELECT ima54 INTO new[g_i].ven_no FROM ima_file WHERE ima01=new[g_i].new_part
            END IF


            LET g_i=g_i+1
         END FOREACH
         CALL s_showmsg()    #FUN-920088
         CALL new.deleteElement(g_i)  #MOD-490189
         LET g_i=g_i-1
END FUNCTION

#TQC-AC0238   --start  
FUNCTION i305_new_no(i)             
   DEFINE i         LIKE type_file.num5
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_smy73   LIKE smy_file.smy73    
   DEFINe l_cnt     LIKE type_file.num5    #DEV-D30026 add
 
   LET g_errno = ' '
   IF cl_null(new[i].new_no) THEN RETURN END IF
   LET l_slip = s_get_doc_no(new[i].new_no)
 
  #DEV-D30026 add str---------------------
   CALL p305_barcode_chk(new[i].new_part)
   IF l_barcode_yn = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt
      FROM smy_file,smyb_file
      WHERE smy_file.smyslip = smyb_file.smybslip AND
            smy_file.smysys = 'asf' AND
            smy_file.smykind = '1' AND
           #smyb_file.smyb01 = '2' AND #DEV-D30037--mark
            smy_file.smyslip = l_slip
      IF l_cnt = 0 THEN
         CALL cl_err('','aba-134',1)
      END IF
   ELSE
  #DEV-D30026 add end---------------------
      SELECT smy73 INTO l_smy73 FROM smy_file
       WHERE smyslip = l_slip
      IF l_smy73 = 'Y' THEN
         LET g_errno = 'asf-875'
      END IF 
   END IF        #DEV-D30026 add
END FUNCTION
#TQC-AC0238   --end 

#add by aiqq160728-----s
FUNCTION p305_cur()
   DEFINE l_sql        STRING       #NO.FUN-910082  


#---->讀取備料量(應發量-已發量)
   LET l_sql = " SELECT sum((sfa05-sfa06-sfa065)*sfa13) ",  
               "   FROM sfa_file,sfb_file ",
               "  WHERE sfa01 = sfb01",
               "    AND sfa03 = ? " ,
               "    AND sfb04 !='8' ",
               "    AND sfb02 !='2' AND sfb02 != '11' AND sfb87!='X' ",
               "    and sfb27 = ? "
               #"    AND sfb13 <='",tm.sudate,"'"   #mark by aiqq160727
               #," AND sfb27 = ? "   #add by aiqq160530
   PREPARE p305_presfa  FROM l_sql
   DECLARE p305_cssfa  CURSOR WITH HOLD FOR p305_presfa

#---->讀取獨立性需求量(工單最晚完工日) 
   LET l_sql = " SELECT sum((rpc13-rpc131)*rpc16_fac) ",
               "   FROM rpc_file WHERE rpc01 = ? "
   PREPARE p305_prerpc  FROM l_sql
   DECLARE p305_csrpc  CURSOR WITH HOLD FOR p305_prerpc

#---->讀取請購量(請購量-已轉採購量)(日期區間)
   LET l_sql = " SELECT sum((pml20-pml21)*pml09) FROM pml_file,pmk_file ",
               "  WHERE pmk01=pml01 AND pmk18 != 'X' ",
               "    AND pml04 = ? ",
               "    AND (pml16 < '6' OR pml16 = 'S' OR pml16='R' OR pml16='W') ",
               "    AND (pml011 = 'REG' OR pml011 = 'IPO') ",
               "    AND (pmk25 < '6' OR pmk25 = 'S' OR pmk25='R' OR pmk25='W') " #MOD-C30383 add

    PREPARE p305_prepml  FROM l_sql
    DECLARE p305_cspml  CURSOR WITH HOLD FOR p305_prepml
 
#---->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
   LET l_sql = " SELECT sum(((pmn20-(pmn50-pmn55))/pmn62)*pmn09) ",
               "   FROM pmn_file,pmm_file ",
               "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
               "    AND pmn61 = ? ",
               "    AND (pmn16 < '6' OR pmn16 = 'S' OR pmn16='R' OR pmn16='W') ",
               "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
               "    AND (pmn20-(pmn50-pmn55)) > 0 "
    PREPARE p305_prepmn  FROM l_sql
    DECLARE p305_cspmn  CURSOR WITH HOLD FOR p305_prepmn

#---->讀取在驗量(rvb_file)不考慮日期 
   LET l_sql = " SELECT sum((rvb07-rvb29-rvb30)*pmn09) ",
               "   FROM rvb_file,rva_file,pmn_file   ",
               "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
               "    AND rvb04=pmn01 ",               
               "    AND rvb03=pmn02 ",
               "    AND rvb05 = ?  "
   PREPARE p305_prervb FROM l_sql
   DECLARE p305_csrvb  CURSOR WITH HOLD FOR p305_prervb

#--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
     LET l_sql = " SELECT sum((sfb08-sfb09-sfb12)*ima55_fac) ", 
                 "   FROM sfb_file,ima_file ",
                 "  WHERE sfb05 = ? ",
                 "    AND ima01=sfb05 ",      
                 "    AND sfb04 != '8' ",
                 "    AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' ",
                 "    and sfb27 != ? "
      PREPARE p305_p_sfb  FROM l_sql
      DECLARE p305_c_sfb  CURSOR WITH HOLD FOR p305_p_sfb
 
END FUNCTION
#add by aiqq160728-----e
 
FUNCTION asfp305()
   DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_tc_sfb      RECORD LIKE tc_sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
   DEFINE new_part      LIKE ima_file.ima01    #No.MOD-490217
   DEFINE i,j           LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE ask           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE s_date        LIKE type_file.num5    #No.FUN-680121 SMALLINT  
   DEFINE l_time        LIKE ima_file.ima58    #No.FUN-680121 DEC(15,3)
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE l_smy57       LIKE smy_file.smy57
   DEFINE l_smy73       LIKE smy_file.smy73    #TQC-AC0238
   DEFINE l_ima910      LIKE ima_file.ima910   #FUN-550112
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067  #No.FUN-680121 SMALLINT
   DEFINE   l_max_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE   l_min_no    LIKE sfb_file.sfb01         #No:MOD-950298 add
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_qty         LIKE oeb_file.oeb12
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac
   DEFINE l_check       LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_cn          LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ima59       LIKE ima_file.ima59
   DEFINE l_ima61       LIKE ima_file.ima61
   DEFINE l_oeb15       LIKE oeb_file.oeb15     #FUN-640148 add
   DEFINE l_btflg       LIKE type_file.chr1     #FUN-650054
   DEFINE l_proc        LIKE type_file.chr1     #No.TQC-7B0031
   DEFINE l_sfbi        RECORD LIKE sfbi_file.* #No.FUN-7B0018
   DEFINE l_formid      LIKE oay_file.oayslip   #TQC-9B0181
   DEFINE l_ima571      LIKE ima_file.ima571    #FUN-A50066
   DEFINE l_cnt         LIKE type_file.num5     #FUN-A50066
   DEFINE l_sfc01       LIKE sfc_file.sfc01     #FUN-A80054
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-A80054
   DEFINE l_sfci        RECORD LIKE sfci_file.* #FUN-A80054
   DEFINE l_flag        LIKE type_file.chr1     #FUN-A80054
   DEFINE l_new_no1     STRING                  #MOD-AC0288
   DEFINE l_new_no      LIKE smy_file.smyslip   #MOD-AC0288
   DEFINE l_sfd01       LIKE sfd_file.sfd01     #FUN-B30035
   DEFINE l_ima56       LIKE ima_file.ima56     #TQC-B60323
   DEFINE l_ima561      LIKE ima_file.ima561    #TQC-B60323
   DEFINE l_qty1        LIKE sfb_file.sfb08     #TQC-B60323
   DEFINE l_qty2        LIKE ima_file.ima56     #TQC-B60323
   #CHI-B80044 -- begin --
   DEFINE l_availqty        LIKE sfb_file.sfb08   #訂單可轉工單數量
   DEFINE l_allowqty        LIKE sfb_file.sfb08   #允許生產數量
   DEFINE l_calc            LIKE type_file.num5   #計算生產批量倍數用
   #CHI-B80044 -- end --
   DEFINE l_i           LIKE type_file.num5   #FUN-C50052
  #MOD-C90048 add---S   
   DEFINE l_oeb41       LIKE oeb_file.oeb41,
          l_oeb42       LIKE oeb_file.oeb42,
          l_oeb43       LIKE oeb_file.oeb43,
          l_oeb1001     LIKE oeb_file.oeb1001
  #MOD-C90048 add---E
  DEFINE b_sfb          RECORD LIKE sfb_file.*     #add by aiqq160713
  DEFINE l_sfa03        LIKE sfa_file.sfa03        #add by aiqq160713
  DEFINE l_sfa05        LIKE sfa_file.sfa05        #add by aiqq160713
  DEFINE l_sql          STRING    #add by aiqq160713
  #add by aiqq160728
  DEFINE l_sfb01        LIKE sfb_file.sfb01,
         l_sfb27        LIKE sfb_file.sfb27,
         l_sfb05        LIKE sfb_file.sfb05,
         l_sfb08_t      LIKE sfb_file.sfb08
  DEFINE l_avl_stk  LIKE type_file.num15_3, #FUN-A20044
         l_avl_stk_mpsmrp   LIKE type_file.num15_3, #FUN-A20044 
         l_unavl_stk        LIKE type_file.num15_3,
         qc_qty      LIKE pml_file.pml20,   #檢驗量
         po_qty      LIKE pml_file.pml20,   #採購量
         pr_qty      LIKE pml_file.pml20,   #請購量
         wo_qty      LIKE pml_file.pml20,   #在制量
         rpc_qty     LIKE type_file.num15_3 ,
         al_qty      LIKE type_file.num15_3  
 #add by aiqq160730------s
  DEFINE l_sfa   RECORD LIKE sfa_file.*
  DEFINE l_bmb   RECORD LIKE bmb_file.*
   DEFINE   l_sfb071         LIKE sfb_file.sfb071,
            l_bmb06          LIKE bmb_file.bmb06,
            l_QPA            LIKE bmb_file.bmb06,  #FUN-560230
            l_total          LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #原發數量
            l_total2         LIKE sfa_file.sfa07,          #No.FUN-680147 DECIMAL(13,5)   #應發數量
            l_ActualQPA      LIKE bmb_file.bmb06,
            l_sfa11          LIKE sfa_file.sfa11,
            l_ima08          LIKE ima_file.ima08,
            l_ima86          LIKE ima_file.ima86
    DEFINE l_bom  RECORD  
               bmb01   LIKE bmb_file.bmb01,
               bmb03   LIKE bmb_file.bmb03
               END RECORD 
   DEFINE l_bmb01_t   LIKE bmb_file.bmb01 
   DEFINE l_bmb03_t   LIKE bmb_file.bmb03  
   #add by aiqq160730------e
   DEFINE l_tc_sfa01  LIKE tc_sfa_file.tc_sfa01,
          l_tc_sfa02  LIKE tc_sfa_file.tc_sfa02,
          l_tc_sfa03  LIKE tc_sfa_file.tc_sfa03,
          l_tc_sfa04  LIKE tc_sfa_file.tc_sfa04,
          sh_qty      LIKE type_file.num15_3,
          l_sum_sfb08 LIKE sfb_file.sfb08
  DEFINE  l_tc_sfaa04   LIKE tc_sfaa_file.tc_sfaa04,
          l_tc_sfaa06   LIKE tc_sfaa_file.tc_sfaa06,
          l_tc_sfaa05   LIKE tc_sfaa_file.tc_sfaa05,
          l_xuqiu       LIKE sfb_file.sfb08,
          l_img10       LIKE img_file.img10,
          l_zaiwai      LIKE img_file.img10,
          l_gongdan     LIKE sfb_file.sfb08,
          l_xmgongdan   LIKE sfb_file.sfb08,
          l_xiajie      LIKE sfa_file.sfa05,
          l_tc_sfaa09   LIKE tc_sfaa_file.tc_sfaa09,
          l_slip        LIKE smy_file.smyslip,
          l_pml20       LIKE  pml_file.pml20,
          l_xmpml20     LIKE  pml_file.pml20 
 DEFINE l_show_msg  DYNAMIC ARRAY OF RECORD
         sfb01    LIKE sfb_file.sfb01,
         sfb05    LIKE sfb_file.sfb05,
         sfb08    LIKE sfb_file.sfb08
         END RECORD,
       l_gaq03_f1  LIKE gaq_file.gaq03,
       l_gaq03_f2  LIKE gaq_file.gaq03,
       l_gaq03_f3  LIKE gaq_file.gaq03
DEFINE l_str1     STRING
DEFINE l_bma05    DATE
   DELETE FROM q003_tmp
   WHILE TRUE
       LET g_flag='Y' #MOD-530283


    IF g_bgjob = 'N' THEN #TQC-730022
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
         BEFORE INPUT                                            #TQC-C50223 add
            CALL cl_set_comp_required("b_date,e_date",TRUE)      #TQC-C50223 add

         BEFORE ROW       
            LET i=ARR_CURR()
            IF cl_null(new[i].sfb93) THEN LET new[i].sfb93='N' END IF
            IF new[i].sfb93 = 'N' THEN LET new[i].sfb06='' END IF  #TQC-C70104 add
            CALL p305_set_entry_b()
            CALL p305_set_no_entry_b(i)
            CALL p305_set_no_required_b()
            CALL p305_set_required_b(i)
            #TQC-C70104--add--end--
               
            
         BEFORE INSERT
            LET new[i].sfb02='1'
            DISPLAY BY NAME new[i].sfb02
            IF cl_null(new[i].sfb93) THEN
               LET new[i].sfb93 = 'N'
               DISPLAY BY NAME new[i].sfb93
            END IF
   
         ON CHANGE x
            CALL p305_set_entry_b()
            CALL p305_set_no_entry_b(i)
            CALL p305_set_no_required_b()
            CALL p305_set_required_b(i)

         AFTER FIELD x
            IF NOT cl_null(new_part) THEN
             IF new[i].x IS NULL OR (new[i].x != 'Y' AND new[i].x != 'N') THEN
               NEXT FIELD x
             END IF
            END IF
            IF new[i].x = 'Y' AND NOT cl_null(new[i].new_no[g_no_sp,g_no_sp]) THEN      #No.FUN-550067 
                     CALL cl_err('','asf-371','1')                                                                                 
            END IF
            IF new[i].x='N'  THEN
               CALL cl_set_comp_entry("sfb93,sfb06,new_qty,b_date,e_date,sfb02,new_no,ven_no",FALSE)
            ELSE
               CALL cl_set_comp_entry("sfb93,sfb06,new_qty,b_date,e_date,sfb02,new_no,ven_no",TRUE)
            END IF           


   
         ON CHANGE sfb93
            CALL p305_set_entry_b()
            CALL p305_set_no_entry_b(i)
            CALL p305_set_no_required_b()
            CALL p305_set_required_b(i)              
            
         AFTER FIELD sfb93
             IF NOT cl_null(new[i].sfb93) THEN
                IF new[i].sfb93 <> 'Y' THEN
                   LET new[i].sfb06 = ''
                   DISPLAY BY NAME new[i].sfb06
                END IF   
             END IF
             
         AFTER FIELD sfb06
             IF NOT cl_null(new[i].sfb06) THEN
                SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                LET l_cnt = 0
                SELECT count(*) INTO l_cnt FROM ecu_file
                 WHERE (ecu01=l_ima571 OR ecu01=new[i].new_part)
                   AND ecu02 = new[i].sfb06
                   AND ecuacti = 'Y'  #CHI-C90006
                IF l_cnt = 0 THEN
                   CALL cl_err('','mfg4030',1)
                   NEXT FIELD sfb06
                END IF
             END IF

         BEFORE FIELD new_qty
            IF new[i].x = 'N' THEN
            END IF
   
         AFTER FIELD new_qty 
            IF new[i].new_qty IS NULL OR new[i].new_qty<0 THEN 
               NEXT FIELD new_qty 
            END IF
               IF new[i].x = 'Y' THEN          #MOD-BA0006 add
                  SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file WHERE ima01=new[i].new_part
                  IF l_ima561 > 0 THEN
                     IF new[i].new_qty < l_ima561 THEN
                        CALL cl_err(l_ima561,'asf-307',0)
                        NEXT FIELD new_qty
                     END IF
                  END IF
                  IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
                     LET l_qty1 = new[i].new_qty * 1000
                     LET l_qty2 = l_ima56 * 1000
                     IF (l_qty1 MOD l_qty2) > 0 THEN
                        CALL cl_err(l_ima56,'asf-308',0)
                        NEXT FIELD new_qty
                     END IF
                     #CHI-B80044 -- begin --
                     LET l_calc = 0
                     LET l_allowqty = new[i].new_qty
                     IF l_qty MOD l_ima56 > 0 THEN
                        LET l_calc = l_qty/l_ima56 + 1
                        LET l_allowqty = l_calc * l_ima56
                     END IF
                     IF new[i].new_qty > l_allowqty THEN
                        CALL cl_err('','asf-358',1)
                        LET new[i].new_qty = l_allowqty
                        NEXT FIELD new_qty
                     END IF
                     #CHI-B80044 -- end --
                  END IF
               END IF            #MOD-BA0006 add        
            IF new[i].new_qty > l_qty THEN
               CALL cl_err('','asf-939',0)
            END IF
 
   
         AFTER FIELD new_no  
            LET i=ARR_CURR()
            IF NOT cl_null(new[i].new_no) THEN  #TQC-C70104 add
               CALL i305_new_no(i)          
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(new[i].new_no,g_errno,0)
                 LET  new[i].new_no = NULL
                 DISPLAY BY NAME new[i].new_no
                 NEXT FIELD new_no
               END IF                                                                  
            END IF #TQC-C70104 add
           
         AFTER FIELD ven_no
            LET i=ARR_CURR()
            IF NOT cl_null(new[i].ven_no) THEN    #No.TQC-920104 add
                IF new[i].sfb02=1 THEN #FUN-650054
                  SELECT gem02 FROM gem_file
                   WHERE gem01=new[i].ven_no
                     AND gemacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",new[i].ven_no,"",STATUS,"","sel gem:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
               IF new[i].sfb02=7 THEN #FUN-650054
                  SELECT pmc03 FROM pmc_file
                   WHERE pmc01=new[i].ven_no
                     AND pmcacti = 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",new[i].ven_no,"",STATUS,"","sel pmc:",1)    #No.FUN-660128
                     NEXT FIELD ven_no
                  END IF
               END IF
            END IF
   
         AFTER FIELD b_date
            IF NOT cl_null(new[i].b_date) THEN          
               
               IF NOT cl_null(new[i].e_date) AND new[i].e_date < new[i].b_date THEN
                  CALL cl_err('','asf-310','1')
                  NEXT FIELD b_date 
               END IF 
               LET li_result = 0
               CALL s_daywk(new[i].b_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].b_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].b_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
            END IF
   
         AFTER FIELD e_date
            IF NOT cl_null(new[i].e_date) THEN
               IF new[i].e_date < g_sfb.sfb81 THEN
                  CALL cl_err('','asf-868','1')
                  NEXT FIELD e_date
               END IF
               IF new[i].e_date < new[i].b_date THEN
                        CALL cl_err('','asf-310','1')                                                                                 
                  NEXT FIELD e_date  
               END IF 
               #MOD-C50055 add begin---------------------
               LET li_result = 0
               CALL s_daywk(new[i].e_date) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(new[i].e_date,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(new[i].e_date,'mfg3153',1)
               END IF
               #MOD-C50055 add end-----------------------
               IF cl_confirm('asf-379') THEN
                  #前置時間(l_time)=生產數量(sfb08)*變動前置時間(ima60)
                  #if l_time <=7: 以7天計, >7:以照原值計,
                  #預計開工日(sfb13): 預計完工日-l_time,但不可小於開單日期
                  SELECT ima60,ima601,ima59,ima61 INTO l_ima60,l_ima601,l_ima59,l_ima61 FROM ima_file #No.FUN-840194 add ima601 #MOD-530799
                   WHERE ima01 = new[i].new_part
                  LET l_time=(new[i].new_qty * l_ima60/l_ima601)+l_ima59+l_ima61  #No.FUN-840194 #No.MOD-530799
                  display "l_time:" ||l_time
                  display "l_ima60:" ||l_ima60
                  display "l_ima601:" ||l_ima601  #No.FUN-840194 
                  display "l_ima59:" ||l_ima59
                  display "l_ima61:" ||l_ima61
                  display "new[i].new_qty:" ||new[i].new_qty
                  IF cl_null(l_time) THEN
                     LET l_time = 0
                  END IF
                  LET s_date=l_time+0.5
                  IF cl_null(s_date) THEN
                     LET s_date = 0
                  END IF

                 CALL s_aday(new[g_i].e_date,-1,s_date) RETURNING new[g_i].b_date  #MOD-C50055 add
  
               END IF
 
    
               DISPLAY new[i].b_date TO s_new[i].b_date 
            END IF
   
 
         AFTER ROW 
           #TQC-C70104--add--str--
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_success = 'N'
              RETURN
           END IF
           #TQC-C70104--add--end--
           #FUN-A50066--begin--add------
           LET i = ARR_CURR() 
           IF new[i].x = 'Y' THEN  #TQC-C70104 add 
              IF new[i].sfb93 = 'Y' THEN
                 IF cl_null(new[i].sfb06) THEN
                    NEXT FIELD sfb06
                 END IF
              END IF
           END IF
   
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(new_part) 
                  LET i=ARR_CURR()
                   CALL q_sel_ima(FALSE, "q_ima","",new[i].new_part,"","","","","",'' ) 
                   RETURNING  new[i].new_part
                  DISPLAY new[i].new_part TO s_new[i].new_part 
                  NEXT FIELD new_part
               WHEN INFIELD(new_qty) 
                  LET i=ARR_CURR()
                  LET g_cmd = "aimq102"," '1' "," '",new[i].new_part,"' "
                  CALL cl_cmdrun(g_cmd CLIPPED)
               WHEN INFIELD(new_no)
                 #DEV-D30026 add str-----------------------
                  CALL p305_barcode_chk(new[i].new_part)
                  IF l_barcode_yn = 'Y' THEN
                     LET i=ARR_CURR()
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smyslip2"
                     LET g_qryparam.default1 = new[i].new_no
                     LET g_qryparam.arg1 = 'asf'
                     LET g_qryparam.arg2 = '1'
                     LET g_qryparam.arg3 = '2'
                     CALL cl_create_qry() RETURNING new[i].new_no
                     DISPLAY new[i].new_no TO s_new[i].new_no
                     NEXT FIELD new_no
                  ELSE
                    #DEV-D30026 add end---------------
                     LET i=ARR_CURR()
                     LET g_sql_smy = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0238
                     CALL smy_qry_set_par_where(g_sql_smy)               #TQC-AC0238
                     LET g_t1 = s_get_doc_no(new[i].new_no)              #No.TQC-AC0238
                     CALL q_smy(FALSE,FALSE,new[i].new_no,'ASF','1') RETURNING new[i].new_no  #TQC-670008
                 #   LET new[i].new_no=g_t1                              #No.TQC-AC0238
                     DISPLAY new[i].new_no TO s_new[i].new_no     
                     NEXT FIELD new_no
                  END IF                                              #DEV-D30026 add
               WHEN INFIELD(ven_no)
                  #CASE new[i].sfb02 #FUN-650054        #MOD-A30177 mark
                  #  WHEN '7'                           #MOD-A30177 mark
                   CASE                                 #MOD-A30177
                     WHEN new[i].sfb02 MATCHES '[78]'   #MOD-A30177
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_gem"
                        LET g_qryparam.default1 = new[i].ven_no
                        CALL cl_create_qry() RETURNING new[i].ven_no
                   END CASE
                   DISPLAY new[i].ven_no TO s_new[i].ven_no     
                   NEXT FIELD ven_no
                WHEN INFIELD(sfb06) 
                  LET i=ARR_CURR()
                  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=new[i].new_part
                  IF cl_null(l_ima571) THEN LET l_ima571=' ' END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecu_a"
                  LET g_qryparam.default1 = new[i].sfb06
                  LET g_qryparam.arg1 = l_ima571
                  LET g_qryparam.arg1 = new[i].new_part
                  CALL cl_create_qry() RETURNING new[i].sfb06
                  DISPLAY new[i].sfb06 TO sfb06 
                  NEXT FIELD sfb06
               OTHERWISE EXIT CASE 
             END CASE
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         #FUN-C50052---begin
         ON ACTION all
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'Y'
            END FOR
         ON ACTION no_all
            FOR l_i = 1 TO new.getLength()
               LET new[l_i].x = 'N'
            END FOR
         #FUN-C50052---end
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         RETURN
      END IF
   END IF  #TQC-730022 add   
 
      LET l_proc = 'N'
      # 檢查單身
      FOR i = 1 TO new.getLength()
         IF new[i].x = 'Y' AND cl_null(new[i].new_no) THEN
            LET g_flag = 'N'
            CALL cl_err('','asf-380','1')                                                                                           
            EXIT FOR
         END IF
         IF new[i].x = 'Y' THEN
            LET l_proc = 'Y'
         END IF
         IF new[i].x = 'Y' THEN          #MOD-BA0006 add
           SELECT ima561,ima56 INTO l_ima561,l_ima56 FROM ima_file 
            WHERE ima01 = new[i].new_part
           IF l_ima561 > 0 THEN
              IF new[i].new_qty < l_ima561 THEN
                 LET g_flag = 'N'
                 CALL cl_err(l_ima561,'asf-307',1)
                 EXIT FOR
              END IF
           END IF
           IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
              LET l_qty1 = new[i].new_qty * 1000
              LET l_qty2 = l_ima56 * 1000
              IF (l_qty1 MOD l_qty2) > 0 THEN
                 LET g_flag = 'N'
                 CALL cl_err(l_ima56,'asf-308',1)
                 EXIT FOR
              END IF
              #CHI-B80044 -- begin --
              IF l_qty > 0 THEN
                 LET l_calc = 0
                 LET l_allowqty = new[i].new_qty
                 IF l_availqty MOD l_ima56 > 0 THEN
                    LET l_calc = l_availqty/l_ima56 + 1
                    LET l_allowqty = l_calc * l_ima56
                 END IF
                 IF g_sfb.sfb08 > l_allowqty THEN
                    CALL cl_err('','asf-358',1)
                    EXIT FOR
                 END IF
              END IF
              #CHI-B80044 -- end --
           END IF
         END IF            #MOD-BA0006 add
      END FOR 
   
      IF g_flag= 'N' THEN
         CONTINUE WHILE
      END IF
 
      IF l_proc = 'N' THEN
         EXIT WHILE
      END IF
   
      IF g_bgjob = 'N' THEN  #TQC-730022
        IF NOT cl_sure(19,0) THEN
           RETURN
        END IF
      END IF
   
      CALL cl_wait()
    # 陣列列印資料
      CALL s_showmsg_init() #FUN-920088
      DROP TABLE sfb_tmp   #暂存工单毛需求汇总
      CREATE TEMP TABLE sfb_tmp 
      (sfb05    LIKE sfb_file.sfb05,
       sfb08    LIKE sfb_file.sfb08,
       sfb08c   LIKE sfb_file.sfb08,
       img10    LIKE sfb_file.sfb08,
       sfb13    LIKE sfb_file.sfb13,    #预计开工日期
       sfb15    LIKE sfb_file.sfb15,
       sfb08b    LIKE sfb_file.sfb08)    #预计完工日期
      CREATE UNIQUE INDEX sfb_temp_index ON sfb_tmp(sfb05) 
      LET  g_success='Y'
      BEGIN WORK
      DELETE FROM q003_tmp 



      FOR i=1 TO new.getLength()
      #   BEGIN WORK
      #   LET g_success = 'Y'   #No.MOD-960317
         IF cl_null(new[i].new_part) THEN
            EXIT FOR
         END IF
         IF cl_null(new[i].new_no) THEN 
            CONTINUE FOR
         END IF
         IF cl_null(new[i].new_qty) THEN
            CONTINUE FOR
         END IF
         IF new[i].x = 'N' THEN
            CONTINUE FOR
         END IF
         IF new[i].new_qty = 0 THEN
            CONTINUE FOR
         END IF
         #循环将单身的所有下阶M件需求算出得到净需求
    #     LET g_sfb08=new[i].new_qty
         SELECT COUNT(*) INTO l_cnt FROM sfb_tmp WHERE sfb05=new[i].new_part
      IF l_cnt=0 THEN  #第一次进来新增资料 已经存在的资料从sfb08栏位 减去需求
         #插入临时表需求                               #此时值为正表明供>需 无需展BOM
         #供给量
         #库存  抓取MRP可用
         SELECT SUM(img10) INTO l_img10 FROM img_file,imd_file
         WHERE imd01=img02 AND img01=new[i].new_part AND imdacti='Y' AND imd11='Y' AND imd12='Y'
         IF cl_null(l_img10) THEN LET l_img10=0 END IF
         # 在外量
         SELECT   SUM(pmn20-pmn53) INTO l_zaiwai FROM pmm_file,pmn_file,smy_file WHERE pmm01=pmn01
         AND substr(pmm01,1,instr(pmm01,'-')-1)=smyslip  AND pmm25 in ('1','2') AND pmn04=new[i].new_part
         AND smyud03='Y'
         IF cl_null(l_zaiwai) THEN LET l_zaiwai=0 END IF
         # 在请量
         SELECT SUM(pml20-pml21) INTO l_pml20 FROM pml_file,pmk_file,smy_file WHERE pmk01=pml01 AND pmk18='Y' AND
         pml16 in ('1','2') AND pml04=new[i].new_part AND substr(pmk01,1,instr(pmk01,'-')-1)=smyslip AND smyud03='Y'
         IF cl_null(l_pml20) THEN LET l_pml20=0 END IF

         # sfb08  已开立工单的数量
         SELECT SUM(sfb08-sfb09) INTO l_gongdan FROM sfb_file,smy_file WHERE substr(sfb01,1,instr(sfb01,'-')-1)=smyslip
         AND smyud03='Y' AND sfb87='Y' AND sfb04!='8' AND sfb05=new[i].new_part
         IF cl_null(l_gongdan) THEN LET l_gongdan=0 END IF

         # sfb08  项目已开立工单的数量
         SELECT SUM(sfb08) INTO l_xmgongdan FROM sfb_file,smy_file WHERE substr(sfb01,1,instr(sfb01,'-')-1)=smyslip
         AND smyud03='Y' AND sfb87='Y' AND sfb04!='8' AND sfb05=new[i].new_part AND sfb27=tm.tc_cpb01
         IF cl_null(l_xmgongdan) THEN LET l_xmgongdan=0 END IF
         
         # 项目在请量
         SELECT SUM(pml20) INTO l_xmpml20 FROM pml_file,pmk_file,smy_file WHERE pmk01=pml01 AND pmk18='Y' 
         AND pml12=tm.tc_cpb01 AND pml16 in ('1','2') AND pml04=new[i].new_part AND substr(pmk01,1,instr(pmk01,'-')-1)=smyslip AND smyud03='Y'
         IF cl_null(l_xmpml20) THEN LET l_xmpml20=0 END IF
         
         #需求
         #工单下阶备料需求
         SELECT  SUM(sfa05-sfa06+sfa063) INTO l_xiajie  FROM sfa_file,sfb_file,smy_file WHERE sfa01=sfb01 AND
         substr(sfb01,1,instr(sfb01,'-')-1)=smyslip AND smyud03='Y' AND sfb87='Y' AND
         sfa03=new[i].new_part   AND sfb04!='8' AND sfb27!=tm.tc_cpb01
         IF cl_null(l_xiajie) THEN LET l_xiajie=0 END IF
            INSERT INTO sfb_tmp VALUES (new[i].new_part,l_xiajie+new[i].new_qty,l_gongdan,l_img10+l_zaiwai+l_pml20,
                                        new[i].b_date,new[i].e_date,new[i].new_qty-l_xmpml20-l_xmgongdan)
            #将第一次出现的料算出本次的需求
            IF STATUS  THEN
               LET g_success='N' 
               CALL cl_err('ins sfb_tmp err',STATUS,1)
               EXIT FOR
            END IF
            SELECT sfb08-img10 INTO l_sfb08 FROM sfb_tmp WHERE sfb05=new[i].new_part   #暂时的净需求大于0(表明供<需) BOM
            IF l_sfb08>0 THEN
               LET g_sfb08=l_sfb08
               CALL q501_bom(0,new[i].new_part,1,' ','',new[i].b_date)   
            END IF 
         ELSE
            #UPDATE sfb_tmp SET sfb08=sfb08+l_xuqiu  WHERE sfb05=new[i].new_part
            #IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #   CALL cl_err('upd tmp err',STATUS,1)
            #   LET g_success='N'
            #   EXIT FOR
            #END IF
             #加上本次的需求量后 看供给是否满足  不满足则继续展下阶BOM
            #SELECT sfb08 INTO l_sfb08 FROM sfb_tmp WHERE sfb05=new[i].new_part
            #IF l_sfb08>0 THEN
            #   LET g_sfb08=l_sfb08
            #   CALL q501_bom(0,new[i].new_part,1,' ','',new[i].b_date)
            #END IF
         END IF
    END FOR
  
    IF g_success='Y' THEN 
    INITIALIZE l_sfb.* TO NULL
     #工单单别的抓取从料件aimi104上来
     
    # SELECT  SFB08,SFB08C,IMG10,SFB08B INTO l_sfb08,l_gongdan,l_img10,l_xiajie  FROM sfb_tmp,ima_file
    #  WHERE  ima01=sfb05 AND ima08='M'  AND sfb05 ='0B200100141'
     
      DECLARE sel_sfb_tmp_cur  CURSOR FOR
    SELECT  sfb05,CASE WHEN sfb08-img10-sfb08c<sfb08b THEN sfb08-img10-sfb08c ELSE sfb08b END ,sfb13,sfb15  FROM sfb_tmp,ima_file
      WHERE sfb08-img10-sfb08c>0 AND sfb08b>0 AND ima01=sfb05 AND ima08='M'    #只抓取净需求大于零的资料

      FOREACH sel_sfb_tmp_cur INTO l_sfb.sfb05,l_sfb.sfb08,l_sfb.sfb13,l_sfb.sfb15
        SELECT COUNT(*) INTO l_cnt FROM bma_file,bmb_file WHERE bma01=bmb01 AND bma01=l_sfb.sfb05
        AND bma10='2' AND (bmb04 <=g_today OR bmb04 IS NULL) AND (bmb05 > g_today OR bmb05 IS NULL) 
        IF l_cnt =0 THEN CONTINUE FOREACH END IF
        SELECT ima111 INTO l_sfb.sfb01 FROM ima_file WHERE ima01=l_sfb.sfb05
        IF cl_null(l_sfb.sfb01) THEN
           LET l_sfb.sfb01=tm.sfb01
        END IF
        CALL s_auto_assign_no("asf",l_sfb.sfb01,g_today,"","","","","","")                                              
             RETURNING li_result,l_sfb.sfb01                                                                                   
        IF (NOT li_result) THEN                                    
            CALL s_errmsg('smyslip',l_sfb.sfb01,'s_auto_assign_no','asf-963',1)
            LET g_success='N'
        END IF    #有問題
   
         LET l_sfb.sfb02 = '1'
         LET l_sfb.sfb04 = '2'
 #        LET l_sfb.sfb05 = #new[i].new_part
        #先不給"製程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
         SELECT ima35,ima36,ima571,ima59
           INTO l_sfb.sfb30,l_sfb.sfb31,l_item,l_ima59
           FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
   
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('ima01',l_sfb.sfb05,'select ima35','aom-198',1)
            LET g_success = 'N'
         END IF
         IF cl_null(l_item) THEN LET l_item=l_sfb.sfb05 END IF #TQC-AB0136
 
   #      LET l_ima910=new[i].ima910
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
         #FUN-A50066--begin--add-------------------
         LET l_cnt = 0
         IF l_cnt = 0 THEN  #FUN-B20075
            SELECT count(*) INTO l_cnt FROM bma_file  #FUN-A50066
             WHERE bma01=l_sfb.sfb05
               AND bma05 IS NOT NULL
               AND bma05 <=g_today
               AND bma06 = l_ima910   #FUN-550112
               AND bmaacti = 'Y'      #CHI-740001
         END IF  #FUN-A50066
   
         IF l_cnt = 0 THEN   #FUN-A50066
            IF l_sfb.sfb02!='5' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='11' THEN    #MOD-AB0063 add
               CALL s_errmsg('bom',l_sfb.sfb05,'select bom','mfg5071',1)
               LET g_success = 'N'
            END IF                     #MOD-AB0063 add
         END IF
   
         #--(1)產生工單檔(sfb_file)---------------------------
        #Mod FUN-B20060
        LET l_sfb.sfb071= g_today  #l_sfb.sfb81
        #tianry add 161019     # 如果bom没发放或者大于生产日期 下一笔循环
        SELECT bma05 INTO l_bma05 FROM bma_file WHERE bma01=l_sfb.sfb05
        IF  cl_null(l_bma05) OR l_bma05> l_sfb.sfb071 THEN
            CONTINUE  FOREACH 
        END IF

       #tianry add end
       #  LET l_sfb.sfb08 = new[i].new_qty
         LET l_sfb.sfb081= 0
         LET l_sfb.sfb09 = 0
         LET l_sfb.sfb10 = 0
         LET l_sfb.sfb11 = 0
         LET l_sfb.sfb111= 0
         LET l_sfb.sfb121= 0
         LET l_sfb.sfb122= 0 
         LET l_sfb.sfb12 = 0
      #   LET l_sfb.sfb13 = g_today
      #   LET l_sfb.sfb15 = g_today+l_ima59
         LET l_sfb.sfb23 = 'Y' #FUN-650054
         LET l_sfb.sfb24 = 'N'
         LET l_sfb.sfb251= g_today  #g_sfb.sfb81
         LET l_sfb.sfb27 = tm.tc_cpb01
         LET l_sfb.sfb29 = 'Y'
         LET l_sfb.sfb39 = '1'
         LET l_sfb.sfb81 = g_today   #g_sfb.sfb81
         LET l_sfb.sfb85 = ' '    #No.MOD-480184
         LET l_sfb.sfb86 = ' '    #No.MOD-480184
         LET l_sfb.sfb89 = ' '    #FUN-C30114
         LET l_sfb.sfb87 = 'Y'    #抛转出来审核的单据
         LET l_sfb.sfb91 = ' '    #No.MOD-480184
         LET l_sfb.sfb92 = NULL   #MOD-530402
         LET l_sfb.sfb41 = 'N'
         LET l_sfb.sfb44 = g_user #FUN-920088
         LET l_formid = s_get_doc_no(l_sfb.sfb01)
         SELECT smyapr INTO l_sfb.sfbmksg FROM smy_file
          WHERE smyslip=l_formid
         LET l_sfb.sfb43 = '1'    #FUN-920088
         IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
            LET l_sfb.sfb99 = 'Y'
         ELSE
            LET l_sfb.sfb99 = 'N'
         END IF
         LET l_sfb.sfb17 = NULL   #TQC-7A0065
         LET l_sfb.sfb95=l_ima910
         LET l_sfb.sfbacti = 'Y'
         LET l_sfb.sfbuser = g_user
         LET l_sfb.sfbgrup = g_grup
         LET l_sfb.sfbdate = g_today
         LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
 
         LET l_sfb.sfbplant = g_plant #FUN-980008 add
         LET l_sfb.sfblegal = g_legal #FUN-980008 add
   
         LET l_slip = s_get_doc_no(l_sfb.sfb01)     #No.FUN-550067     
         SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
        LET l_sfb.sfb93 = l_smy57[1,1]  #FUN-A50066
        IF l_sfb.sfb93='Y' THEN  #工艺赋值
           SELECT ima94 INTO l_sfb.sfb06 FROM ima_file WHERE ima01=l_sfb.sfb05
        END IF
        LET l_sfb.sfb94 = l_smy57[2,2]
   
         IF cl_null(l_sfb.sfb98) THEN
            SELECT ima34 INTO l_sfb.sfb98 FROM ima_file
             WHERE ima01 = l_sfb.sfb05
         END IF

         LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
         LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04


         #MOD-A90067 add --start--
         IF l_smy57[5,5] = 'Y' THEN
            SELECT oeb908 INTO l_sfb.sfb97 FROM oeb_file
             WHERE oeb01 = l_sfb.sfb22
               AND oeb03 = l_sfb.sfb221
         END IF
         #MOD-A90067 add --end--

         LET l_sfb.sfb104 = 'N'    #TQC-A50087 add
         
         INSERT INTO sfb_file VALUES(l_sfb.*)
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('sfb05',l_sfb.sfb05,'insert sfb','asf-738',1)
            LET g_success='N'   
         END IF
         INSERT INTO q003_tmp VALUES (l_sfb.sfb01,l_sfb.sfb05,l_sfb.sfb08)


         IF NOT s_industry('std') THEN
            INITIALIZE l_sfbi.* TO NULL
            LET l_sfbi.sfbi01 = l_sfb.sfb01
            IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
               LET g_success='N'
        #       LET new[i].new_no = NULL
            END IF
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
               LET g_success='N' 
            END IF
         END IF
   
         #-->(2)產生備料檔
         LET l_minopseq=0
         
               IF l_sfb.sfb02 = 11 THEN
                  LET l_btflg = 'N'
               ELSE
                  LET l_btflg = 'Y'
               END IF
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                           #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                  RETURNING g_cnt
         IF g_cnt = 0 THEN
             CALL s_errmsg('sfb05',l_sfb.sfb05,'s_cralc error','asf-385',1)
             LET g_success = 'N' 
         END IF


         CALL p305_chk_sfb39(l_sfb.sfb01)      
     END FOREACH
   END IF      

      CALL s_showmsg()  

      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
         RETURN           #TQC-DA0029 add
      END IF

      ERROR ""
   
 
#   END WHILE
  
   LET l_i=1
  DECLARE sel_q003_cur  CURSOR FOR
  SELECT *FROM q003_tmp
  FOREACH sel_q003_cur INTO l_sfb01,l_sfb05,l_sfb08
    IF cl_null(l_str1) THEN
       LET l_str1 = l_sfb01 CLIPPED
    ELSE
       LET l_str1 = l_str1,';',l_sfb01 CLIPPED
    END IF
    LET l_show_msg[l_i].sfb01=l_sfb01
    LET l_show_msg[l_i].sfb05=l_sfb05
    LET l_show_msg[l_i].sfb08=l_sfb08
    LET l_i = l_i + 1
  END FOREACH

  LET g_msg = NULL
  LET g_msg2= NULL
  LET l_gaq03_f1 = NULL
  CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
  CALL cl_get_feldname('sfb01',g_lang) RETURNING l_gaq03_f1
  CALL cl_get_feldname('sfb05',g_lang) RETURNING l_gaq03_f2
  CALL cl_get_feldname('sfb08',g_lang) RETURNING l_gaq03_f3
  LET g_msg2 = l_gaq03_f1 CLIPPED,';',l_gaq03_f2 CLIPPED,';',l_gaq03_f3
  CALL cl_show_array(base.TypeInfo.create(l_show_msg),g_msg,g_msg2)
 END WHILE

END FUNCTION
 


                


#CHI-C50029 str add-----
FUNCTION p305_chk_sfb39(l_sfb01)
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_cnt2     LIKE type_file.num5
DEFINE l_sfb01    LIKE sfb_file.sfb01
DEFINE l_sfb01_2  LIKE sfb_file.sfb01

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfa_file
   WHERE sfa01  = l_sfb01
     AND sfa11 != 'E' AND sfa11 !='X'          
  IF l_cnt = 0 THEN
    UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01
  END IF

  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM sfb_file
   WHERE sfb86  = l_sfb01

  IF l_cnt>0 THEN
    DECLARE p305_cur1 CURSOR FOR
       SELECT sfb01 FROM sfb_file WHERE sfb86  = l_sfb01

    FOREACH p305_cur1 INTO l_sfb01_2
       LET l_cnt2=0
       SELECT COUNT(*) INTO l_cnt2 FROM sfa_file
        WHERE sfa01  = l_sfb01_2
          AND sfa11 != 'E' 
       IF l_cnt2 = 0 THEN 
         UPDATE sfb_file SET sfb39='2' WHERE sfb01=l_sfb01_2
       END IF
    END FOREACH
  END IF

END FUNCTION
#CHI-C50029 end add-----

#TQC-C70002--add--str--
FUNCTION p305_sub_no(p_no,p_min_no,p_max_no)
   DEFINE   p_no        LIKE sfb_file.sfb01
   DEFINE   p_min_no    LIKE sfb_file.sfb01      
   DEFINE   p_max_no    LIKE sfb_file.sfb01       
   DEFINE   l_sub_no    LIKE sfb_file.sfb01
   DEFINE   l_min_no    LIKE sfb_file.sfb01
   DEFINE   l_max_no    LIKE sfb_file.sfb01        
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_sql       STRING

   LET l_min_no = p_min_no
   LET l_max_no = p_max_no
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM sfb_file
    WHERE sfb86 = p_no
   IF l_n = 0 THEN RETURN l_min_no,l_max_no END IF 

   LET l_sql = "SELECT sfb01 FROM sfb_file ",
           " WHERE sfb86 = '", p_no ,"' "
   PREPARE q_sfb_prepare FROM l_sql
   DECLARE sfb_curs CURSOR FOR q_sfb_prepare 
   FOREACH sfb_curs INTO l_sub_no
      IF SQLCA.sqlcode THEN
         RETURN l_min_no,l_max_no
      END IF
      #add by aiqq160728------s
      INSERT INTO p305_sfb01_tmp VALUES(l_sub_no)
      #add by aiqq160728------e
      IF cl_null(l_max_no) THEN LET l_max_no = ' ' END IF    
      IF l_sub_no > l_max_no THEN LET l_max_no = l_sub_no END IF
      IF cl_null(l_min_no) THEN LET l_min_no = l_max_no END IF    
      IF l_sub_no < l_min_no THEN LET l_min_no = l_sub_no END IF
      CALL p305_sub_no(l_sub_no,l_min_no,l_max_no) RETURNING l_min_no,l_max_no  #遞歸查詢各級子工單
   END FOREACH
   RETURN l_min_no,l_max_no
END FUNCTION
#TQC-C70002--add--end--

#TQC-C70104--add--str--
FUNCTION p305_set_entry_b()
   CALL cl_set_comp_entry("sfb06",TRUE)
END FUNCTION

FUNCTION p305_set_no_entry_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].sfb93 <> 'Y' THEN
      CALL cl_set_comp_entry("sfb06",FALSE)
   END IF
END FUNCTION

FUNCTION p305_set_no_required_b()
   CALL cl_set_comp_required("sfb06,new_no",FALSE)
   IF g_aaz.aaz90 = 'Y' THEN
      CALL cl_set_comp_required("costcenter",FALSE)
   END IF
END FUNCTION

FUNCTION p305_set_required_b(p_i)
   DEFINE p_i       LIKE type_file.num5
   DEFINE i         LIKE type_file.num5

   LET i = p_i
   IF new[i].x = 'Y' THEN
      IF new[i].sfb93 = 'Y' THEN
         CALL cl_set_comp_required("sfb06",TRUE)
      END IF
      IF g_aaz.aaz90 = 'Y' THEN
         CALL cl_set_comp_required("costcenter",TRUE)
      END IF
      CALL cl_set_comp_required("new_no",TRUE)
   END IF 
END FUNCTION
#TQC-C70104--add--end--

#DEV-D30026 add str-----------
FUNCTION p305_barcode_chk(p_new_part)
   DEFINE p_new_part LIKE ima_file.ima01

   LET l_barcode_yn = 'N'
   SELECT ima930 INTO l_barcode_yn
   FROM ima_file
   WHERE ima01 = p_new_part
END FUNCTION
#DEV-D30026 add end-----------




FUNCTION q501_bom(p_level,p_key,p_total,p_bma06,p_unit,p_date) #FUN-550093  #MOD-D20085
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
         #p_total       LIKE sfa_file.sfa05,    #MOD-550192 modify type  #No.MOD-920094 mark
         #p_total       LIKE sfa_file.sfa15,    #No.MOD-920094   #MOD-A80212 mark
          p_total       LIKE bmb_file.bmb06,    #MOD-A80212 add 
          p_bma06       LIKE bma_file.bma06,    #FUN-550093
          p_unit        LIKE bmb_file.bmb10,    #MOD-D20085
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #BUFFER SIZE (可存筆數) #No.FUN-680096 SMALLINT
          l_chr,l_cnt   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_fac         LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          l_ima55       LIKE ima_file.ima55,   
          l_bmaacti     LIKE bma_file.bmaacti,  #TQC-C50116 add
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              x_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb09 LIKE bmb_file.bmb09,    #作業編號  #CHI-CB0050 add
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01,    #No.MOD-490217
              b_date  LIKE oga_file.oga02,   #工单开立的开始和结束日期
              e_date  LIKE oga_file.oga02
          END RECORD,
          l_sql     LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
   DEFINE  l_ima08    LIKE ima_file.ima08   
   DEFINE l_xuqiu       LIKE sfb_file.sfb08,
          l_img10       LIKE img_file.img10,
          l_zaiwai      LIKE img_file.img10,
          l_gongdan     LIKE sfb_file.sfb08,
          l_xmgongdan   LIKE sfb_file.sfb08,
          l_xiajie      LIKE sfa_file.sfa05
   DEFINE l_pml20       LIKE pml_file.pml20
   DEFINE l_xmpml20     LIKE pml_file.pml20
   DEFINE  l_sfb08      LIKE sfb_file.sfb08
   DEFINE  p_date       DATE
   DEFINE l_time     LIKE type_file.num5,
          l_bmb18    LIKE bmb_file.bmb18
   DEFINE l_ima59    LIKE ima_file.ima59,
          l_ima60    LIKE ima_file.ima60,
          l_ima601   LIKE ima_file.ima601,
          l_ima61    LIKE ima_file.ima61,
          l_bmb06    LIKE bmb_file.bmb06
     DEFINE l_day      LIKE type_file.num5 
     DEFINE li_result    LIKE type_file.num5 

    #TQC-C50116--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file 
     WHERE bma01 = p_key 
       AND bma06 = p_bma06 
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50116--add--end--
	IF p_level > 20 THEN
       	   CALL cl_err('','mfg2733',1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    LET arrno = 600			#95/12/21 Modify By Lynn
    #FUN-550093................begin
#   LET l_sql= "SELECT 0, bmb02, bmb03, (bmb06/bmb07), bmb10, bmb13, bma01",
#              "  FROM bmb_file, OUTER bma_file",
#              " WHERE bmb01='", p_key,"' AND bmb03 = bma_file.bma01",
#              "   AND ",tm.wc2 CLIPPED
 
    LET l_sql= "SELECT 0, bmb02, bmb03, bmb09, (bmb06/bmb07), bmb10, bmb13, bmb01,'','',bmb18,bmb06",  #CHI-CB0050 add bmb09
               "  FROM bmb_file",
               " WHERE bmb01='", p_key,"' AND bmb29='",p_bma06,"'"
           #    "   AND ",tm.wc2 CLIPPED
    #FUN-550093................end
    #---->生效日及失效日的判斷
        LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <=to_date('",g_today,"','yy/mm/dd') OR bmb04 IS NULL)",
                  " AND (bmb05 >to_date('",g_today,"','yy/mm/dd') OR bmb05 IS NULL)"
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb03"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE              LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
    END CASE
    PREPARE q501_precur FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE q501_cur CURSOR FOR q501_precur
    LET l_ac = 1
    FOREACH q501_cur INTO sr[l_ac].*,l_bmb18,l_bmb06   # 先將BOM單身存入BUFFER
        #FUN-8B0015--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0015--END--
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].x_level = p_level
       IF NOT cl_null(p_unit) THEN
           IF p_unit !=sr[i].bmb10 THEN
              CALL s_umfchk(sr[i].bmb03,p_unit,sr[i].bmb10)
                   RETURNING l_cnt,l_fac    #單位換算
              IF l_cnt = '1'  THEN 
                 LET l_fac = 1
              END IF
           END IF
           IF cl_null(l_fac) THEN LET l_fac = 1 END IF      
           LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac
        ELSE 
           LET sr[i].bmb06=p_total*sr[i].bmb06
        END IF   
          #推算开日时期结束日期
       SELECT ima59,ima60,ima601,ima61 INTO l_ima59,l_ima60,l_ima601,l_ima61 FROM ima_file
       WHERE ima01=sr[i].bmb03
        LET l_time = 0
        LET sr[i].e_date = p_date - l_bmb18
        IF l_bmb18 <= 0 THEN 
           SELECT COUNT(*) INTO l_time FROM sme_file
           WHERE sme01 BETWEEN p_date AND sr[i].e_date AND sme02 = 'N'
        ELSE 
           SELECT COUNT(*) INTO l_time FROM sme_file
           WHERE sme01 BETWEEN sr[i].e_date AND p_date AND sme02 = 'N'
        END IF
        LET sr[i].e_date = sr[i].e_date - l_time
        LET l_time = 0
        LET sr[i].b_date = sr[i].e_date
        LET l_day = (l_ima59+l_ima60/l_ima601*l_bmb06+l_ima61) #MOD-9A0065
        WHILE TRUE 
          CALL s_daywk(sr[i].b_date) RETURNING li_result
          CASE 
             WHEN li_result = 0  #0:非工作日 
                  LET sr[i].b_date = sr[i].b_date + 1   #MOD-9A0065 -變+ 
                  CONTINUE WHILE
             WHEN li_result = 1  #1:工作日 
                  EXIT WHILE
             WHEN li_result = 2  #2:無設定 
                  CALL cl_err(sr[i].b_date,'mfg3153',0)   #MOD-9A0065
                  EXIT WHILE
             OTHERWISE EXIT WHILE
         END CASE 
       END WHILE
       CALL s_aday(sr[i].b_date,-1,l_day)    #MOD-9A0065
            RETURNING sr[i].b_date   #MOD-9A0065
       IF sr[i].b_date >sr[i].e_date THEN
          LET sr[i].e_date = sr[i].b_date
       END IF

       #日期推算结束
       
        SELECT ima08 INTO l_ima08 FROM ima_file WHERE ima01=sr[i].bmb03
        SELECT COUNT(*) INTO l_cnt FROM sfb_tmp WHERE sfb05=sr[i].bmb03
        LET l_xuqiu=g_sfb08*sr[i].bmb06
     IF l_cnt=0 THEN   #临时表中没有净需求数据 的时候新增一笔
        IF sr[i].bma01 IS NOT NULL THEN #AND l_ima08='M'  THEN #若為主件
          #供给 库存
           SELECT SUM(img10) INTO l_img10 FROM img_file,imd_file
           WHERE imd01=img02 AND img01=sr[i].bmb03 AND imdacti='Y' AND imd11='Y' AND imd12='Y'
           IF cl_null(l_img10) THEN LET l_img10=0 END IF
        # 在外量
           SELECT   SUM(pmn20-pmn53) INTO l_zaiwai FROM pmm_file,pmn_file,smy_file WHERE pmm01=pmn01
           AND substr(pmm01,1,instr(pmm01,'-')-1)=smyslip  AND pmm25 in ('1','2') AND pmn04=sr[i].bmb03
           AND smyud03='Y'
           IF cl_null(l_zaiwai) THEN LET l_zaiwai=0 END IF
        # sfb08  已开立工单的数量
           SELECT SUM(sfb08-sfb09) INTO l_gongdan FROM sfb_file,smy_file WHERE substr(sfb01,1,instr(sfb01,'-')-1)=smyslip
           AND smyud03='Y' AND sfb87='Y' AND sfb04!='8' AND sfb05=sr[i].bmb03
           IF cl_null(l_gongdan) THEN LET l_gongdan=0 END IF
         # 再请量
           SELECT SUM(pml20-pml21) INTO l_pml20 FROM pml_file,pmk_file,smy_file WHERE pmk01=pml01 AND pmk18='Y' AND
           pml16 in('1','2') AND pml04=sr[i].bmb03 AND substr(pmk01,1,instr(pmk01,'-')-1)=smyslip AND smyud03='Y'
           IF cl_null(l_pml20) THEN LET l_pml20=0 END IF

         # sfb08  项目已开立工单的数量
         SELECT SUM(sfb08) INTO l_xmgongdan FROM sfb_file,smy_file WHERE substr(sfb01,1,instr(sfb01,'-')-1)=smyslip
         AND smyud03='Y' AND sfb87='Y' AND sfb04!='8' AND sfb05=sr[i].bmb03 AND sfb27=tm.tc_cpb01
         IF cl_null(l_xmgongdan) THEN LET l_xmgongdan=0 END IF
         
         # 项目在请量
         SELECT SUM(pml20) INTO l_xmpml20 FROM pml_file,pmk_file,smy_file WHERE pmk01=pml01 AND pmk18='Y' AND pml12=tm.tc_cpb01 AND
         pml16 in ('1','2') AND pml04=sr[i].bmb03 AND substr(pmk01,1,instr(pmk01,'-')-1)=smyslip AND smyud03='Y'
         IF cl_null(l_xmpml20) THEN LET l_xmpml20=0 END IF
         
        #需求
        #工单下阶备料需求
           SELECT  SUM(sfa05-sfa06+sfa063) INTO l_xiajie  FROM sfa_file,sfb_file,smy_file WHERE sfa01=sfb01 AND
           substr(sfb01,1,instr(sfb01,'-')-1)=smyslip AND smyud03='Y' AND sfb87='Y' AND
           sfa03=sr[i].bmb03    AND sfb04!='8' AND sfb27!=tm.tc_cpb01
           IF cl_null(l_xiajie) THEN LET l_xiajie=0 END IF
           
           INSERT INTO sfb_tmp VALUES (sr[i].bmb03,l_xiajie+l_xuqiu,l_gongdan,l_img10+l_zaiwai+l_pml20,
                                       sr[i].b_date,sr[i].e_date,l_xuqiu-l_xmgongdan-l_xmpml20)  #将第一次出现的料算出本次的需求
           IF STATUS  THEN
              LET g_success='N' 
              CALL cl_err('ins sfb_tmp err',STATUS,1)
              EXIT FOR
           END IF
           SELECT sfb08-img10 INTO l_sfb08 FROM sfb_tmp WHERE sfb05=sr[i].bmb03   #暂时的净需求大于0(表明供<需) BOM
           IF l_sfb08>0 THEN
              CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i],sr[i].bmb10,sr[i].b_date)#FUN-8B0015 #MOD-D20085
           END IF
        END IF 
      ELSE
        IF sr[i].bma01 IS NOT NULL THEN #AND l_ima08='M'  THEN #若為主件
           UPDATE sfb_tmp SET sfb08=sfb08+l_xuqiu,sfb08b=sfb08b+l_xuqiu WHERE sfb05=sr[i].bmb03
           IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err('upd tmp err',STATUS,1)
              LET g_success='N'
              EXIT FOR
           END IF
           #加上本次的需求量后 看供给是否满足  不满足则继续展下阶BOM
           SELECT sfb08-img10 INTO l_sfb08 FROM sfb_tmp WHERE sfb05=sr[i].bmb03
           IF l_sfb08>0 THEN
              CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i],sr[i].bmb10,sr[i].b_date)
           END IF

        END IF
      END IF

    END FOR
END FUNCTION
