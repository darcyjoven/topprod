/*
================================================================================
檔案代號:pjp_file
檔案名稱:项目多阶段收付款明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjp_file
(
pjp01       varchar2(10) NOT NULL,   /*项目编号                               */
pjp02       varchar2(1) NOT NULL,    /*收/付款                                */
pjp03       varchar2(4) NOT NULL,    /*阶段代码                               */
pjp04       varchar2(1),             /*收/付款方式                            */
pjp05       date,                    /*预估收付款日                           */
pjp06       varchar2(4),             /*里程碑编号                             */
pjp07       varchar2(1),             /*行款方式                               */
pjp08       number(20,6),            /*比例/金额                              */
pjp09       varchar2(255)            /*备注                                   */
);

alter table pjp_file add  constraint pjp_pk primary key  (pjp01,pjp02,pjp03) enable validate;
grant select on pjp_file to tiptopgp;
grant update on pjp_file to tiptopgp;
grant delete on pjp_file to tiptopgp;
grant insert on pjp_file to tiptopgp;
grant index on pjp_file to public;
grant select on pjp_file to ods;
