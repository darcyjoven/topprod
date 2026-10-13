/*
================================================================================
檔案代號:ecd_file
檔案名稱:作业资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecd_file
(
ecd01       varchar2(6) NOT NULL,    /*作业编号                               */
ecd02       varchar2(80),            /*作业说明                               */
ecd03       date,                    /*No Use                                 */
ecd04       date,                    /*No Use                                 */
ecd05       varchar2(1),             /*作业形态                               */
ecd06       varchar2(10),            /*机器编号                               */
ecd07       varchar2(10),            /*工作站编号                             */
ecd08       number(5),               /*搬运时间                               */
ecd09       number(15,3),            /*作业重叠程度                           */
ecd10       varchar2(10),            /*输出装置编号                           */
ecd11       varchar2(1),             /*成本计算基准                           */
ecd12       number(9,4),             /*损耗率                                 */
ecd13       number(5),               /*人工数                                 */
ecd14       number(5),               /*机器数                                 */
ecd15       varchar2(80),            /*说明                                   */
ecd16       number(15,3),            /*标准人工设置时间                       */
ecd17       number(15,3),            /*标准人工生产时间                       */
ecd18       number(15,3),            /*标准机器设置时间                       */
ecd19       number(15,3),            /*标准机器生产时间                       */
ecd20       number(15,3),            /*标准委外加工时间                       */
ecd21       number(20,6),            /*标准委外加工成本                       */
ecd22       varchar2(40),            /*委外加工料件                           */
ecd23       varchar2(10),            /*委外加工厂商                           */
ecd24       number(15,3),            /*排程设置时间                           */
ecd25       number(15,3),            /*排程生产时间                           */
ecd26       number(15,3),            /*排程委外加工时间                       */
ecdacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
ecduser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
ecdgrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
ecdmodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
ecddate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
ecdicd01    varchar2(1),             /*作业群组                               */
ecdslk01    varchar2(1),             /*车缝最后工艺否                         */
ecdoriu     varchar2(10),            /*资料建立者                             */
ecdorig     varchar2(10),            /*资料建立部门                           */
ta_ecd01    varchar2(100),           /*简称                                   */
ta_ecd02    varchar2(1),             /*委外否                                 */
ta_ecd03    varchar2(1),             /*是否转换站                             */
ta_ecd04    varchar2(1),             /*包装站否                               */
ta_ecd05    varchar2(1),             /*报工否                                 */
ta_ecd06    varchar2(1),
ta_ecd07    varchar2(1),
ta_ecd08    number(15),
ta_ecd09    number(15,3),
ta_ecd10    varchar2(20)
);

alter table ecd_file add  constraint ecd_pk primary key  (ecd01) enable validate;
grant select on ecd_file to tiptopgp;
grant update on ecd_file to tiptopgp;
grant delete on ecd_file to tiptopgp;
grant insert on ecd_file to tiptopgp;
grant index on ecd_file to public;
grant select on ecd_file to ods;
