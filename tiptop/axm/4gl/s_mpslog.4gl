# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE  
# Modify.........: No.FUN-710046 07/01/17 By Carrier 錯誤訊息匯整
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 DEFINE g_order   LIKE oea_file.oea01,
        g_seq     LIKE oeb_file.oeb03,
       g_mpg09       LIKE mpg_file.mpg09
 
FUNCTION s_mpslog(p_cmd,p_newpn,p_newqty,p_newdate,
                        p_oldpn,p_oldqty,p_olddate,
                        p_order,p_oldseq,p_newseq)
   DEFINE p_cmd         LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_newpn       LIKE oeb_file.oeb04,
          p_newqty      LIKE oeb_file.oeb12,
          p_newdate     LIKE oeb_file.oeb15,
          p_oldpn       LIKE oeb_file.oeb04,
          p_oldqty      LIKE oeb_file.oeb12,
          p_olddate     LIKE oeb_file.oeb15,
          p_order       LIKE oeb_file.oeb01,
          p_oldseq      LIKE oeb_file.oeb03,
          p_newseq      LIKE oeb_file.oeb03,
          mpg           RECORD LIKE mpg_file.*,
          l_ima139      LIKE ima_file.ima139  
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
 
   WHENEVER ERROR CONTINUE
   LET g_order = p_order
   LET g_seq   = p_newseq  
   LET g_mpg09 = p_cmd 
 
   #FUN-550112
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_newpn
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   #-->新增狀況
   IF p_cmd = 'A' THEN 
      LET mpg.mpg01 = p_newpn     #MPS 料號 
      SELECT ima139 INTO l_ima139 FROM ima_file WHERE ima01 = mpg.mpg01
      IF SQLCA.sqlcode THEN LET l_ima139 ='' END IF
      IF l_ima139 = 'Y' THEN 
         LET mpg.mpg02 = g_order     #訂單單號
         LET mpg.mpg03 = g_seq       #項次   
         LET mpg.mpg04 = p_newdate   #需求日期
         LET mpg.mpg05 = p_newqty    #需求數量
         LET mpg.mpg06 = 1           #狀況   
         LET mpg.mpg07 = p_newpn     #來源料號 
         LET mpg.mpg08 = g_today     #異動日期 
         LET mpg.mpg09 = g_mpg09     #異動狀況 
 
         #FUN-980010 add plant & legal 
         LET mpg.mpgplant = g_plant 
         LET mpg.mpglegal = g_legal 
         #FUN-980010 end plant & legal 
 
         INSERT INTO mpg_file VALUES(mpg.*) 
      END IF
      CALL s_mpsbom(0,p_newpn,l_ima910,p_newqty,p_newdate,1)  #FUN-550112
   END IF
 
   #-->修改狀況
   IF p_cmd = 'U' THEN 
      DELETE FROM mpg_file WHERE mpg02 = g_order AND mpg03 = p_oldseq
 
      LET mpg.mpg01 = p_newpn     #MPS 料號 
      SELECT ima139 INTO l_ima139 FROM ima_file WHERE ima01 = mpg.mpg01
      IF SQLCA.sqlcode THEN LET l_ima139 ='' END IF
      IF l_ima139 = 'Y' THEN 
         LET mpg.mpg02 = g_order     #訂單單號
         LET mpg.mpg03 = g_seq       #項次   
         LET mpg.mpg04 = p_newdate   #需求日期
         LET mpg.mpg05 = p_newqty    #需求數量
         LET mpg.mpg06 = 1           #狀況   
         LET mpg.mpg07 = p_newpn     #來源料號 
         LET mpg.mpg08 = g_today     #異動日期 
         LET mpg.mpg09 = g_mpg09     #異動狀況 
 
         #FUN-980010 add plant & legal 
         LET mpg.mpgplant = g_plant 
         LET mpg.mpglegal = g_legal 
         #FUN-980010 end plant & legal 
 
         INSERT INTO mpg_file VALUES(mpg.*) 
        #No.+042 010330 by plum
        #IF STATUS THEN CALL cl_err('ins mpg',STATUS,1) EXIT PROGRAM END IF
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins mpg',SQLCA.SQLCODE,1)
            #No.FUN-710046  --Begin
            IF g_bgerr THEN
               LET g_showmsg=mpg.mpg02,"/",mpg.mpg03
               CALL s_errmsg("mpg02,mpg03",g_showmsg,"ins mpg",SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            ELSE
               CALL cl_err3("ins","mpg_file",mpg.mpg02,mpg.mpg03,SQLCA.SQLCODE,"","ins mpg",1)    #No.FUN-660167
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
            #No.FUN-710046  --End  
         END IF
        #No.+042 ..end
      END IF
      CALL s_mpsbom(0,p_newpn,l_ima910,p_newqty,p_newdate,1)  #FUN-550112
   END IF
 
   #-->刪除狀況
   IF p_cmd = 'R' THEN 
      DELETE FROM mpg_file WHERE mpg02 = g_order AND mpg03 = p_oldseq
   END IF
 
   #-->結案狀況
   IF p_cmd = 'C' THEN 
      LET mpg.mpg01 = p_newpn     #MPS 料號 
      SELECT ima139 INTO l_ima139 FROM ima_file WHERE ima01 = mpg.mpg01
      IF SQLCA.sqlcode THEN LET l_ima139 ='' END IF
      IF l_ima139 = 'Y' THEN 
         LET mpg.mpg02 = g_order     #訂單單號
         LET mpg.mpg03 = g_seq       #項次   
         LET mpg.mpg04 = p_newdate   #需求日期
         LET mpg.mpg05 = p_newqty    #需求數量
         LET mpg.mpg06 = -1          #狀況   
         LET mpg.mpg07 = p_newpn     #來源料號 
         LET mpg.mpg08 = g_today     #異動日期 
         LET mpg.mpg09 = g_mpg09     #異動狀況 
 
         #FUN-980010 add plant & legal 
         LET mpg.mpgplant = g_plant 
         LET mpg.mpglegal = g_legal 
         #FUN-980010 end plant & legal 
 
         INSERT INTO mpg_file VALUES(mpg.*) 
        #No.+042 010330 by plum
        #IF STATUS THEN CALL cl_err('ins mpg',STATUS,1) EXIT PROGRAM END IF
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins mpg',SQLCA.SQLCODE,1)
            #No.FUN-710046  --Begin
            IF g_bgerr THEN
               LET g_showmsg=mpg.mpg02,"/",mpg.mpg03
               CALL s_errmsg("mpg02,mpg03",g_showmsg,"ins mpg",SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            ELSE
               CALL cl_err3("ins","mpg_file",mpg.mpg02,mpg.mpg03,SQLCA.SQLCODE,"","ins mpg",1)    #No.FUN-660167
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
            #No.FUN-710046  --End  
         END IF
        #No.+042 ..end
      END IF
      CALL s_mpsbom(0,p_newpn,l_ima910,p_newqty,p_newdate,-1)  #FUN-550112
   END IF
 
   #-->結案還原狀況
   IF p_cmd = 'Z' THEN 
      DECLARE mpg_rev_c1 CURSOR FOR
            SELECT * FROM mpg_file 
           WHERE mpg02 = g_order AND mpg03 = g_seq AND mpg06 = -1
      FOREACH mpg_rev_c1 INTO mpg.*  
        IF SQLCA.sqlcode THEN
           #No.FUN-710046  --Begin
           IF g_bgerr THEN
              LET g_showmsg=g_order,"/",g_seq,"/","-1"
              CALL s_errmsg("mpg02,mpg03,mpg06",g_showmsg,"mpg_rev_c1",SQLCA.sqlcode,0)
           ELSE
              CALL cl_err('mpg_rev_c1',SQLCA.sqlcode,0)   #No.FUN-660167
           END IF
           #No.FUN-710046  --End  
           EXIT FOREACH 
        END IF
        LET mpg.mpg06 = 1
        LET mpg.mpg08 = g_today     #異動日期 
        LET mpg.mpg09 = g_mpg09     #異動狀況 
 
        #FUN-980010 add plant & legal 
        LET mpg.mpgplant = g_plant 
        LET mpg.mpglegal = g_legal 
        #FUN-980010 end plant & legal 
 
        INSERT INTO mpg_file VALUES(mpg.*) 
       #No.+042 010330 by plum
       #IF STATUS THEN CALL cl_err('ins mpg',STATUS,1) EXIT PROGRAM END IF
        IF STATUS OR SQLCA.SQLCODE THEN
#          CALL cl_err('ins mpg',SQLCA.SQLCODE,1)
           #No.FUN-710046  --Begin
           IF g_bgerr THEN
              LET g_showmsg=mpg.mpg02,"/",mpg.mpg03
              CALL s_errmsg("mpg02,mpg03",g_showmsg,"ins mpg",SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
           ELSE
              CALL cl_err3("ins","mpg_file",mpg.mpg02,mpg.mpg03,SQLCA.sqlcode,"","ins mpg",1)   #No.FUN-660167
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
              EXIT PROGRAM 
           END IF
           #No.FUN-710046  --End  
        END IF
       #No.+042 ..end
      END FOREACH
   END IF
END FUNCTION
   
FUNCTION s_mpsbom(p_level,p_pn,p_key2,p_qty,p_date,p_type)  #FUN-550112
   DEFINE p_level     LIKE type_file.num5,        # No.FUN-680137   SMALLINT
          p_pn        LIKE oeb_file.oeb04,   #料件編號
          p_key2	LIKE ima_file.ima910,   #FUN-550112
          p_qty       LIKE type_file.num20_6,     # No.FUN-680137  DEC(18,6)
          p_date      LIKE type_file.dat,         # No.FUN-680137   DATE    
          p_type       LIKE type_file.num5,        # No.FUN-680137  SMALLINT
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          arrno       LIKE type_file.num5,        # No.FUN-680137  SMALLINT     #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb03     LIKE bmb_file.bmb03,       #元件料號
              bmb06     LIKE bmb_file.bmb06,       #FUN-560230
              bmb18     LIKE bmb_file.bmb18,       #投料時距
              bmb10_fac LIKE bmb_file.bmb10_fac,   
              bma01     LIKE bma_file.bma01
          END RECORD,
          mpg         RECORD LIKE mpg_file.*,
          l_ima08     LIKE ima_file.ima08,
          l_ima59     LIKE ima_file.ima59,
          l_ima60     LIKE ima_file.ima60,
          l_ima601    LIKE ima_file.ima601,   #No.FUN-840194
          l_ima61     LIKE ima_file.ima61,
          l_ima50     LIKE ima_file.ima50,
          l_ima48     LIKE ima_file.ima48,
          l_ima49     LIKE ima_file.ima49,
          l_ima491    LIKE ima_file.ima491,
         #l_ima56     LIKE ima_file.ima56,        #CHI-810015 mark #FUN-710073 add
          l_leadtime  LIKE ima_file.ima50,
          l_ima133    LIKE ima_file.ima133,
          l_ima139    LIKE ima_file.ima139,
          l_needate   LIKE type_file.dat,         # No.FUN-680137  DATE
          l_sql       LIKE type_file.chr1000       #No.FUN-680137   VARCHAR(400)
 
    #No.FUN-710046  --Begin
    IF p_level > 20 THEN 
       IF g_bgerr THEN
          CALL s_errmsg("level",20,"","mfg2733",1)
          LET g_success = 'N'
          RETURN
       ELSE
          CALL cl_err('','mfg2733',1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
          EXIT PROGRAM 
       END IF
    END IF
    #No.FUN-710046  --End   
    LET p_level = p_level + 1 
    LET arrno = 600
 
    DECLARE mps_bom_c1 CURSOR FOR
          SELECT bmb03,(bmb06/bmb07),bmb18,bmb10_fac,bma01
            FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01 
           WHERE bmb01=p_pn  
             AND bmb29 =p_key2  #FUN-550112
             AND bmb04<=p_date AND (bmb05 IS NULL OR bmb05>p_date) 
 
    LET l_ac = 1
    FOREACH mps_bom_c1 INTO sr[l_ac].*
       IF SQLCA.sqlcode THEN 
          #No.FUN-710046  --Begin
          IF g_bgerr THEN
             LET g_showmsg=p_pn,"/",p_key2
             CALL s_errmsg("bmb01,bmb29",g_showmsg,"fore mps_bom_c1:",SQLCA.sqlcode,0)
             EXIT FOREACH
          ELSE
             CALL cl_err('fore mps_bom_c1:',STATUS,1) EXIT FOREACH    #No.FUN-660167
          END IF
          #No.FUN-710046  --End
       END IF
       LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    #No.FUN-710046  --Begin
    IF STATUS THEN 
       IF g_bgerr THEN
          CALL s_errmsg("","","fore p500_cur:",STATUS,0)
       ELSE
          CALL cl_err('fore p500_cur:',STATUS,1) 
       END IF
    END IF
    #No.FUN-710046  --End
 
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
       message p_level,' ',sr[i].bmb03 clipped
        SELECT ima133,ima139 INTO l_ima133,l_ima139 FROM ima_file 
          WHERE ima01 = sr[i].bmb03
        IF l_ima139 ='Y' THEN 
           #SELECT ima08,ima59,ima60,ima61,ima50,ima48,ima49,ima491       #No.FUN-840194   #CHI-810015拿掉,ima56    #FUN-710073 add ima56
           SELECT ima08,ima59,ima60,ima601,ima61,ima50,ima48,ima49,ima491 #No.FUN-840194   #CHI-810015拿掉,ima56    #FUN-710073 add ima56
             #INTO l_ima08,l_ima59,l_ima60,l_ima61,         #No.FUN-840194
             INTO l_ima08,l_ima59,l_ima60,l_ima601,l_ima61, #No.FUN-840194
                  l_ima50,l_ima48,l_ima49,l_ima491                         #CHI-810015拿掉,l_ima56  #FUN-710073 add l_ima56
             FROM ima_file WHERE ima01 = sr[i].bmb03
           IF cl_null(l_ima59)  THEN LET l_ima59 = 0 END IF
           IF cl_null(l_ima60)  THEN LET l_ima60 = 0 END IF
           IF cl_null(l_ima61)  THEN LET l_ima61 = 0 END IF
           IF cl_null(l_ima50)  THEN LET l_ima50 = 0 END IF
           IF cl_null(l_ima48)  THEN LET l_ima48 = 0 END IF
           IF cl_null(l_ima49)  THEN LET l_ima49 = 0 END IF
           IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
          #IF cl_null(l_ima56)  THEN LET l_ima56 = 0 END IF    #CHI-810015 mark #FUN-710073 add
            
           IF l_ima08='M' THEN
             #FUN-710073---mod---str---
             #LET l_leadtime=l_ima59+l_ima60*sr[i].bmb06+l_ima61  #No.FUN-840194 #CHI-810015 mark還原     
              LET l_leadtime=l_ima59+l_ima60/l_ima601*sr[i].bmb06+l_ima61  #No.FUN-840194 #CHI-810015 mark還原     
             #LET l_leadtime=(l_ima59/l_ima56)+                   #CHI-810015 mark
             #               (l_ima60/l_ima56)*sr[i].bmb06+       #CHI-810015 mark
             #               (l_ima61/l_ima56)                    #CHI-810015 mark              
             #FUN-710073---mod---end---
           ELSE 
              LET l_leadtime=l_ima50+l_ima48+l_ima49+l_ima491
           END IF
           LET l_needate =p_date  -l_ima50	# 減採購/製造前置日數
           LET mpg.mpg01 = sr[i].bmb03 #MPS 料號 
           LET mpg.mpg02 = g_order     #訂單單號
           LET mpg.mpg03 = g_seq       #項次   
           LET mpg.mpg04 = l_needate   #需求日期
           LET mpg.mpg05 = sr[i].bmb06 #需求數量
           LET mpg.mpg06 = p_type      #狀況   
           LET mpg.mpg07 = p_pn        #來源料號 
           LET mpg.mpg08 = g_today     #異動日期 
           LET mpg.mpg09 = g_mpg09     #異動狀況 
 
           #FUN-980010 add plant & legal 
           LET mpg.mpgplant = g_plant 
           LET mpg.mpglegal = g_legal 
           #FUN-980010 end plant & legal 
 
           INSERT INTO mpg_file VALUES(mpg.*) 
          #No.+042 010330 by plum
          #IF STATUS THEN CALL cl_err('ins mpg',STATUS,1) EXIT PROGRAM END IF
           IF STATUS OR SQLCA.SQLCODE THEN
#             CALL cl_err('ins mpg',SQLCA.SQLCODE,1)
              #No.FUN-710046  --Begin
              IF g_bgerr THEN
                 LET g_showmsg=mpg.mpg02,"/",mpg.mpg03
                 CALL s_errmsg("mpg02,mpg03",g_showmsg,"ins mpg",SQLCA.sqlcode,1)
                 LET g_success = 'N'
                 RETURN
              ELSE
                 CALL cl_err3("ins","mpg_file",mpg.mpg02,mpg.mpg03,SQLCA.sqlcode,"","ins mpg",1)   #No.FUN-660167
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
                 EXIT PROGRAM
              END IF
              #No.FUN-710046  --End  
           END IF
          #No.+042 ..end
        END IF
        IF sr[i].bma01 IS NOT NULL THEN #若為主件
           CALL s_mpsbom(p_level,sr[i].bmb03,' ',sr[i].bmb06,p_date,p_type)  #FUN-550112
        END IF
    END FOR
END FUNCTION
