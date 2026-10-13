/*
================================================================================
檔案代號:bhb_file
檔案名稱:费用项目提拨单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bhb_file
(
bhb01       varchar2(10) NOT NULL,   /*版本                                   */
bhb02       number(5) NOT NULL,      /*年度                                   */
bhb03       varchar2(6) NOT NULL,    /*费用项目                               */
                                     /*費用項目                               */
bhb04       varchar2(6) NOT NULL,    /*来源费用项目                           */
                                     /*來源費用項目                           */
bhb05       varchar2(1),             /*提拨方式                               */
                                     /*提撥方式 1.固定金額 2.比率             */
bhb06       number(20,6)             /*提拨比率或金额                         */
                                     /*提撥比率或金額                         */
);

alter table bhb_file add  constraint bhb_pk primary key  (bhb01,bhb02,bhb03,bhb04) enable validate;
grant select on bhb_file to tiptopgp;
grant update on bhb_file to tiptopgp;
grant delete on bhb_file to tiptopgp;
grant insert on bhb_file to tiptopgp;
grant index on bhb_file to public;
grant select on bhb_file to ods;
