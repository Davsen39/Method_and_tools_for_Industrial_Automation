function respect = respect_constraints(a, b, constraints)

    next = setdiff(b,a);
    if ismember(next,constraints(:,2))
        indexes=find(constraints(:,2)==2);
        counter=0;
        for i=1:length(indexes)
            previous=constraints(indexes,1);
            if ismember(previous,a)
                counter=counter +1;
            else 
                break;
            end
        end

    if(counter == length(indexes))
        respect = 1;
    else
        respect = 0;
    end
    else 
        respect = 0;
    end
    
end