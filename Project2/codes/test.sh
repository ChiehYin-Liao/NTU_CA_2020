# Usage: bash test.sh
iverilog -o CPU.out *.v
for i in $(seq 1 5); do
    cp ./instruction_$i.txt instruction.txt;
    ./CPU.out > /dev/null;
    diff output_ref_$i.txt output.txt > /dev/null;
    if [ $? == 0 ]; then
        echo "Testcase $i passed"
    else
        echo "Testcase $i failed"
    fi
done
