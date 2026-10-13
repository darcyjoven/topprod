/*
================================================================================
檔案代號:ecc_file
檔案名稱:工作站成本会计资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecc_file
(
ecc01       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*Workstation No.Work Site# , Maybe Manufacture Work Center/Workshop/Work Site*/
ecc02       varchar2(24),            /*直接材料会计科目                       */
ecc03       varchar2(24),            /*直接人工会计科目                       */
ecc04       varchar2(24),            /*制造费用会计科目                       */
ecc05       varchar2(24),            /*在制品会计科目                         */
eccacti     varchar2(1),             /*资料有效码                             */
eccuser     varchar2(10),            /*资料所有者                             */
eccgrup     varchar2(10),            /*资料所有群                             */
eccmodu     varchar2(10),            /*资料更改者                             */
eccdate     date,                    /*最近更改日                             */
eccoriu     varchar2(10),            /*资料建立者                             */
eccorig     varchar2(10)             /*资料建立部门                           */
);

alter table ecc_file add  constraint ecc_pk primary key  (ecc01) enable validate;
grant select on ecc_file to tiptopgp;
grant update on ecc_file to tiptopgp;
grant delete on ecc_file to tiptopgp;
grant insert on ecc_file to tiptopgp;
grant index on ecc_file to public;
grant select on ecc_file to ods;
