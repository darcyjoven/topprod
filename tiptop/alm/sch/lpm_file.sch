/*
================================================================================
檔案代號:lpm_file
檔案名稱:发卡资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpm_file
(
lpm01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpm02       varchar2(10),            /*no use                                 */
lpm03       varchar2(20),            /*会员编号                               */
lpm04       varchar2(20),            /*卡种编号                               */
lpm05       varchar2(10),            /*发卡原因编号                           */
lpm06       varchar2(1),             /*原因类型                               */
lpm07       number(20,2),            /*最低交款金额                           */
lpm08       number(20,2),            /*购卡金额                               */
lpm09       varchar2(30),            /*会员卡卡号                             */
lpm10       varchar2(1),             /*审核码                                 */
lpm11       varchar2(10),            /*审核人                                 */
lpm12       date,                    /*审核日期                               */
lpm13       varchar2(50),            /*备注                                   */
lpm14       date,                    /*失效日期                               */
lpmacti     varchar2(1),             /*资料有效码                             */
lpmcrat     date,                    /*资料创建日                             */
lpmdate     date,                    /*资料更改日                             */
lpmgrup     varchar2(10),            /*资料所有群                             */
lpmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpmmodu     varchar2(10),            /*资料更改者                             */
lpmplant    varchar2(10),            /*所属营运中心                           */
lpmuser     varchar2(10),            /*资料所有者                             */
lpmoriu     varchar2(10),            /*资料建立者                             */
lpmorig     varchar2(10)             /*资料建立部门                           */
);

alter table lpm_file add  constraint lpm_pk primary key  (lpm01) enable validate;
grant select on lpm_file to tiptopgp;
grant update on lpm_file to tiptopgp;
grant delete on lpm_file to tiptopgp;
grant insert on lpm_file to tiptopgp;
grant index on lpm_file to public;
grant select on lpm_file to ods;
