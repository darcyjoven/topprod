/*
================================================================================
檔案代號:bgw_file
檔案名稱:预计折旧档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgw_file
(
bgw01       varchar2(10) NOT NULL,   /*版本                                   */
bgw02       varchar2(10) NOT NULL,   /*当类型为1时为资产类型                  */
                                     /*當類別為1時為資產類別                  */
                                     /*當類別為2時為財產編號                  */
bgw03       varchar2(30) NOT NULL,   /*当类型为1时为设备名称                  */
                                     /*當類別為1時為設備名稱                  */
                                     /*當類別為2時為附號                      */
bgw04       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別 1.預計資本支出 2.固定資產         */
bgw05       number(5) NOT NULL,      /*年度                                   */
bgw06       number(5) NOT NULL,      /*月份                                   */
bgw07       varchar2(10) NOT NULL,   /*分摊方式                               */
                                     /*分攤方式=1,3為部門編號                 */
                                     /*分攤方式=2  為分攤類別                 */
bgw08       varchar2(1) NOT NULL,    /*分摊方式                               */
                                     /*分攤方式 1.單一 2.多部門 3.被分攤      */
bgw09       number(20,6),            /*折旧金额                               */
                                     /*折舊金額                               */
bgw10       number(20,6),            /*被分摊金额                             */
                                     /*被分攤金額                             */
bgw11       varchar2(24),            /*折旧会计科目                           */
                                     /*折舊會計科目                           */
bgw12       number(5) NOT NULL,      /*起算月份                               */
                                     /*起算月份    031112 No.8563 Add         */
bgwuser     varchar2(10),            /*资料所有者                             */
bgwgrup     varchar2(10),            /*资料所有群                             */
bgwmodu     varchar2(10),            /*资料更改者                             */
bgwdate     date,                    /*最近更改日                             */
bgworiu     varchar2(10),            /*资料建立者                             */
bgworig     varchar2(10)             /*资料建立部门                           */
);

alter table bgw_file add  constraint bgw_pk primary key  (bgw01,bgw02,bgw03,bgw04,bgw07,bgw08,bgw05,bgw12,bgw06) enable validate;
grant select on bgw_file to tiptopgp;
grant update on bgw_file to tiptopgp;
grant delete on bgw_file to tiptopgp;
grant insert on bgw_file to tiptopgp;
grant index on bgw_file to public;
grant select on bgw_file to ods;
