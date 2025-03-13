# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apjp120.4gl
# Descriptions...: WBS本階計劃材料需求維護 BOM 展開
# Date & Author..: 08/04/21 By shiwuying
# Modify.........: No.MOD-840322 08/04/21 By shiwuying apjt120增加依BOM表整批產生功能
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-8C0040 09/02/01 by jan 語法修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_pjfa1      RECORD LIKE pjfa_file.*,  
    g_pjfa01     LIKE pjfa_file.pjfa01,   
    tm  RECORD	
          part   LIKE ima_file.ima01,
          ima910 LIKE ima_file.ima910,
          qty    LIKE sfb_file.sfb08,
          idate  LIKE type_file.dat,
          a      LIKE type_file.chr1
        END RECORD,
    g_cnt        LIKE type_file.num5,
    g_factor     LIKE img_file.img21,
    g_ima906     LIKE ima_file.ima906,
    g_ima907     LIKE ima_file.ima907,
 
    g_ccc        LIKE type_file.num5,
    g_argv1      LIKE type_file.chr1
 
FUNCTION p120(p_argv1)
 
   DEFINE l_time  LIKE type_file.chr8,
          #l_sql   LIKE type_file.chr1000,
          l_sql    STRING,         #NO.FUN-910082
          p_argv1 LIKE pjfa_file.pjfa01 
 
   WHENEVER ERROR CONTINUE
   IF p_argv1 IS NULL OR p_argv1 = ' ' THEN 
      CALL cl_err(p_argv1,'mfg3527',0) 
      RETURN
   END IF
   LET g_ccc=0
   LET g_pjfa01  = p_argv1
 
   LET tm.qty=0
   LET tm.idate=g_today
   LET tm.a='N'
 
   WHILE TRUE 
    #-->條件畫面輸入
      OPEN WINDOW p120_w AT 6,30 WITH FORM "apm/42f/apmp480" 
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("apmp480")
      CALL cl_set_comp_visible("qty",FALSE)
      CALL cl_set_comp_visible("ima910",g_sma.sma118='Y')
 
      INPUT BY NAME tm.* WITHOUT DEFAULTS
      
         AFTER FIELD part
            IF NOT chk_part() THEN NEXT FIELD part END IF
            
         AFTER FIELD ima910
            IF cl_null(tm.ima910) THEN 
               LET tm.ima910 = ' ' 
            ELSE
               SELECT COUNT(*) INTO g_cnt FROM bma_file
                WHERE bma01=tm.part AND bma06=tm.ima910
               IF g_cnt = 0 THEN
                  CALL cl_err('','abm-618',0)
                  NEXT FIELD ima910
               END IF
            END IF
 
         AFTER FIELD qty
            IF cl_null(tm.qty) OR tm.qty<=0 THEN NEXT FIELD qty END IF
            
         AFTER FIELD idate
            IF cl_null(tm.idate) OR tm.idate < g_today 
             THEN NEXT FIELD idate END IF
       
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN 
               NEXT FIELD a 
            END IF
       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(part)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bma"
                  LET g_qryparam.default1 = tm.part
                  CALL cl_create_qry() RETURNING tm.part
                  DISPLAY tm.part TO FORMONLY.part
                  NEXT FIELD part
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg 
            CALL cl_cmdask()
 
         BEFORE INPUT
            CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
          
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p120_w RETURN END IF
      CALL p120_init()
      CALL p120_bom()
      CLOSE WINDOW p120_w
      EXIT WHILE
   END WHILE          
END FUNCTION
 
 
FUNCTION p120_init()
   
   LET g_pjfa1.pjfa02 = 0
   LET g_pjfa1.pjfa05 = 0                                           
   LET g_pjfa1.pjfa06 = g_today 
   LET g_pjfa1.pjfaacti='Y'
END FUNCTION
 
FUNCTION chk_part()
   DEFINE  l_ima08    LIKE ima_file.ima08,
           l_imaacti  LIKE ima_file.imaacti,
           l_cnt      LIKE type_file.num5,
           l_err      LIKE type_file.num5 
 
   LET l_err=1
     #檢查該料件是否存在           
   SELECT ima08,imaacti INTO l_ima08,l_imaacti FROM ima_file
    WHERE ima01=tm.part
   CASE 
      WHEN l_ima08 NOT MATCHES '[MS]'
         CALL cl_err(tm.part,'apm-025',2)
         LET l_err=0
      WHEN l_imaacti = 'N'
         CALL cl_err(tm.part,'mfg0301',2)
         LET l_err=0
      WHEN SQLCA.SQLCODE = 100
         CALL cl_err(tm.part,'mfg0002',2)
         LET l_err=0
      WHEN SQLCA.SQLCODE != 0
         CALL cl_err(tm.part,sqlca.sqlcode,2)
         LET l_err=0
   END CASE    
   IF l_err THEN
   #檢查該料件是否有產品結構
      SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=tm.part
      IF SQLCA.SQLCODE THEN 
         CALL cl_err(tm.part,sqlca.sqlcode,2)
         LET l_err=0
      END IF
      IF l_cnt=0 OR cl_null(l_cnt) THEN
          CALL cl_err(tm.part,'mfg2602',2)
          LET l_err=0
      END IF
   END IF
   RETURN l_err
END FUNCTION
 
 
 FUNCTION p120_bom()
   DEFINE l_ima562     LIKE ima_file.ima562,
          l_ima910     LIKE ima_file.ima910,
          l_ima55      LIKE ima_file.ima55, 
          l_ima86      LIKE ima_file.ima86, 
          l_ima86_fac  LIKE ima_file.ima86_fac
 
   SELECT ima562,ima55,ima86,ima86_fac,ima910 INTO 
          l_ima562,l_ima55,l_ima86,l_ima86_fac,l_ima910 
     FROM ima_file
    WHERE ima01=tm.part AND imaacti='Y'
   IF SQLCA.sqlcode THEN RETURN END IF
   IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   IF tm.ima910 != ' ' THEN
      LET l_ima910 = tm.ima910
   END IF
 
   CALL p120_bom2(0,tm.part,l_ima910,tm.qty,1)
      IF g_ccc=0 THEN
         LET g_errno='asf-014'
      END IF
    
   MESSAGE ""
   RETURN      
END FUNCTION
 
FUNCTION p120_bom2(p_level,p_key,p_key2,p_total,p_QPA)
 
   DEFINE p_level      LIKE type_file.num5
   DEFINE p_total      LIKE sfb_file.sfb08
#   DEFINE p_QPA        LIKE ima_file.ima26  #FUN-A20044
   DEFINE p_QPA        LIKE type_file.num15_3  #FUN-A20044
   DEFINE p_key        LIKE bma_file.bma01
   DEFINE p_key2       LIKE bma_file.bma06
   DEFINE l_ac,l_i,l_x LIKE type_file.num5
   DEFINE arrno        LIKE type_file.num5
   DEFINE b_seq        LIKE type_file.num10
   DEFINE sr DYNAMIC ARRAY OF RECORD      #array for storage
       bmb02 LIKE bmb_file.bmb02,         #項次
       bmb03 LIKE bmb_file.bmb03,         #料號                     
       bmb16 LIKE bmb_file.bmb16,         #取替代碼
       bmb06 LIKE bmb_file.bmb06,         #QPA
       bmb10 LIKE bmb_file.bmb10,         #發料單位
       bmb10_fac LIKE bmb_file.bmb10_fac, #換算率
       ima08 LIKE ima_file.ima08,         #來源碼
       ima02 LIKE ima_file.ima02,         #品名規格
       bma01 LIKE bma_file.bma01          #項次
   END RECORD
   DEFINE l_ima08     LIKE ima_file.ima08
   DEFINE l_chr       LIKE type_file.chr1
   DEFINE l_ActualQPA LIKE bmb_file.bmb06
   DEFINE l_cnt,l_c   LIKE type_file.num5
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
   LET p_level = p_level + 1
   LET arrno = 500
   LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb10,bmb10_fac,",
             "        ima08,ima02,bma01 ",
            #"   FROM bmb_file,ima_file, bma_file ",            #CHI-8C0040
             "   FROM bmb_file,OUTER ima_file, OUTER bma_file ",#CHI-8C0040
             "  WHERE bmb01='",p_key,"' AND bmb02 > ?",
             "    AND bmb29='",p_key2,"'",
            #"    AND bmb_file.bmb03 = bma_file.bma01", #CHI-8C0040
            #"    AND bmb_file.bmb29 = bma_file.bma06", #CHI-8C0040
            #"    AND bmb_file.bmb03 = ima_file.ima01", #CHI-8C0040
             "    AND bmb03 = bma_file.bma01",             #CHI-8C0040
             "    AND bmb29 = bma_file.bma06",             #CHI-8C0040
             "    AND bmb03 = ima_file.ima01",             #CHI-8C0040
             "    AND (bmb04 <='",tm.idate,"' OR bmb04 IS NULL) ", 
             "    AND (bmb05 >'",tm.idate,"' OR bmb05 IS NULL)", 
             " ORDER BY bmb03"
   PREPARE bom_p FROM l_cmd
   DECLARE bom_cs CURSOR FOR bom_p
   IF SQLCA.sqlcode THEN
      CALL cl_err('P1:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   LET b_seq=0
   WHILE TRUE
      LET l_ac = 1
      FOREACH bom_cs USING b_seq INTO sr[l_ac].*
         MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
         #若換算率有問題, 則設為1
         IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
            LET sr[l_ac].bmb10_fac=1
         END IF
         IF cl_null(sr[l_ac].bmb16) THEN    #若未定義, 則給予'正常'
            LET sr[l_ac].bmb16='0'
         ELSE
            IF sr[l_ac].bmb16='2' THEN LET sr[l_ac].bmb16='1' END IF
         END IF
         #FUN-8B0035--BEGIN-- 
         LET l_ima910[l_ac]=''
         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
         #FUN-8B0035--END-- 
         LET l_ac = l_ac + 1    #check limitation
         IF l_ac > arrno THEN EXIT FOREACH END IF
      END FOREACH
      LET l_x=l_ac-1
 
      #insert into allocation file
      FOR l_i = 1 TO l_x
          IF sr[l_i].ima08='X' THEN
             IF sr[l_i].bma01 IS NOT NULL THEN 
               #CALL p120_bom2(p_level,sr[l_i].bmb03,' ',  #FUN-8B0035
                CALL p120_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], #FUN-8B0035
                               p_total*sr[l_i].bmb06,l_ActualQPA)
             END IF
          END IF
 
          IF sr[l_i].ima08='M' OR 
             sr[l_i].ima08='S' THEN 
             IF tm.a='Y' THEN
                IF sr[l_i].bma01 IS NOT NULL THEN 
                  #CALL p120_bom2(p_level,sr[l_i].bmb03,' ',          #FUN-8B0035
                   CALL p120_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],#FUN-8B0035 
                          p_total*sr[l_i].bmb06,l_ActualQPA)
                ELSE
                   CONTINUE FOR
                END IF
             ELSE
                CONTINUE FOR
             END IF
          END IF
          IF NOT(sr[l_i].ima08='X' OR sr[l_i].ima08='M' OR
                 sr[l_i].ima08='S') THEN  
             LET g_ccc=g_ccc+1
             LET g_pjfa1.pjfa03=sr[l_i].bmb03
             LET g_pjfa1.pjfa04=sr[l_i].ima02
               
             SELECT COUNT(*) INTO l_cnt FROM pjfa_file
              WHERE pjfa01=g_pjfa01 AND pjfa03=g_pjfa1.pjfa03
             IF l_cnt > 0 THEN
 
             ELSE
                LET g_pjfa1.pjfa02=g_pjfa1.pjfa02+1
                LET g_pjfa1.pjfa01=g_pjfa01
                LET g_pjfa1.pjfaoriu = g_user      #No.FUN-980030 10/01/04
                LET g_pjfa1.pjfaorig = g_grup      #No.FUN-980030 10/01/04
                INSERT INTO pjfa_file VALUES(g_pjfa1.*)
                IF SQLCA.SQLCODE THEN 
                   ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                END IF
             END IF
          END IF
       END FOR
       IF l_x < arrno OR l_ac=1 THEN #nothing left
          EXIT WHILE
       ELSE
          LET b_seq = sr[l_x].bmb02
       END IF
    END WHILE
    IF p_level >1 THEN
       RETURN
    END IF
END FUNCTION
#No.MOD-840322
