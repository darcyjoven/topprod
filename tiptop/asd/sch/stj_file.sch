/*
================================================================================
檔案代號:stj_file
檔案名稱:在制工单成本调整档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table stj_file
(
stj01       number(5) NOT NULL,      /*年度                                   */
stj02       number(5) NOT NULL,      /*月份                                   */
stj03       varchar2(20) NOT NULL,   /*工单号码                               */
                                     /*工單號碼                               */
stj04       number(20,6),            /*材料调整金额                           */
                                     /*材料調整金額                           */
stj05       number(20,6),            /*人工调整金额                           */
                                     /*人工調整金額                           */
stj06       number(20,6),            /*制费一调整金额                         */
                                     /*製費一調整金額                         */
stj07       number(20,6),            /*制费二调整金额                         */
                                     /*製費二調整金額                         */
stj08       number(20,6),            /*加工费调整金额                         */
                                     /*加工費調整金額                         */
stjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table stj_file add  constraint stj_pk primary key  (stj01,stj02,stj03) enable validate;
grant select on stj_file to tiptopgp;
grant update on stj_file to tiptopgp;
grant delete on stj_file to tiptopgp;
grant insert on stj_file to tiptopgp;
grant index on stj_file to public;
grant select on stj_file to ods;
