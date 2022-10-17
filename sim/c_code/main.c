
void func(int a);

void handle_trap()
{
  while(1);
}
int main(void){

func(1);

}

void func(int a){
if(a==1){
(*(int *)0x00) = 0;
(*(int *)0x00) = 1;
(*(int *)0x00) = 2;
(*(int *)0x00) = 3;
}
}
