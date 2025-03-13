# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ceci130.4gl
# Descriptions...: 
# Date & Author..: 16/11/07 BY tianry
# Modify.........: 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

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
 
         g_sgm DYNAMIC ARRAY OF RECORD
                sel             LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
                shm01_t       LIKE shm_file.shm01,
                shm012_t      LIKE shm_file.shm012,
                shm05_t       LIKE shm_file.shm05,
                ima02         LIKE ima_file.ima02,
                ima021        LIKE ima_file.ima021,   #No.FUN-940103
                sgm04         LIKE sgm_file.sgm04,
                sgm45         LIKE sgm_file.sgm45,
                sgm06         LIKE sgm_file.sgm06,
                eca02         LIKE eca_file.eca02,
                wip           LIKE sfb_file.sfb08,
                shm09         LIKE shm_file.shm09,
                sgm03         LIKE sgm_file.sgm03,
                tc_shb12_1         LIKE tc_shb_file.tc_shb12, #上一站扫入数量
                tc_shb12_2         LIKE tc_shb_file.tc_shb12,
                tc_shb121          LIKE tc_shb_file.tc_shb121      
                END RECORD,
         tm         RECORD
                shm01_t       LIKE shm_file.shm01,
                shm012_t      LIKE shm_file.shm012,
                shm05_t       LIKE shm_file.shm05,
                wc            STRING
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

   LET g_chk = 'N'   
   LET g_cnt_1 = 0  
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-A70028 add
   IF g_bgjob = 'N' THEN
      CALL i130_tm()
   ELSE
      CALL i130_fill_b_data()
      LET g_success='Y'
      CALL asfi130()
      
      IF g_success='Y' THEN
         MESSAGE "Success!"
      END IF
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No:MOD-A70028 add
END MAIN
 
FUNCTION i130_tm()
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
 
     OPEN WINDOW i130_w AT p_row,p_col
        WITH FORM "cec/42f/ceci130"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()    
 
 
   CALL cl_opmsg('z')
 
   WHILE TRUE  #MOD-490189
 
   MESSAGE ''
   CLEAR FORM 
   INITIALIZE g_oea.* TO NULL
   INITIALIZE tm.*    TO NULL
 
      CONSTRUCT BY NAME tm.wc ON shm05,shm012,shm01

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(shm01)
             CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_shm1"
                     LET g_qryparam.construct= "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO shm01
          WHEN INFIELD(shm012)
            CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.arg1     = "12345"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shm012   #MOD-4A0252
                     NEXT FIELD shm012
           WHEN INFIELD(shm05) 
               CALL q_sel_ima(TRUE, "q_ima18","","","","","","","",'')  RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
         OTHERWISE
            EXIT CASE
       END CASE
       ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
      END CONSTRUCT

      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
      
      #將塞單身這段整個搬出成一個FUNCTION
      CALL i130_fill_b_data()
            
      LET g_success='Y'
      LET g_flag='Y'
      CALL asfi130()
         CALL cl_confirm('lib-005') RETURNING l_flag
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      ERROR ""
   END WHILE
 
   CLOSE WINDOW i130_w
 
END FUNCTION
 
FUNCTION i130_fill_b_data()
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
   DEFINE   l_ta_ecd04       LIKE ecd_file.ta_ecd04
   DEFINE   l_tc_shc121      LIKE tc_shb_file.tc_shb121
     
      LET g_i=1 
      CALL g_sgm.clear()
      LET g_sql = "SELECT 'N',shm01,shm012,shm05,ima02,ima021,sgm04,sgm45,sgm06,eca02,0 wip,shm09,sgm03,0,0  ",
                  " FROM shm_file ",
                  " LEFT JOIN ima_file ON ima01=shm05 ",
                  " LEFT JOIN sgm_file ON sgm01=shm01 ",
                  " LEFT JOIN eca_file ON sgm06=eca01 ",
                  " WHERE ",tm.wc,
                  " ORDER BY shm01,sgm03 "	
         PREPARE q_oeb_prepare1 FROM g_sql
         DECLARE oeb_curs1 CURSOR FOR q_oeb_prepare1
         LET g_i=1
         FOREACH oeb_curs1 INTO g_sgm[g_i].*
           SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01=g_sgm[g_i].sgm04
       #    IF l_ta_ecd04 ='Y' THEN    #有扫入扫出
              SELECT tc_shb12 INTO g_sgm[g_i].tc_shb12_1 FROM tc_shb_file WHERE tc_shb03=g_sgm[g_i].shm01_t
              AND tc_shb06=g_sgm[g_i].sgm03 AND tc_shb08=g_sgm[g_i].sgm04 AND tc_shb01='1'   #本站开工量 
              IF cl_null(g_sgm[g_i].tc_shb12_1) THEN LET g_sgm[g_i].tc_shb12_1=0 END IF 
 
              SELECT tc_shb12,tc_shb121 INTO g_sgm[g_i].tc_shb12_2,g_sgm[g_i].tc_shb121 FROM tc_shb_file 
              WHERE tc_shb03=g_sgm[g_i].shm01_t
              AND tc_shb06=g_sgm[g_i].sgm03 AND tc_shb08=g_sgm[g_i].sgm04 AND tc_shb01='2'   #本站开工量
              IF cl_null(g_sgm[g_i].tc_shb12_2) THEN LET g_sgm[g_i].tc_shb12_2=0 END IF 
           IF l_ta_ecd04 ='Y' THEN    #有扫入扫出
              SELECT tc_shc12 INTO g_sgm[g_i].tc_shb12_1 FROM tc_shc_file WHERE tc_shc03=g_sgm[g_i].shm01_t
              AND tc_shc06=g_sgm[g_i].sgm03 AND tc_shc08=g_sgm[g_i].sgm04 AND tc_shc01='1'   #本站扫入量
              IF cl_null(g_sgm[g_i].tc_shb12_1) THEN LET g_sgm[g_i].tc_shb12_1=0 END IF
 
              SELECT tc_shc12 INTO g_sgm[g_i].tc_shb12_2,l_tc_shc121 FROM tc_shc_file WHERE tc_shc03=g_sgm[g_i].shm01_t
              AND tc_shc06=g_sgm[g_i].sgm03 AND tc_shc08=g_sgm[g_i].sgm04 AND tc_shc01='2'   #本站扫出量
              IF cl_null(g_sgm[g_i].tc_shb12_2) THEN LET g_sgm[g_i].tc_shb12_2=0 END IF
              IF cl_null(l_tc_shc121) THEN LET l_tc_shc121=0 END IF
           END IF           



           IF g_i=1 THEN
           
           ELSE 
              IF g_sgm[g_i].shm01_t!=g_sgm[g_i-1].shm01_t THEN  #表明是新的RUN CARD 单的第一个工艺开始 
                 CONTINUE FOREACH
              END IF 
              #wip量计算  相同RUN CARD 单下的
              SELECT ta_ecd04 INTO l_ta_ecd04 FROM ecd_file WHERE ecd01=g_sgm[g_i].sgm04
              IF g_sgm[g_i].tc_shb12_1>0 THEN   #针对于上一个g_i-1 来说下一站有扫入  下一站有扫入的时候在制=扫入-扫出-下站扫入-报废
                 LET g_sgm[g_i-1].wip=g_sgm[g_i-1].tc_shb12_1-g_sgm[g_i].tc_shb12_1-g_sgm[g_i-1].tc_shb121
              ELSE    #=0 的情况
                 LET g_sgm[g_i-1].wip=g_sgm[g_i-1].tc_shb12_1  #下一站没有扫入的话 在制为本站的扫入量
              END IF
                         
           END IF  
           #tianry add 161201
         #  IF g_sgm[g_i].wip=0 THEN
         #     IF g_i=1 THEN LET g_i=g_i+1 END IF 
         #     CONTINUE FOREACH 
            
         #  END IF
           #tianry add 
           LET g_i=g_i+1
         END FOREACH
         #DISPLAY g_i TO cn2
         CALL s_showmsg()    #FUN-920088
         CALL g_sgm.deleteElement(g_i)  #MOD-490189
         LET g_i=g_i-1
         DISPLAY g_i TO cn2
END FUNCTION


 
FUNCTION asfi130()
   DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(40)
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_tc_sfb      RECORD LIKE tc_sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03 
   DEFINE g_sgm_part      LIKE ima_file.ima01    #No.MOD-490217
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
   DEFINE l_g_sgm_no1     STRING                  #MOD-AC0288
   DEFINE l_g_sgm_no      LIKE smy_file.smyslip   #MOD-AC0288
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
  DEFINE 
        
       
          l_xuqiu       LIKE sfb_file.sfb08,
          l_img10       LIKE img_file.img10,
          l_zaiwai      LIKE img_file.img10,
          l_gongdan     LIKE sfb_file.sfb08,
          l_xmgongdan   LIKE sfb_file.sfb08,
          l_xiajie      LIKE sfa_file.sfa05,
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
      INPUT ARRAY g_sgm WITHOUT DEFAULTS FROM s_sgm.*
         ATTRIBUTE(COUNT=g_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE, APPEND ROW=FALSE)
 
         BEFORE INPUT                                            #TQC-C50223 add

         BEFORE ROW       
            LET i=ARR_CURR()
               
            
         BEFORE INSERT
   

         AFTER FIELD  sel
            IF cl_null(g_sgm[i].sel) THEN NEXT FIELD sel END IF

   
 
         AFTER ROW 
           #TQC-C70104--add--str--
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_success = 'N'
              RETURN
           END IF
           LET i = ARR_CURR() 
   
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         #FUN-C50052---begin
         ON ACTION all
            FOR l_i = 1 TO g_sgm.getLength()
               LET g_sgm[l_i].sel = 'Y'
            END FOR
         ON ACTION no_all
            FOR l_i = 1 TO g_sgm.getLength()
               LET g_sgm[l_i].sel = 'N'
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
      FOR i = 1 TO g_sgm.getLength()
         IF g_sgm[i].sel = 'Y' THEN
            LET l_proc = 'Y'
         END IF
         IF cl_null(g_sgm[i].shm01_t) THEN
            CALL cl_err(i,'cec-091',1)
            LET l_proc='N' 
            EXIT FOR 
         END IF  
      END FOR 
   
      IF g_flag= 'N' THEN
         CONTINUE WHILE
      END IF
 
      IF l_proc = 'N' THEN
         EXIT WHILE
      END IF
   
      IF g_bgjob = 'N' THEN  #TQC-730022
         IF NOT cl_confirm('cec-090') THEN
            RETURN
         END IF
      END IF
   
      CALL cl_wait()
      CALL s_showmsg_init() #FUN-920088

      LET  g_success='Y'
      BEGIN WORK

      FOR i=1 TO g_sgm.getLength()
          IF g_sgm[i].sel='N' THEN CONTINUE FOR END IF
          UPDATE shm_file SET ta_shm02='Y' WHERE shm01=g_sgm[i].shm01_t
          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err(g_sgm[i].shm01_t,STATUS,1)
             CONTINUE FOR
          END IF
      END FOR
  
      CALL s_showmsg()  

      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
         RETURN           #TQC-DA0029 add
      END IF

      ERROR ""
   
 END WHILE

END FUNCTION
 


                


