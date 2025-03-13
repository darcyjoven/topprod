# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Program name...: s_taskdat.4gl
# Descriptions...: 計算每一站之相關資料
#                  1.該站之開工日    2.完工日
#                  3.最早開工日期    4.最早完工日期  
#                  5.最遲開工日期    6.最遲完工日期  
#                  7.固定工時        8.變動工時
# Date & Author..: 92/08/12 By Purple
# Usage..........: CALL s_taskdat(p_opt,p_strtdat,p_duedat,p_bomdat,p_wono,
#                                 p_primary,p_wotype,p_part,p_woq)
# Input Parameter: p_opt      Options
#                     0   normal use
#                     1   do not generate tracking file
#                  p_strtdat  Start Date of W/O
#                  p_duedat   Due Date of W/O
#                  p_bomdat   BOM Effective Date
#                  p_wono     W/O Number
#                  p_primary  Routing Primary Code
#                  p_wotype   W/O Type
#                  p_part     Part no.
#                  p_woq      W/O Qty
# Return Code....: l_status
#                     0  ok
#                     1  no use routing 
#                     2  no record find
# Memo...........: 可使用之資料
#                  1.g_takdate[100]
#                  2.g_count  該製程有幾站
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-760066 07/06/25 By kim 配合MSV版的調整
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.MOD-960159 09/06/12 By Carrier 改寫INSERT寫法
# Modify.........: No.FUN-A60027 10/06/22 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/25 By vealxu 平行制程
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y' 
# Modify.........: No.CHI-B80096 11/09/02 By fengrui 對組成用量(ecm62)/底數(63)的預設值處理,計算標準產出量(ecm65)的值

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 DEFINE 
    g_op ARRAY[100] OF RECORD
        qtytbc      LIKE ecm_file.ecm301, #Qty to be complete
        offset1     LIKE type_file.num20_6, #offset1(=FLT+ULT)       #No.FUN-680147 DECIMAL(16,6)
        offset2     LIKE type_file.num20_6, #offset2(=ULT)           #No.FUN-680147 DECIMAL(16,6)
        ecm01   LIKE ecm_file.ecm01, #FUN-760066
        ecm03   LIKE ecm_file.ecm03, #FUN-760066
        ecm012  LIKE ecm_file.ecm012 #FUN-A60076
        END RECORD,
        g_wono      LIKE sfb_file.sfb01,  #W/O NO.  
        g_wotype    LIKE sfb_file.sfb02,  #W/O TYPE
        g_part      LIKE sfb_file.sfb05,  #part no.
        g_primary   LIKE ecb_file.ecb02,  #routing no.
        g_woq       LIKE sfb_file.sfb08,  #W/O qty. 
        g_opt       LIKE type_file.num5,  #No.FUN-680147 SMALLINT
        g_lots LIKE ima_file.ima56  #production lot size
 
DEFINE   g_cnt           LIKE type_file.num10     	#No.FUN-680147 INTEGER
DEFINE   g_count         LIKE type_file.num5   	#No.FUN-680147 SMALLINT
FUNCTION s_taskdat(p_opt,p_strtdat,p_duedat,p_bomdat,p_wono,p_primary,
                   p_wotype,p_part,p_woq)
  DEFINE
 
       p_opt        LIKE type_file.num5,   #No.FUN-680147 SMALLINT
       p_strtdat    LIKE type_file.dat,    #Start Date 	#No.FUN-680147 DATE
       p_duedat     LIKE type_file.dat,    #Due Date 	#No.FUN-680147 DATE
       p_bomdat     LIKE type_file.dat,    #BOM Effective Date 	#No.FUN-680147 DATE
       p_wono       LIKE sfb_file.sfb01,   #W/O
       p_part       LIKE sfb_file.sfb05,   #work order part number
       p_wotype     LIKE sfb_file.sfb02, #work order type
       p_woq        LIKE sfb_file.sfb08,    #Qty of W/O
       p_primary    LIKE ecb_file.ecb02,#Primary Code
       l_sfb93      LIKE sfb_file.sfb93,               #No.FUN-680147 VARCHAR(01)
       i            LIKE type_file.num5                #key point 	#No.FUN-680147 SMALLINT
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_wono=p_wono
    LET g_wotype=p_wotype
    LET g_part=p_part
    LET g_primary=p_primary
    LET g_woq=p_woq
    LET g_opt=p_opt
 
#--->First check start date & due date   & array initilize to null
#    start date & due date must have value
 
     IF  p_strtdat IS NULL THEN LET p_strtdat=g_today END IF
     IF  p_duedat  IS NULL THEN LET p_duedat=g_lastdat END IF
 
     SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_wono
     IF l_sfb93 MATCHES '[nN]'   #不使用製程系統
        THEN  RETURN 1
     END IF
#---->為了程式寫法方便, 因此不管是否產生製程追蹤資料與否,
#     若無製程追蹤資料, 一律由一般製程資料產生至製程追蹤
#     檔來, 以後推算日期一律由製程追蹤資料來推算,不分開
#     二段來寫.
#----->當然, 前題一定有使用製程資料囉 !!!!
 
     SELECT COUNT(*) INTO g_cnt FROM ecm_file
                               WHERE ecm01=g_wono
 
        IF g_cnt=0  OR g_cnt IS NULL  THEN    #record not exist
            CALL s_put1(p_bomdat)  #insert to routing tracking file , 
                                  # and use this file 
                RETURNING g_cnt   #add new record to tracing file
#MOD-580068 IF NOT g_cnt THEN     #no record find, routing select error
#MOD-580068       RETURN 2         
#MOD-580068 END IF
        END IF
#initilize to null for array
         CALL g_takdate.clear() 
#weighted window ----> start date and due date is know
        CALL s_trksch1(p_strtdat,p_duedat)
             RETURNING g_cnt
        RETURN  g_cnt     
END FUNCTION
 
#tracking Scheduling & weighted window
FUNCTION s_trksch1(p_strtdat,p_duedat)
DEFINE
    p_strtdat     LIKE type_file.dat,    #start date 	#No.FUN-680147 DATE
    p_duedat      LIKE type_file.dat,    #due date 	#No.FUN-680147 DATE
    l_need1       LIKE type_file.num20_6,#total 固定+變動 	#No.FUN-680147 decimal(16,6)
    l_need2       LIKE type_file.num20_6,#total 變動     	#No.FUN-680147 decimal(16,6)
    l_b1          LIKE type_file.num20_6,	#No.FUN-680147 decimal(16,6)
    l_b2          LIKE type_file.num20_6,	#No.FUN-680147 decimal(16,6)
    l_e1          LIKE type_file.num20_6,	#No.FUN-680147 decimal(16,6)
    l_e2          LIKE type_file.num20_6,	#No.FUN-680147 decimal(16,6)
    tot_srtdt     LIKE type_file.num20_6,       # start date 	#No.FUN-680147 DECIMAL(20,6)
    tot_ss        LIKE type_file.num10,  	#No.FUN-680147 INTEGER
    tot_esrtdt    LIKE type_file.num10  ,             #earlest start date 	#No.FUN-680147 INTEGER
    tot_lsrtdt    LIKE type_file.num10  ,             #lastest start date 	#No.FUN-680147 INTEGER
    tot_eduedt    LIKE type_file.num10  ,            #earlest due date 	#No.FUN-680147 INTEGER
    tot_lduedt    LIKE type_file.num10  ,             #lastest due date 	#No.FUN-680147 INTEGER
    s_srtdt       LIKE type_file.num10,                # start date 	#No.FUN-680147 INTEGER
    l_day         LIKE type_file.dat,    	#No.FUN-680147 DATE
    s_date        LIKE type_file.dat,    	#No.FUN-680147 DATE
    g_sm,g_xx     LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
    l_i           LIKE type_file.num5,   #index 	#No.FUN-680147 SMALLINT
    l_date        LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_flt         LIKE ima_file.ima59, #routing's fixed lead time(FLT)
    l_ult         LIKE ima_file.ima60,  #routing's unit lead time(ULT)
    l_weighted    LIKE type_file.num5,   #weighted flag 	#No.FUN-680147 SMALLINT
    l_cnt         LIKE type_file.num5,   #total number counted 	#No.FUN-680147 SMALLINT
    l_alot        LIKE type_file.num20_6,      #part's lead time 	#No.FUN-680147 DECIMAL(16,6)
    l_alot2       LIKE type_file.num20_6      #part's lead time 	#No.FUN-680147 DECIMAL(16,6)
 
    CALL s_total1() RETURNING l_cnt,l_need1,l_need2
 
    LET l_cnt=l_cnt-1
    LET g_count=l_cnt
 
 #--->開工日與完工日之間有幾天工作日
        IF cl_null(l_need1) OR l_need1=0 THEN  #Modify by Jackson
           LET l_need1=1 END IF
        CALL s_ofday(p_strtdat,p_duedat) RETURNING l_alot
        LET l_alot2=l_alot*(l_need2/l_need1)   #變動時間佔多少工作日
 
{
  #----->test---將資料填入array
    FOR l_i=1 TO 3
        prompt l_i,' FLT+UNT ' FOR  g_sm
        prompt l_i,' UNT ' FOR g_xx
        LET g_op[l_i].offset1=g_sm
        LET g_op[l_i].offset2=g_xx
    END FOR
}
    CALL s_filldate()
#--->最早/最遲開工日, 開工日期等-----> 由後往前推
    LET l_e1=0
    LET l_e2=0
    LET tot_srtdt=0
    FOR l_i=1 TO l_cnt    #--->DESC
		IF l_need1=0 THEN LET l_need1=1 END IF
		IF l_need2=0 THEN LET l_need2=1 END IF
        LET l_e1=l_e1+(g_op[l_i].offset1*(l_alot/l_need1)) #最早開工前置時間
        LET l_e2=l_e2+(g_op[l_i].offset2*(l_alot2/l_need2))#最遲開工前置時間
        IF l_e1 IS NULL THEN LET l_e1=0 END IF
        IF l_e2 IS NULL THEN LET l_e2=0 END IF
        UPDATE ecm_file                   #ecm07:最早開工offset
            SET ecm07=l_e1,ecm08=l_e2     #ecm08:最遲開工offset
            WHERE ecm01=g_op[l_i].ecm01 AND ecm03=g_op[l_i].ecm03   #No.TQC-950134
              AND ecm012 = g_op[l_i].ecm012                         #No.FUN-A60076
 
#---->最早開工日
        LET tot_esrtdt=l_e1*-1
        IF tot_esrtdt IS NULL THEN LET tot_esrtdt=0 END IF
        CALL s_getdate(p_duedat,tot_esrtdt) RETURNING l_day
        LET g_takdate[l_i].esrtdt=l_day
{@@@@@@@@test}
        IF l_i=l_cnt THEN LET g_takdate[l_cnt].esrtdt=p_strtdat END IF
#----->最遲開工日
        LET tot_lsrtdt=l_e2*-1
        IF tot_lsrtdt IS NULL THEN LET tot_lsrtdt=0 END IF
        CALL s_getdate(p_duedat,tot_lsrtdt) RETURNING l_day
        LET g_takdate[l_i].lsrtdt=l_day
       END FOR
 
#--->最早/最遲完工日由前往後推
    LET l_b1=0
    LET l_b2=0
    LET tot_srtdt=0
    FOR l_i=l_cnt TO 1  STEP -1  #--->ASC   
		IF l_need1=0 THEN LET l_need1=1 END IF
		IF l_need2=0 THEN LET l_need2=1 END IF
        LET l_b1=l_b1+(g_op[l_i].offset1*(l_alot/l_need1)) #最遲完工前置時間
        LET l_b2=l_b2+(g_op[l_i].offset2*(l_alot2/l_need2))#最早完工前置時間
        UPDATE ecm_file                   #ecm09:最早開工offset
            SET ecm09=l_b2,ecm10=l_b1     #ecm10:最遲開工offset
            WHERE ecm01=g_op[l_i].ecm01 AND ecm03=g_op[l_i].ecm03   #No.TQC-950134
              AND ecm012 = g_op[l_i].ecm012                         #No.FUN-A60076 
        IF l_i=l_cnt THEN
           LET g_takdate[l_cnt].srtdt =p_strtdat   #開工日期
          ELSE  LET g_takdate[l_i].srtdt=s_date #該站開工日等於上站完工日
         END IF
 
#---->完工日
        LET tot_srtdt=tot_srtdt+(g_op[l_i].offset1*(l_alot/l_need1))
        IF tot_srtdt IS NULL THEN LET tot_srtdt=0 END IF
        LET tot_ss=tot_srtdt
        CALL s_getdate(p_strtdat,tot_ss) RETURNING l_day
        LET g_takdate[l_i].duedt=l_day
        LET s_date=g_takdate[l_i].duedt      #前一站完工日為下站開工日
{@@@@@@@@@@test}
        IF l_i=1 THEN LET g_takdate[1].duedt= p_duedat END IF
 
#----->最早完工日
        LET tot_eduedt=l_b2
        IF tot_eduedt IS NULL THEN LET tot_eduedt=0 END IF
        CALL s_getdate(p_strtdat,tot_eduedt) RETURNING l_day
        LET g_takdate[l_i].eduedt=l_day
#----->最遲完工日
        LET tot_lduedt=l_b1
        IF tot_lduedt IS NULL THEN LET tot_lduedt =0 END IF
        CALL s_getdate(p_strtdat,tot_lduedt) RETURNING   l_day
        LET g_takdate[l_i].lduedt=l_day
{@@@@@@@@@@test}
        IF l_i=1 THEN LET g_takdate[1].lduedt= p_duedat END IF
    END FOR
    IF g_opt=1 THEN
        DELETE FROM ecm_file
            WHERE ecm01=g_wono
                  AND ecm11=g_primary
    END IF
#   RETURN 0          #MOD-580068
    RETURN   l_cnt     #MOD-580068
 
END FUNCTION
 
#accumulated total need time
FUNCTION s_total1()
DEFINE
    l_ecm RECORD LIKE ecm_file.*, #tracking detail file
    l_need1 LIKE ima_file.ima58,       #total offset1     #No.FUN-680147 decimal(12,2)
    l_need2 LIKE ima_file.ima58,       #total offset1     #No.FUN-680147 decimal(12,2)
    l_wc LIKE ecb_file.ecb08, #work center
    l_deduct LIKE ecm_file.ecm301, #accumulated scraped & rework qty
    l_eca04 LIKE eca_file.eca04, #work center type code
    l_eca06 LIKE eca_file.eca06, #intensity flag
    l_eca08 LIKE eca_file.eca08, #capacity hour per day
    l_eca09 LIKE eca_file.eca09, #work center queue time
    l_flt LIKE ima_file.ima59, #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,  #routing's unit lead time(ULT)
    l_run LIKE ecm_file.ecm39, #runtime
    l_qty LIKE ecm_file.ecm301,
    l_lots LIKE type_file.num5,   #production lot size 	#No.FUN-680147 SMALLINT
    l_double LIKE ecm_file.ecm40
 
    DECLARE c_trk CURSOR FOR
        SELECT ecm_file.* FROM ecm_file
            WHERE ecm01=g_wono #W/O
                AND ecm11=g_primary #primary code
          # ORDER BY ecm03 DESC                     #FUN-A60076
            ORDER BY ecm012,ecm03 DESC              #FUN-A60076 
    LET g_cnt=1
    #accumulate total need time
    LET l_need1=0
    LET l_need2=0
    LET l_deduct=0
    LET l_wc='*'
    SELECT ima56
        INTO g_lots
        FROM ima_file
        WHERE ima01=g_part AND imaacti='Y' 
    IF SQLCA.sqlcode THEN #selection error
        LET g_lots=1
    END IF
    IF g_lots IS NULL OR g_lots=0 THEN LET g_lots=1 END IF
    FOREACH c_trk INTO l_ecm.*   #No.TQC-950134
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        #FUN-760066.............begin
        LET g_op[g_cnt].ecm01=l_ecm.ecm01
        LET g_op[g_cnt].ecm03=l_ecm.ecm03
        LET g_op[g_cnt].ecm012=l_ecm.ecm012    #FUN-A60076 
        #FUN-760066.............end
        IF l_wc != l_ecm.ecm06 THEN #w/c changed, get queue time
            SELECT eca04,eca06,eca08,eca09
                INTO l_eca04,l_eca06,l_eca08,l_eca09
                FROM eca_file
                WHERE eca01=l_ecm.ecm06 AND ecaacti='Y'
            IF SQLCA.sqlcode THEN
                 LET l_eca04='0' LET l_eca06='1'
                 LET l_eca08=8   LET l_eca09=0
            ELSE
                IF l_eca04 IS NULL THEN LET l_eca04='0' END IF
                IF l_eca06 IS NULL THEN LET l_eca06='1' END IF
                IF l_eca08 IS NULL THEN LET l_eca08=8 END IF
                IF l_eca09 IS NULL THEN LET l_eca09=0 END IF
            END IF
            LET l_wc=l_ecm.ecm06
        ELSe
            LET l_eca09=0
        END IF
        #這裡的數量為工單之生產數量
            LET g_op[g_cnt].qtytbc=g_woq
        #compute offset and need time
        IF l_eca06='1' THEN #labor burdened w/c
            LET l_double=l_ecm.ecm41
        ELSE #machine burdened w/c
            LET l_double=l_ecm.ecm40
        END IF
 
        IF l_eca04='0' THEN #regular w/c
            LET l_lots=(g_op[g_cnt].qtytbc/g_lots)+0.999
            LET l_flt=(l_ecm.ecm37*((100-l_ecm.ecm42)/100)+
                      l_ecm.ecm18*l_lots+l_eca09)/(60*l_eca08)
        ELSE #other
            LET l_flt=0
        END IF
 
        IF l_eca04='0' THEN #regular
            LET l_run=l_ecm.ecm38  #人工生產時間
        ELSE #other
            LET l_run=l_ecm.ecm39  #廠外加工時間
        END IF
 
        IF l_ecm.ecm43='1' THEN #hr/unit
            LET l_ult=((l_run*g_op[g_cnt].qtytbc)/(l_eca08*60))
        ELSE #unit/hr
           IF l_run = 0 THEN
              LET l_ult = NULL
           ELSE
              LET l_ult=((g_op[g_cnt].qtytbc)/(l_eca08*60*l_run))
           END IF
        END IF
 
        IF l_flt IS NULL THEN LET l_flt=0 END IF
        IF l_ult IS NULL THEN LET l_ult=0 END IF
        LET g_op[g_cnt].offset1=l_flt+l_ult   #固定+變動
        LET g_op[g_cnt].offset2=l_ult         #變動
        LET l_need1=l_need1+g_op[g_cnt].offset1      #total 固定+變動
        LET l_need2=l_need2+g_op[g_cnt].offset2             #total 變動
#--->將相關資料存入陣列
        LET g_takdate[g_cnt].ecb03=l_ecm.ecm03 #operation seq.
        LET g_takdate[g_cnt].ecb06=l_ecm.ecm04 #operation no.
        LET g_takdate[g_cnt].ecb08=l_ecm.ecm06 #work center
        LET g_takdate[g_cnt].ecb012=l_ecm.ecm012  #process session no FUN-A60027
        LET g_takdate[g_cnt].flt=l_flt
        LET g_takdate[g_cnt].ult=l_ult
 
        LET g_cnt=g_cnt+1
        IF g_cnt>100 THEN EXIT FOREACH END IF
    END FOREACH
    RETURN g_cnt,l_need1,l_need2
END FUNCTION
 
#Add new record of tracking file
FUNCTION s_put1(p_bomdat)
DEFINE
    p_bomdat LIKE type_file.dat,    	#No.FUN-680147 DATE
    l_ecm012     LIKE ecm_file.ecm012,  #No.CHI-B80096--add--
    l_sfb08      LIKE sfb_file.sfb08,   #No.CHI-B80096--add--
    l_ecb RECORD LIKE ecb_file.*        #routing detail file
 
    DECLARE c_put CURSOR FOR
        SELECT * FROM ecb_file
            WHERE ecb01=g_part #part
                AND ecb02=g_primary #routing
                AND ecbacti='Y'
    LET g_cnt=0
    FOREACH c_put INTO l_ecb.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        IF cl_null(l_ecb.ecb66) THEN LET l_ecb.ecb66 = 'Y' END IF #TQC-B80022
        IF cl_null(l_ecb.ecb46) OR l_ecb.ecb46 = 0 THEN LET l_ecb.ecb46 = 1 END IF #CHI-B80096--add--
        IF cl_null(l_ecb.ecb51) OR l_ecb.ecb51 = 0 THEN LET l_ecb.ecb51 = 1 END IF #CHI-B80096--add--

        #No.MOD-960159  --Begin
        INSERT INTO ecm_file(
               ecm01, ecm02, ecm03_par, ecm03, ecm04, ecm05,
               ecm06, ecm07, ecm08, ecm09, ecm10, ecm11,
               ecm12, ecm121, ecm13, ecm14, ecm15, ecm16,
               ecm17, ecm18, ecm19, ecm20, ecm21, ecm22,
               ecm23, ecm24, ecm25, ecm26, ecm27, ecm28,
               ecm291, ecm292, ecm301, ecm302, ecm303, ecm311,
               ecm312, ecm313, ecm314, ecm315, ecm316, ecm321,
               ecm322, ecm34, ecm35, ecm36, ecm37, ecm38,
               ecm39, ecm40, ecm41, ecm42, ecm43, ecm45,
               ecm49, ecm50, ecm51, ecm52, ecm53, ecm54,
               ecm55, ecm56, ecm57, ecm58, ecm59, ecmacti,
               ecmuser, ecmgrup, ecmmodu, ecmdate, ecm61,
               ecmslk01, ecmslk02, ecmslk03, ecmslk04,ecmplant,ecmlegal,
               ecm62,ecm63,                     #CHI-B80096--add--ecm62,ecm63,ecm65--
               ecm012, ecm65, ecm66)            #FUN-A60027 add ecm012  #FUN-A80102
        #No.MOD-960159  --End  
            VALUES(g_wono,g_wotype,g_part,l_ecb.ecb03,
                   l_ecb.ecb06,l_ecb.ecb07,l_ecb.ecb08,          0,0,
                             0,          0,g_primary  ,l_ecb.ecb14,l_ecb.ecb09,
                   l_ecb.ecb18,l_ecb.ecb19,l_ecb.ecb20,l_ecb.ecb21,
                   l_ecb.ecb22,l_ecb.ecb10,          0,          0,
                             0,          0,          0,          0,'','',
                             0,          0,          0,          0,
                             0,          0,          0,          0,0,
                             0,          0,          0,          0,
                             0,0,0,0,0,
                   l_ecb.ecb26,l_ecb.ecb27,l_ecb.ecb28,l_ecb.ecb15,
                   l_ecb.ecb16,l_ecb.ecb11,l_ecb.ecb13,
                   l_ecb.ecb17,l_ecb.ecb38,'','',l_ecb.ecb39,
                   l_ecb.ecb40,l_ecb.ecb41,l_ecb.ecb42,l_ecb.ecb43,
                   l_ecb.ecb44,l_ecb.ecb45,l_ecb.ecb46,
                   'Y',g_user,g_grup,'',TODAY,'N',
                   l_ecb.ecbslk01,l_ecb.ecbslk02,l_ecb.ecbslk04,l_ecb.ecbslk05,
                   g_plant,'',
                   l_ecb.ecb46,l_ecb.ecb51,                 #CHI-B80096--add--
                   l_ecb.ecb012,0,l_ecb.ecb66)              #FUN-A60027 add l_ecb.ecb012  #FUN-A80102
        LET g_cnt=g_cnt+1
    END FOREACH
    #CHI-B80096--add--Begin--
    LET l_ecm012= ' '
    LET l_sfb08 = ' '
    SELECT DISTINCT sfb08 INTO l_sfb08
      FROM sfb_file WHERE sfb01 = g_wono
    DECLARE schdat1_ecm012_cs CURSOR FOR
       SELECT DISTINCT ecm012 FROM ecm_file
        WHERE ecm01= g_wono
          AND (ecm015 IS NULL OR ecm015=' ')
    FOREACH schdat1_ecm012_cs INTO l_ecm012
       EXIT FOREACH
    END FOREACH
    CALL s_schdat_output(l_ecm012,l_sfb08,g_wono)
    #CHI-B80096--add---End---
    RETURN g_cnt
END FUNCTION
