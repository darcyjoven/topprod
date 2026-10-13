/*
================================================================================
檔案代號:cmi_file
檔案名稱:人工/制费收集维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmi_file
(
cmi01       number(5) NOT NULL,      /*年度                                   */
cmi02       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
cmi03       varchar2(10) NOT NULL,   /*成本中心                               */
cmi04       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別 1.人工  2.製費                    */
cmi05       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
cmi06       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
cmi07       varchar2(255),           /*科目名称 /说明                         */
                                     /*科目名稱 /說明                         */
cmi08       number(20,6),            /*当期余额                               */
                                     /*當期餘額                               */
cmi09       varchar2(1),             /*No Use                                 */
cmi10       varchar2(1),             /*No Use                                 */
cmiacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
cmiuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
cmigrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
cmimodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
cmidate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
cmi051      varchar2(24),            /*科目编号二                             */
cmiorig     varchar2(10),            /*资料建立部门                           */
cmioriu     varchar2(10),            /*资料建立者                             */
cmi12       varchar2(1),             /*分摊方式                               */
cmi00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cmilegal    varchar2(10) NOT NULL,   /*所属法人                               */
cmi13       varchar2(30),            /*核算项值1                              */
cmi14       varchar2(30),            /*核算项1名称                            */
cmi15       varchar2(30),            /*核算项值2                              */
cmi16       varchar2(30),            /*核算项2名称                            */
cmi17       varchar2(30),            /*核算项值3                              */
cmi18       varchar2(30),            /*核算项3名称                            */
cmi19       varchar2(30),            /*核算项值4                              */
cmi20       varchar2(30),            /*核算项4名称                            */
cmi21       varchar2(30),            /*核算项值5                              */
cmi22       varchar2(30),            /*核算项5名称                            */
cmi23       varchar2(30),            /*核算项值6                              */
cmi24       varchar2(30),            /*核算项6名称                            */
cmi25       varchar2(30),            /*核算项值7                              */
cmi26       varchar2(30),            /*核算项7名称                            */
cmi27       varchar2(30),            /*核算项值8                              */
cmi28       varchar2(30),            /*核算项8名称                            */
cmi29       varchar2(30),            /*核算项值9                              */
cmi30       varchar2(30),            /*核算项9名称                            */
cmi31       varchar2(30),            /*核算项值10                             */
cmi32       varchar2(30),            /*核算项10名称                           */
cmi33       varchar2(30),            /*关系人                                 */
cmi34       varchar2(30),            /*关系人名称                             */
cmi35       varchar2(10)             /*项目编号                               */
);

alter table cmi_file add  constraint cmi_pk primary key  (cmi00,cmi01,cmi02,cmi03,cmi04,cmi05,cmi06) enable validate;
grant select on cmi_file to tiptopgp;
grant update on cmi_file to tiptopgp;
grant delete on cmi_file to tiptopgp;
grant insert on cmi_file to tiptopgp;
grant index on cmi_file to public;
grant select on cmi_file to ods;
