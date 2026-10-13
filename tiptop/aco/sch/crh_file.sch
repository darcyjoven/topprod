/*
================================================================================
檔案代號:crh_file
檔案名稱:成品/材料异动冲账记录档
檔案目的:记录成品/材料之异动/报关冲帐之异动资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crh_file
(
crh01       number(10) NOT NULL,     /*冲帐序号                               */
crh02       date,                    /*冲帐日期                               */
crh03       varchar2(8),             /*冲帐时间                               */
crh04       varchar2(40),            /*商品编号                               */
crh05       varchar2(10),            /*海关编号                               */
crh06       varchar2(10),            /*客户编号/厂商编号                      */
crh07       varchar2(1),             /*异动方式                               */
crh08       varchar2(20) NOT NULL,   /*单据编号                               */
crh09       number(5) NOT NULL,      /*项次                                   */
crh10       date,                    /*单据日期                               */
crh11       varchar2(40),            /*料件编号                               */
crh12       number(20,8),            /*转换率                                 */
crh13       number(15,3),            /*异动数量                               */
crh14       varchar2(4),             /*异动单位                               */
crh15       number(15,3),            /*合同数量                               */
crh16       varchar2(4),             /*合同单位                               */
crhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table crh_file add  constraint crh_pk primary key  (crh01,crh08,crh09) enable validate;
grant select on crh_file to tiptopgp;
grant update on crh_file to tiptopgp;
grant delete on crh_file to tiptopgp;
grant insert on crh_file to tiptopgp;
grant index on crh_file to public;
grant select on crh_file to ods;
