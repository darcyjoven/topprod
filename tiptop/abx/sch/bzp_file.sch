/*
================================================================================
檔案代號:bzp_file
檔案名稱:保税机器设备异动资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bzp_file
(
bzp01       varchar2(20) NOT NULL,   /*单据单号                               */
bzp02       number(5) NOT NULL,      /*单据项次                               */
bzp03       date,                    /*异动日期                               */
bzp04       varchar2(1),             /*性质                                   */
                                     /*A.Send B.Recall C.Retire D.Charge Office*/
bzp05       number(5),               /*状态                                   */
                                     /*Send:-1, Recall:1, Retire:-1, Charge Office:-1*/
bzp06       varchar2(20),            /*机器设备编号                           */
bzp07       number(5),               /*序号                                   */
bzp08       number(15,3),            /*异动数量                               */
bzp09       date,                    /*审核日期                               */
bzp10       varchar2(1),             /*No Use                                 */
bzpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bzplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bzp_file add  constraint bzp_pk primary key  (bzp01,bzp02) enable validate;
grant select on bzp_file to tiptopgp;
grant update on bzp_file to tiptopgp;
grant delete on bzp_file to tiptopgp;
grant insert on bzp_file to tiptopgp;
grant index on bzp_file to public;
grant select on bzp_file to ods;
